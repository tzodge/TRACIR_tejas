%US_Scan_flat
%US_image
tic()
clear;
clc;
clf; 
close all;
count = 1;
%% read files
data_file = 'datasets/data_14Sep_2';

load('calibration.mat');
load('usprobe_pose.mat');
addpath('rvctools/');
load_probe_position(data_file);
imageList = dir(strcat(data_file,'/*.jpg'));
image_frame_origin = uint32([158,37]);
% image_frame_origin = uint32([0,0]);


max_circ_per_img = 3;
center3d_list = zeros(size(imageList,1),3*max_circ_per_img ); 

resluts_save_dir = strcat(data_file,'/results');
mkdir(resluts_save_dir)
fig_reconstruction = figure;
daspect([1 1 1]);
 axis([-90 -60 600 620 340 440])
% fig_centroid_3d = figure;
%% run code
for i=1: size(imageList,1)
    I_original = imread(strcat(data_file,'/',imageList(i).name) );
    %% to crop the area of image only
    
    if i == 1
        disp("select imaging area")
        [J,rect2] = imcrop(I_original);
        rect2 = uint32(rect2);
        rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];
        offset = [rect_coord(3),rect_coord(1)] ;
%         fig_centroid_3d = figure;
    end
    
    I2= I_original(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));
    
    disp (offset)
    disp(i)
    
    q=UnitQuaternion(us_pose(i,4),us_pose(i,5:7));
    p=us_pose(i,1:3)'*1000;
    R=q.R;
%[centers,radii] = imfindcircles(I2,[30 70],'Sensitivity',0.915) %0.915
    [BWsdil,centers,radii] = robust_circle_v1(I2);
    
    if length(centers)~=0
%         close
        centers = centers + double(offset);
        
        plot_on = 0;
        if plot_on == 1
            fig2 = figure;
            figure(fig2 );
            imshow(I_original);
            hold on;
            viscircles(image_frame_origin,3,'Color','g');
            viscircles([rect_coord(3),rect_coord(1)],3,'Color','b');
            viscircles(centers,radii);
            pause()
            close (fig2) ;
        end
        centers = centers-double(image_frame_origin);
        contri(count) = i;
        count = count+1;
    end
    
    if(length(centers)==0)
        continue;
    end
    for j=1:size(centers,1)
        centers(j,:)
        center_3d=((R*(Rcal*[diag([sx,sy])*centers(j,:)';0]+pcal))+p)';
        normal=R(:,3)';
        radius=sx*radii(j);
        center3d_list (i,3*(j-1)+1:3*(j-1)+3) = center_3d ;
        
        plotCircle3D(fig_reconstruction,center_3d,normal,radius,i);
%         pause()
%         plotCenters3D(fig_centroid_3d,center_3d,i);
        hold on;
        if j > max_circ_per_img
            break
        end
            
    end

%     savename = strcat('/reconstruct_result_',string(i),'.png');
%     full_path = strcat(resluts_save_dir,savename);
%     saveas(fig_reconstruction,full_path);
end
figure (1)
daspect([1 1 1]);
axis vis3d;
title('Ultrasound vein reconstruction using circle hough transform');
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');

toc()