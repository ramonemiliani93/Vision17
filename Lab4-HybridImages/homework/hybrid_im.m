%Obtain a hybrid image from two different images

clc; clear all; close all;
sigma = 8; % Param. of the Gaussian radius

%Load and resize images
I1 = imread('Images/alejandro_orig.png');
I2 = imread('Images/ramon_orig.png');
I1_crop = imresize(I1, [size(I2,1), size(I2,2)]);
imwrite(I1_crop, 'Images/alejandro_crop.png')

%Compute hybrid image
hybrid_im = I2-imgaussfilt(I2, sigma) + imgaussfilt(I1_crop, sigma);
imshow(hybrid_im)