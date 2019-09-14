clc
clear
close all
data_file = 'data_2Sep_2';
fileList = dir(strcat(data_file,'/*.jpg'));

base_num = 162;
img_circ_num = 1;

img_circ_str =  strcat(data_file,'/',fileList(img_circ_num).name); 
img_circ_grey = rgb2gray(imread(img_circ_str));  

[J,rect2] = imcrop(img_circ_grey);
close 
rect2 = uint16(rect2);
rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];

img_circ_grey = img_circ_grey(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));  

robust_circle_v1(img_circ_grey)
% if min(img_circ_grey(:))> 30 ||  max(img_circ_grey(:))< 220
%     img_circ_grey_double = double(img_circ_grey);
%     img_circ_norm=(img_circ_grey_double-min(img_circ_grey_double(:)))/   ...
%                 (max(img_circ_grey_double(:))-min(img_circ_grey_double(:)));            
%     img_circ_norm = uint8(img_circ_norm*255);
% else
%     img_circ_norm = img_circ_grey;
% end
%  
% img_circ_hist = histeq(img_circ_norm );
%  
% img_circ_gaus1=imgaussfilt(img_circ_hist,10);
% img_circ_gaus2=imgaussfilt(img_circ_hist,50);
% img_circ_gausf = img_circ_gaus1- img_circ_gaus2;
% [centers, radii]=imfindcircles(255-img_circ_gausf,[30 50],'Sensitivity',0.9);
% % plot_centers(img_circ_gausf,centers,radii)