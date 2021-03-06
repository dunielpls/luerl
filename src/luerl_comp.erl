%% Copyright (c) 2013 Robert Virding
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

%% File    : luerl_comp.erl
%% Author  : Robert Virding
%% Purpose : A basic LUA 5.2 compiler for Luerl.

%% This is the main loop of the Luerl compiler. While we can handle
%% errors in this loop they should never occur as Lua basically allows
%% almost everything that gets past the parser. The only exception are
%% goto's to undefined labels, but we don't handle goto's yet.
%%
%% We also have the first pass here. It normalises the code and
%% converts to an internal form.

-module(luerl_comp).

-export([file/1,file/2,string/1,string/2,forms/1,forms/2]).

-export([debug_print/3]).

-import(lists, [member/2,keysearch/3,mapfoldl/3]).

-include_lib("kernel/include/file.hrl").

-include("luerl.hrl").
-include("luerl_comp.hrl").

-record(comp, {base="",				%Base name
	       odir=".",			%Output directory
	       lfile="",			%Lua file
	       opts=[],				%User options
	       code=none,			%Code after last pass.
	       errors=[],
	       warnings=[]
	      }).

file(Name) -> file(Name, [verbose,report]).

file(Name, Opts) ->
    St0 = #comp{opts=Opts},
    St1 = filenames(Name, St0),
    compile(file_passes(), St1).

%% filenames(File, State) -> State.
%%  The default output dir is the current directory unless an
%%  explicit one has been given in the options.

filenames(File, St) ->
    %% Test for explicit outdir.
    Odir = case keysearch(outdir, 1, St#comp.opts) of
	       {value,{outdir,D}} -> D;
	       false -> "."
	   end,
    Dir = filename:dirname(File),
    Base = filename:basename(File, ".lua"),
    Lfile = filename:join(Dir, Base ++ ".lua"),
    St#comp{base=Base,
	    lfile=Lfile,
	    odir=Odir}.

string(Str) -> string(Str, [verbose,report]).

string(Str, Opts) when is_binary(Str) ->
    string(binary_to_list(Str), Opts);
string(Str, Opts) when is_list(Str) ->
    St0 = #comp{opts=Opts,code=Str},
    St1 = filenames("-no-file-", St0),
    compile(list_passes(), St1).

forms(Forms) -> forms(Forms, [verbose,report]).

forms(Forms, Opts) ->
    St0 = #comp{opts=Opts,code=Forms},
    St1 = filenames("-no-file-", St0),
    compile(forms_passes(), St1).

compile(Ps, St0) ->
    case do_passes(Ps, St0) of
	{ok,St1} -> do_ok_return(St1);
	{error, St1} -> do_error_return(St1)
    end.

%% file_passes() -> [Pass].
%% list_passes() -> [Pass].
%% forms_passes() -> [Pass].
%%  Build list of passes.

file_passes() ->				%Reading from file
    [{do,fun do_read_file/1},
     {do,fun do_parse/1}|
     forms_passes()].

list_passes() ->				%Scanning string
    [{do,fun do_scan/1},
     {do,fun do_parse/1}|
     forms_passes()].

forms_passes() ->				%Doing the forms
    [{do,fun do_init_comp/1},
     {do,fun do_comp_normalise/1},
     {do,fun do_comp_vars/1},
     {when_flag,to_vars,{done,fun(St) -> {ok,St} end}},
     %% {do,fun do_comp_locf/1},
     {do,fun do_comp_env/1},
     {when_flag,to_env,{done,fun(St) -> {ok,St} end}},
     {do,fun do_code_gen/1},
     {unless_flag,no_iopt,{do,fun do_peep_op/1}}].

%% do_passes(Passes, State) -> {ok,State} | {error,Reason}.
%%  Interpret the list of commands in a pass.
%%
%%  Commands can be one of:
%%
%%  {when_flag,Flag,Cmd}
%%  {unless_flag,Flag,Cmd}
%%  {do,Fun}
%%  {done,PrintFun,Ext}

do_passes([{do,Fun}|Ps], St0) ->
    case Fun(St0) of
	{ok,St1} -> do_passes(Ps, St1); 
	{error,St1} -> {error,St1}
    end;
do_passes([{when_flag,Flag,Cmd}|Ps], St) ->
    case member(Flag, St#comp.opts) of
	true -> do_passes([Cmd|Ps], St);
	false -> do_passes(Ps, St)
    end;
do_passes([{unless_flag,Flag,Cmd}|Ps], St) ->
    case member(Flag, St#comp.opts) of
	true -> do_passes(Ps, St);
	false -> do_passes([Cmd|Ps], St)
    end;
do_passes([{done,Fun}|_], St) ->
    Fun(St);
do_passes([], St) -> {ok,St}.

%% do_read_file(State) -> {ok,State} | {error,State}.
%% do_scan(State) -> {ok,State} | {error,State}.
%% do_parse(State) -> {ok,State} | {error,State}.
%% do_init_comp(State) -> {ok,State} | {error,State}.
%% do_comp_normalise(State) -> {ok,State} | {error,State}.
%% do_comp_vars(State) -> {ok,State} | {error,State}.
%% do_comp_env(State) -> {ok,State} | {error,State}.
%% do_comp_cg(State) -> {ok,State} | {error,State}.
%% do_comp_peep(State) -> {ok,State} | {error,State}.
%%  The actual compiler passes.

do_read_file(#comp{lfile=Name,opts=Opts}=St) ->
    %% Read the bytes in a file skipping an initial # line or Windows BOM.
    case file:open(Name, [read]) of
	{ok,F} ->
	    %% Check if first line a script or Windows BOM, if so skip it.
	    case io:get_line(F, '') of
		"#" ++ _ -> ok;			%Skip line
		[239,187,191|_] ->
		    file:position(F, 3);	%Skip BOM
		_ -> file:position(F, bof)	%Get it all
	    end,
	    %% Now read the file.
	    Ret = case io:request(F, {get_until,latin1,'',luerl_scan,tokens,[1]}) of
		      {ok,Ts,_} ->
			  debug_print(Opts, "scan: ~p\n", [Ts]),
			  {ok,St#comp{code=Ts}};
		      {error,E,L} -> {error,St#comp{errors=[{L,io,E}]}}
		  end,
	    file:close(F),
	    Ret;
	{error,E} -> {error,St#comp{errors=[{none,file,E}]}}
    end.

do_scan(#comp{code=Str,opts=Opts}=St) ->
    case luerl_scan:string(Str) of
	{ok,Ts,_} ->
	    debug_print(Opts, "scan: ~p\n", [Ts]),
	    {ok,St#comp{code=Ts}};
	{error,E,_} -> {error,St#comp{errors=[E]}}
    end.

do_parse(#comp{code=Ts,opts=Opts}=St) ->
    case luerl_parse:chunk(Ts) of
	{ok,Chunk} ->
	    debug_print(Opts, "parse: ~p\n", [Chunk]),
	    {ok,St#comp{code=Chunk}};
	{error,E} -> {error,St#comp{errors=[E]}}
    end.

do_init_comp(#comp{}=St) ->
    %% Initialise the compiler state.
    Cst = #cst{opts=St#comp.opts,
	       lfile=list_to_binary(St#comp.lfile)},
    %% The code now includes compiler state.
    C1 = #code{code=St#comp.code,cst=Cst},
    {ok,St#comp{code=C1}}.

do_comp_normalise(#comp{code=C0,opts=Opts}=St) ->
    case luerl_comp_normalise:chunk(C0, Opts) of
	{ok,C1} -> {ok,St#comp{code=C1}};
	{error,Es} -> {error,St#comp{errors=Es}}
    end.

do_comp_vars(St) ->
    case luerl_comp_vars:chunk(St#comp.code, St#comp.opts) of
	{ok,C1} -> {ok,St#comp{code=C1}};
	{ok,C1,Ws} -> {ok,St#comp{code=C1,warnings=Ws}};
	{error,Es} -> {error,St#comp{errors=Es}}
    end.

%% do_comp_locf(St) ->
%%     case luerl_comp_locf:chunk(St#comp.code, St#comp.opts) of
%% 	{ok,C1} -> {ok,St#comp{code=C1}};
%% 	{ok,C1,Ws} -> {ok,St#comp{code=C1,warnings=Ws}};
%% 	{error,Es} -> {error,St#comp{errors=Es}}
%%     end.

do_comp_env(St) ->
    case luerl_comp_env:chunk(St#comp.code, St#comp.opts) of
	{ok,C1} -> {ok,St#comp{code=C1}};
	{ok,C1,Ws} -> {ok,St#comp{code=C1,warnings=Ws}};
	{error,Es} -> {error,St#comp{errors=Es}}
    end.

do_code_gen(St) ->
    case luerl_comp_cg:chunk(St#comp.code, St#comp.opts) of
	{ok,C1} -> {ok,St#comp{code=C1}};
	{ok,C1,Ws} -> {ok,St#comp{code=C1,warnings=Ws}};
	{error,Es} -> {error,St#comp{errors=Es}}
    end.

do_peep_op(St) ->
    case luerl_comp_peep:chunk(St#comp.code, St#comp.opts) of
	{ok,C1} -> {ok,St#comp{code=C1}};
	{ok,C1,Ws} -> {ok,St#comp{code=C1,warnings=Ws}};
	{error,Es} -> {error,St#comp{errors=Es}}
    end.

do_ok_return(#comp{code=C}) -> {ok,C}.

do_error_return(#comp{errors=Es,warnings=Ws}) ->
    {error,Es,Ws}.

debug_print(Opts, Format, Args) ->
    case member(debug_print, Opts) of
	true -> io:fwrite(Format, Args);
	false -> ok
    end.
