clc
clear
close all
data_file = 'data_30Aug_2';
fileList = dir(strcat(data_file,'/*.jpg'));


img_circ_str =  strcat(data_file,'/',fileList(104).name);
img_circ = imread(img_circ_str);

[J,rect2] = imcrop(img_circ);
rect2 = uint16(rect2);
rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];
img_circ = img_circ(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));


% img_circ = rgb2gray(img_circ);


img_base_str =  strcat(data_file,'/',fileList(162).name);
img_base = imread(img_base_str);

% img_base = rgb2gray(img_base);
img_base = img_base (rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));


% 
imshow(img_base);
"img_base"
waitforbuttonpress

imshow(img_circ);
"img_circ"
waitforbuttonpress


img_subt = img_circ-img_base;
imshow(img_subt)
img_subt = ismooth(img_subt,2) < 0.5
"img_subt"
waitforbuttonpress

[BWsdil,centers,radii] = robust_circle_v0(img_subt);

imshow(BWsdil)
 