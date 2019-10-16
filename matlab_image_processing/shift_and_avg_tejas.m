clc 
clear
params.pix_shift_x = 2;
params.pix_shift_y = 1;
params.thresh_bin = 4;
params.gauss_sigm = 3;


data_file = 'datasets/data_30Aug_2';

% img_base = imread('datasets/data_14Sep_2/us_image051.jpg');


figure('Name','base image | segmentation')
imageList = dir(strcat(data_file,'/*.jpg'));
for i=1: size(imageList,1)
    i
    img_base = imread(strcat(data_file,'/',imageList(i).name) );
    img_out=shift_filter_tejas(img_base,params);
    montage({img_base,img_out});
    waitforbuttonpress;                                           
end
