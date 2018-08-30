function image = kGetImage(ref)
%KGETIMAGE   Get an image
%
%value = kGetImage(ref)
%
% ref - handle obtained by kOpenPort
%
% value - returned image

retries = 3;
retry = 1;
errmsg = 'none yet';
%while errmsg & (retry <= retries)
   image = kcameracmd(ref,'I');
%end
%SZ no error handling here!
%if errmsg
%	disp('Encoders failed.')
%	r = -1;
%end
