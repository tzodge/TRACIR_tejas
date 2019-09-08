%US_Scan_flat
%US_image
% clear;
% clc;
% clf;
% close all;
count = 1;
data_loader
load('calibration.mat');
load('usprobe_pose.mat');
%fig16-25.png in us_flat_scan_2 replaced by correponding image in us_flat_scan_1 
for i=1:837
%
%I = imread('8.jpg');
%I2=rgb2gray(I);
%I2=I2(59:499,398:733);
if(i<10)
I2= iread(['~/TRACIR/data_2Sep_2/us_image00',int2str(i),'.jpg'],'double','grey');
elseif(i>9)&&(i<100)
I2= iread(['~/TRACIR/data_2Sep_2/us_image0',int2str(i),'.jpg'],'double','grey');
else
I2= iread(['~/TRACIR/data_2Sep_2/us_image',int2str(i),'.jpg'],'double','grey');
end
I2=I2(59:479,100:430);
figure(1);
% imshow(I2);
disp(i)
%smoothing-rvc p.397
%monadic-rvc p.371

% figure(4)
% imshow(imgaussfilt(clean)<.2);
figure(5)
f=ismooth(I2,2)<0.18;
%imshow(f);
% out = hitormiss(I2, S);
% figure(5);
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
[centers,radii] = imfindcircles(f,[30 70],'Sensitivity',0.915) %0.915
if length(centers)~=0
    contri(count) = i;
    count = count+1;
end
%h = viscircles(centers,radii);
if(length(centers)==0) 
    
    continue; 
end;
for j=1:size(centers,1)
    plotCircle3D(((R*(Rcal*[diag([sx,sy])*centers(j,:)';0]+pcal))+p)',R(:,3)',sx*radii(j));
    hold on;
end
%imgradient
%local adaptive thresholding
%Ellipse Detection Using 1D Hough Transform
end
daspect([1 1 1]);
axis vis3d;
title('Ultrasound vein reconstruction using circle hough transform');
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');