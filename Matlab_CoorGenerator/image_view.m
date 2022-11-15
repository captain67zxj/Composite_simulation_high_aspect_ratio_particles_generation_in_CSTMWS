function image_view(I)
% Mark Tschopp
% 2016
% Quick image view function that doesn't require
% the MATLAB Image Processing toolbox
imagesc(I);
colormap(gray);
axis off;
axis equal;