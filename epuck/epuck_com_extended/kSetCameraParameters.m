function r = kSetCameraParameters(ref,mode,width,height,zoom)
%SetCameraParameters   set the camera parameters for the e-puck camera
%
%kSetCameraParameters(ref,mode,width,height,zoom)
%
% ref - handle obtained by kOpenPort
%
% mode - 0 for grayscale, 1 for rgb
%
% width - width in pixel (width * height must be <= 1600)
%
% height - height in pixel (width * height must be <= 1600)
%
% zoom - zoom factor, can be 1, 4, or 8 - for lower values, the camera zooms in
%  

% Written by Stephan Zibner, 10.09.2010
if (~(mode == 0 | mode == 1))
  'Error: mode must be 0 or 1'
elseif (width*height > 1600 | width*height < 1)
  'Error: the product of width and height must be >0 and <1600'
elseif (~(zoom == 1 | zoom == 4 | zoom == 8))
  'Error: zoom must be either 1,4, or 8'
else
  value = kcmd(ref,sprintf('J,%d,%d,%d,%d',round(mode),round(width),round(height),round(zoom)));
  if value == 'j'
     r = 0;
  else
     r = -1;
  end
end

