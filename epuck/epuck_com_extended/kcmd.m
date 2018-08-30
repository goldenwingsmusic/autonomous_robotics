function r = kcameracmd(ref,cmd,multiline)
%KCMD     high-level command for communicating with Khepera
%
%kcameracmd(command, multiline)
%  send a single command to Khepera (command shouldn't contain
%  the cr)
%
%r = kcmd(command)
%  send a command to Khepera and set r to its reply (without cr)
%
%r = kcmd(command, multiline)
%  continue receiving until timeout if multiline


if nargin <= 2
	multiline = 0;
end

cmdlf = [cmd,10];	% add a linefeed
if multiline
	r = eval('ksend(cmdlf,ref,0)');
		% use static buffer if the dynamic buffer is not supported
else
	r = eval('ksend(cmdlf,ref)');
end
