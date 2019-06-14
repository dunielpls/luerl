-module(luerl_util).

-export([errname_info/1]).

%% Convert error names to errnos and strings.
%% Made using the following command (`errno' from the moreutils package):
%% `errno -l | awk '{print "errname_info("tolower($1)") -> [{errno,"$2"},{str,\""substr($0,index($0,$3))"\"}];"}''
errname_info(eperm) -> [{errno,1},{str,"Operation not permitted"}];
errname_info(enoent) -> [{errno,2},{str,"No such file or directory"}];
errname_info(esrch) -> [{errno,3},{str,"No such process"}];
errname_info(eintr) -> [{errno,4},{str,"Interrupted system call"}];
errname_info(eio) -> [{errno,5},{str,"Input/output error"}];
errname_info(enxio) -> [{errno,6},{str,"No such device or address"}];
errname_info(e2big) -> [{errno,7},{str,"Argument list too long"}];
errname_info(enoexec) -> [{errno,8},{str,"Exec format error"}];
errname_info(ebadf) -> [{errno,9},{str,"Bad file descriptor"}];
errname_info(echild) -> [{errno,10},{str,"No child processes"}];
errname_info(eagain) -> [{errno,11},{str,"Resource temporarily unavailable"}];
errname_info(enomem) -> [{errno,12},{str,"Cannot allocate memory"}];
errname_info(eacces) -> [{errno,13},{str,"Permission denied"}];
errname_info(efault) -> [{errno,14},{str,"Bad address"}];
errname_info(enotblk) -> [{errno,15},{str,"Block device required"}];
errname_info(ebusy) -> [{errno,16},{str,"Device or resource busy"}];
errname_info(eexist) -> [{errno,17},{str,"File exists"}];
errname_info(exdev) -> [{errno,18},{str,"Invalid cross-device link"}];
errname_info(enodev) -> [{errno,19},{str,"No such device"}];
errname_info(enotdir) -> [{errno,20},{str,"Not a directory"}];
errname_info(eisdir) -> [{errno,21},{str,"Is a directory"}];
errname_info(einval) -> [{errno,22},{str,"Invalid argument"}];
errname_info(enfile) -> [{errno,23},{str,"Too many open files in system"}];
errname_info(emfile) -> [{errno,24},{str,"Too many open files"}];
errname_info(enotty) -> [{errno,25},{str,"Inappropriate ioctl for device"}];
errname_info(etxtbsy) -> [{errno,26},{str,"Text file busy"}];
errname_info(efbig) -> [{errno,27},{str,"File too large"}];
errname_info(enospc) -> [{errno,28},{str,"No space left on device"}];
errname_info(espipe) -> [{errno,29},{str,"Illegal seek"}];
errname_info(erofs) -> [{errno,30},{str,"Read-only file system"}];
errname_info(emlink) -> [{errno,31},{str,"Too many links"}];
errname_info(epipe) -> [{errno,32},{str,"Broken pipe"}];
errname_info(edom) -> [{errno,33},{str,"Numerical argument out of domain"}];
errname_info(erange) -> [{errno,34},{str,"Numerical result out of range"}];
errname_info(edeadlk) -> [{errno,35},{str,"Resource deadlock avoided"}];
errname_info(enametoolong) -> [{errno,36},{str,"File name too long"}];
errname_info(enolck) -> [{errno,37},{str,"No locks available"}];
errname_info(enosys) -> [{errno,38},{str,"Function not implemented"}];
errname_info(enotempty) -> [{errno,39},{str,"Directory not empty"}];
errname_info(eloop) -> [{errno,40},{str,"Too many levels of symbolic links"}];
errname_info(ewouldblock) -> [{errno,11},{str,"Resource temporarily unavailable"}];
errname_info(enomsg) -> [{errno,42},{str,"No message of desired type"}];
errname_info(eidrm) -> [{errno,43},{str,"Identifier removed"}];
errname_info(echrng) -> [{errno,44},{str,"Channel number out of range"}];
errname_info(el2nsync) -> [{errno,45},{str,"Level 2 not synchronized"}];
errname_info(el3hlt) -> [{errno,46},{str,"Level 3 halted"}];
errname_info(el3rst) -> [{errno,47},{str,"Level 3 reset"}];
errname_info(elnrng) -> [{errno,48},{str,"Link number out of range"}];
errname_info(eunatch) -> [{errno,49},{str,"Protocol driver not attached"}];
errname_info(enocsi) -> [{errno,50},{str,"No CSI structure available"}];
errname_info(el2hlt) -> [{errno,51},{str,"Level 2 halted"}];
errname_info(ebade) -> [{errno,52},{str,"Invalid exchange"}];
errname_info(ebadr) -> [{errno,53},{str,"Invalid request descriptor"}];
errname_info(exfull) -> [{errno,54},{str,"Exchange full"}];
errname_info(enoano) -> [{errno,55},{str,"No anode"}];
errname_info(ebadrqc) -> [{errno,56},{str,"Invalid request code"}];
errname_info(ebadslt) -> [{errno,57},{str,"Invalid slot"}];
errname_info(edeadlock) -> [{errno,35},{str,"Resource deadlock avoided"}];
errname_info(ebfont) -> [{errno,59},{str,"Bad font file format"}];
errname_info(enostr) -> [{errno,60},{str,"Device not a stream"}];
errname_info(enodata) -> [{errno,61},{str,"No data available"}];
errname_info(etime) -> [{errno,62},{str,"Timer expired"}];
errname_info(enosr) -> [{errno,63},{str,"Out of streams resources"}];
errname_info(enonet) -> [{errno,64},{str,"Machine is not on the network"}];
errname_info(enopkg) -> [{errno,65},{str,"Package not installed"}];
errname_info(eremote) -> [{errno,66},{str,"Object is remote"}];
errname_info(enolink) -> [{errno,67},{str,"Link has been severed"}];
errname_info(eadv) -> [{errno,68},{str,"Advertise error"}];
errname_info(esrmnt) -> [{errno,69},{str,"Srmount error"}];
errname_info(ecomm) -> [{errno,70},{str,"Communication error on send"}];
errname_info(eproto) -> [{errno,71},{str,"Protocol error"}];
errname_info(emultihop) -> [{errno,72},{str,"Multihop attempted"}];
errname_info(edotdot) -> [{errno,73},{str,"RFS specific error"}];
errname_info(ebadmsg) -> [{errno,74},{str,"Bad message"}];
errname_info(eoverflow) -> [{errno,75},{str,"Value too large for defined data type"}];
errname_info(enotuniq) -> [{errno,76},{str,"Name not unique on network"}];
errname_info(ebadfd) -> [{errno,77},{str,"File descriptor in bad state"}];
errname_info(eremchg) -> [{errno,78},{str,"Remote address changed"}];
errname_info(elibacc) -> [{errno,79},{str,"Can not access a needed shared library"}];
errname_info(elibbad) -> [{errno,80},{str,"Accessing a corrupted shared library"}];
errname_info(elibscn) -> [{errno,81},{str,".lib section in a.out corrupted"}];
errname_info(elibmax) -> [{errno,82},{str,"Attempting to link in too many shared libraries"}];
errname_info(elibexec) -> [{errno,83},{str,"Cannot exec a shared library directly"}];
errname_info(eilseq) -> [{errno,84},{str,"Invalid or incomplete multibyte or wide character"}];
errname_info(erestart) -> [{errno,85},{str,"Interrupted system call should be restarted"}];
errname_info(estrpipe) -> [{errno,86},{str,"Streams pipe error"}];
errname_info(eusers) -> [{errno,87},{str,"Too many users"}];
errname_info(enotsock) -> [{errno,88},{str,"Socket operation on non-socket"}];
errname_info(edestaddrreq) -> [{errno,89},{str,"Destination address required"}];
errname_info(emsgsize) -> [{errno,90},{str,"Message too long"}];
errname_info(eprototype) -> [{errno,91},{str,"Protocol wrong type for socket"}];
errname_info(enoprotoopt) -> [{errno,92},{str,"Protocol not available"}];
errname_info(eprotonosupport) -> [{errno,93},{str,"Protocol not supported"}];
errname_info(esocktnosupport) -> [{errno,94},{str,"Socket type not supported"}];
errname_info(eopnotsupp) -> [{errno,95},{str,"Operation not supported"}];
errname_info(epfnosupport) -> [{errno,96},{str,"Protocol family not supported"}];
errname_info(eafnosupport) -> [{errno,97},{str,"Address family not supported by protocol"}];
errname_info(eaddrinuse) -> [{errno,98},{str,"Address already in use"}];
errname_info(eaddrnotavail) -> [{errno,99},{str,"Cannot assign requested address"}];
errname_info(enetdown) -> [{errno,100},{str,"Network is down"}];
errname_info(enetunreach) -> [{errno,101},{str,"Network is unreachable"}];
errname_info(enetreset) -> [{errno,102},{str,"Network dropped connection on reset"}];
errname_info(econnaborted) -> [{errno,103},{str,"Software caused connection abort"}];
errname_info(econnreset) -> [{errno,104},{str,"Connection reset by peer"}];
errname_info(enobufs) -> [{errno,105},{str,"No buffer space available"}];
errname_info(eisconn) -> [{errno,106},{str,"Transport endpoint is already connected"}];
errname_info(enotconn) -> [{errno,107},{str,"Transport endpoint is not connected"}];
errname_info(eshutdown) -> [{errno,108},{str,"Cannot send after transport endpoint shutdown"}];
errname_info(etoomanyrefs) -> [{errno,109},{str,"Too many references: cannot splice"}];
errname_info(etimedout) -> [{errno,110},{str,"Connection timed out"}];
errname_info(econnrefused) -> [{errno,111},{str,"Connection refused"}];
errname_info(ehostdown) -> [{errno,112},{str,"Host is down"}];
errname_info(ehostunreach) -> [{errno,113},{str,"No route to host"}];
errname_info(ealready) -> [{errno,114},{str,"Operation already in progress"}];
errname_info(einprogress) -> [{errno,115},{str,"Operation now in progress"}];
errname_info(estale) -> [{errno,116},{str,"Stale file handle"}];
errname_info(euclean) -> [{errno,117},{str,"Structure needs cleaning"}];
errname_info(enotnam) -> [{errno,118},{str,"Not a XENIX named type file"}];
errname_info(enavail) -> [{errno,119},{str,"No XENIX semaphores available"}];
errname_info(eisnam) -> [{errno,120},{str,"Is a named type file"}];
errname_info(eremoteio) -> [{errno,121},{str,"Remote I/O error"}];
errname_info(edquot) -> [{errno,122},{str,"Disk quota exceeded"}];
errname_info(enomedium) -> [{errno,123},{str,"No medium found"}];
errname_info(emediumtype) -> [{errno,124},{str,"Wrong medium type"}];
errname_info(ecanceled) -> [{errno,125},{str,"Operation canceled"}];
errname_info(enokey) -> [{errno,126},{str,"Required key not available"}];
errname_info(ekeyexpired) -> [{errno,127},{str,"Key has expired"}];
errname_info(ekeyrevoked) -> [{errno,128},{str,"Key has been revoked"}];
errname_info(ekeyrejected) -> [{errno,129},{str,"Key was rejected by service"}];
errname_info(eownerdead) -> [{errno,130},{str,"Owner died"}];
errname_info(enotrecoverable) -> [{errno,131},{str,"State not recoverable"}];
errname_info(erfkill) -> [{errno,132},{str,"Operation not possible due to RF-kill"}];
errname_info(ehwpoison) -> [{errno,133},{str,"Memory page has hardware error"}];
errname_info(enotsup) -> [{errno,95},{str,"Operation not supported"}];
errname_info(_) -> [{errno,0},{str,"Unknown error occured"}].