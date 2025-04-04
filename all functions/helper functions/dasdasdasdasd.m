

clear
clc

% im = imread('BG3 13500 x 0009 Ceta.jpg');
im = imread('RandomlyRotateImageExample_01.png');

im = im(200:300,200:300,1);

[old_sz_y,old_sz_x] = size(im);

% rotate
theta = 30;
tform = affine2d([ ...
    cosd(theta) sind(theta) 0;...
    -sind(theta) cosd(theta) 0; ...
    0 0 1]);
new_image = imwarp(im,tform);

[new_sz_y,new_sz_x] = size(new_image);

disp(new_sz_y/old_sz_y);
disp(new_sz_x/old_sz_x);

% rescale
% theta = 30;
tform = affine2d([ ...
    old_sz_y/new_sz_y 0 0;...
    0 old_sz_y/new_sz_y 0; ...
    0 0 1])
new_image = imwarp(new_image,tform);



figure
imagesc(im);
colormap(gray(500));
figure
imagesc(new_image);
colormap(gray(500));



