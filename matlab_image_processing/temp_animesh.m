clc
clear
close all
data_file = 'data_30Aug_2';
fileList = dir(strcat(data_file,'/*.jpg'));



base_num = 162;
for i = 1:size(fileList ,1)
    img_circ_str =  strcat(data_file,'/',fileList(i).name);
    img_circ = imread(img_circ_str); %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i ==1
        [J,rect2] = imcrop(img_circ);
        rect2 = uint16(rect2);
        rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];
    end 
    img_circ = img_circ(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));

    img_base_str =  strcat(data_file,'/',fileList(base_num).name);
    img_base = imread(img_base_str); %%%%%%%%%%%%%%%%%%%%%%%%%%%

    % img_base = rgb2gray(img_base);
    img_base = img_base (rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));


%     imshow(img_base);
%     "img_base"
%     waitforbuttonpress

%     imshow(img_circ);
%     "img_circ"
%     waitforbuttonpress


    img_subt = img_circ-img_base; %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     imshow(img_subt)
    img_subt = ismooth(img_subt,2) < 0.5; %%%%%%%%%%%%%%%%%%%%%%%%%%%
    img_circ = ismooth(img_circ,2) < 0.5;
    "img_subt"
    imshow(img_subt);
    figure()
    "img_circ"
%     img_subt(50:50+70,50:50+70) = 1;
    imshow(img_circ);
    waitforbuttonpress
    


    "tejas code"
    [centers,radii] = imfindcircles(img_subt,[50 120],'Sensitivity',0.95)
    centers_32=int32(centers);
    if isempty(centers_32)
        disp('circle not found')
    else
        img_subt(:,centers_32(1)) = 1;
        img_subt(centers_32(2),:) = 1;
    end 

    "mike code"
    centers =[];
    [centers,radii] = imfindcircles(img_circ,[50 120],'Sensitivity',0.95)
    if isempty(centers_32)
        disp('circle not found')
    else
        img_circ(:,centers_32(1)) = 1;
        img_circ(centers_32(2),:) = 1;
    end 
    % [BWsdil,centers,radii] = robust_circle_v0(BW2); %%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all
end 