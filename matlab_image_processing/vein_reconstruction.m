%US_Scan_flat
%US_image
tic()
clear;
clc;
clf;
close all;
count = 1;
%% read files
data_file = 'data_30Aug_2';
load('calibration.mat');
load('usprobe_pose.mat');
addpath('rvctools/');
load_probe_position(data_file);
imageList = dir(strcat(data_file,'/*.jpg'));

img_base_num = 187; %data_8Sep 187
% img_base_num = 302; %data_30Aug_2

img_base = imread(strcat(data_file,'/',imageList(img_base_num).name) );
%% run code
for i=1: size(imageList,1)
    I2 = imread(strcat(data_file,'/',imageList(i).name) );
    %% to crop the area of image only 
    
    if i == 1
        disp("select imaging area")
        [J,rect2] = imcrop(I2);
        rect2 = uint16(rect2);
        rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];
        img_base = img_base(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));
    end
    
    I2= I2(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));
    I2 = I2-img_base;
    I2 = ismooth(I2,2) < 0.5;

    figure(1);
 
    disp(i)
 
    q=UnitQuaternion(us_pose(i,4),us_pose(i,5:7));
    p=us_pose(i,1:3)'*1000;
    R=q.R;
    [centers,radii] = imfindcircles(I2,[30 70],'Sensitivity',0.915) %0.915
%     [BWsdil,centers,radii] = robust_circle_v0(I2);
%     imshow(BWsdil)
     
    if length(centers)~=0
        contri(count) = i;
        count = count+1;
    end
    %h = viscircles(centers,radii);
    if(length(centers)==0)
        
        continue;
    end
    for j=1:size(centers,1)
        centers(j,:)
        center=((R*(Rcal*[diag([sx,sy])*centers(j,:)';0]+pcal))+p)';
        normal=R(:,3)';
        radius=sx*radii(j);
        plotCircle3D(center,normal,radius,i);
        hold on;
        
        
    end
 
end
daspect([1 1 1]);
axis vis3d;
title('Ultrasound vein reconstruction using circle hough transform');
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');

toc()