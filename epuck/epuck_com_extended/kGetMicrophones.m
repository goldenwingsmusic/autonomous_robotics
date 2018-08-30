function r = kGetMicrophones(ref)
%KGETMICROPHONES   Get the microphone levels
%
%value = kGetMicrophones(ref)
%  Returns a vector of 3 values corresponding to the microphone amplitudes
%  Use the reference obtained with kOpenPort.

reply = kcmd(ref,'U');
[value,count,errmsg] = sscanf(reply,'u,%d,%d,%d');
if isempty(errmsg)
   r = value;
else
   r = -1;
end

