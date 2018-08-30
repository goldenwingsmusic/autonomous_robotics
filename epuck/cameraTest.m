% open up connection
h = kOpenPort();
% be sure that no other command clogs up the line
kSetSpeed(h,0,0);
% first, set the parameters to color image, 40 times 40 pixels, no zoom
% (zoom can be either 1, 4, or 8)
kSetCameraParameters(h,1,40,40,8);
% get an image
tic
result = kGetImage(h);
toc
% flip image (will be fixed in kGetImage soon)
result(:,:,1) = fliplr(result(:,:,1));
result(:,:,2) = fliplr(result(:,:,2));
result(:,:,3) = fliplr(result(:,:,3));
figure(1)
imagesc(result);

% now switch to grayscale, same resolution and zoom
kSetCameraParameters(h,0,40,40,8);
% get an image
tic
result = kGetImage(h);
toc
% flip image (will be fixed in kGetImage soon)
result(:,:) = fliplr(result(:,:));
figure(2)
imagesc(result);
colormap(gray);

% back to rgb, but different resolution this time
kSetCameraParameters(h,1,80,20,8);
% get an image
tic
result = kGetImage(h);
toc
% flip image (will be fixed in kGetImage soon)
result(:,:,1) = fliplr(result(:,:,1));
result(:,:,2) = fliplr(result(:,:,2));
result(:,:,3) = fliplr(result(:,:,3));
figure(3)
imagesc(result);
%don't forget to adjust window size to see the landscape image

% as fast as it gets, grayscale and pixels << 1600
kSetCameraParameters(h,0,80,10,8);
% get an image
tic
result = kGetImage(h);
toc
% flip image (will be fixed in kGetImage soon)
result(:,:) = fliplr(result(:,:));
figure(4)
imagesc(result);
colormap(gray);
% finished
kClose(h);