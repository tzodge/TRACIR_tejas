%US_Scan_flat
%US_image
tic()
clear;
clc;
clf;
close all;
count = 1;
%% read files
data_file = 'data_8Sep_2';
load('calibration.mat');
load('usprobe_pose.mat');
addpath('rvctools/');
load_probe_position(data_file);
imageList = dir(strcat(data_file,'/*.jpg'));

img_base_num = 844;
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
    I2 = ismooth(I2,2) < 0.3;

    figure(1);
%     imshow(I2);
%     waitforbuttonpress
    disp(i)
    %smoothing-rvc p.397
    %monadic-rvc p.371
    
%     figure(4)
    % imshow(imgaussfilt(clean)<.2);
%     figure(5)
%     f=ismooth(I2,2)<0.5;
%     imshow(f);
%     figure(6);
    % out = hitormiss(I2, S);
%     figure(5);
    % imshow(out)
    
    % % Iu = iconvolve(f, kdgauss(1) );
    % % Iv = iconvolve(f, kdgauss(1)' );
    % % ff = sqrt( Iu.^2 + Iv.^2 );
    % % figure(6);
    % % imshow(ff);
    
    %gausian blurr
    %Hough transform
    %d=imdistline;
    q=UnitQuaternion(us_pose(i,4),us_pose(i,5:7));
    p=us_pose(i,1:3)'*1000;
    R=q.R;
    [BWsdil,centers,radii] = robust_circle_v0(I2);
%     imshow(BWsdil)
 
%     
%     [centers,radii] = imfindcircles(f,[30 70],'Sensitivity',0.915); %0.915
 
    
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
    %imgradient
    %local adaptive thresholding
    %Ellipse Detection Using 1D Hough Transform
%     waitforbuttonpress;
end
daspect([1 1 1]);
axis vis3d;
title('Ultrasound vein reconstruction using circle hough transform');
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');

toc()