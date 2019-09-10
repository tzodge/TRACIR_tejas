% reference: https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

clc
clear

for i = 1:100
    data_file = 'data_8Sep_2';
    fileList = dir(strcat(data_file,'/*.jpg'));
    imagename = strcat(data_file,'/',fileList(i).name)
    I = imread(imagename);
 
    I_cropped = I;
    % [x,y] = ginput(n)
    % rect = getrect(I_cropped)
    if i==1
        [J,rect2] = imcrop(I_cropped);
        rect2 = uint16(rect2);
    end
    rect_coord = [rect2(2),rect2(2)+rect2(4), rect2(1),rect2(1)+rect2(3)];
    I_cropped = I_cropped(rect_coord(1):rect_coord(2), rect_coord(3):rect_coord(4));


    [BWsdil,centers,radii] = robust_circle_v0(I_cropped);

    imshow(BWsdil)
    
%     title('Dilated Gradient Mask')
%  
% 
%     BWdfill = imfill(BWsdil,'holes');
% 
%     BWdfill  = imdilate(BWdfill ,[se90 se0]);
%     imshow(BWdfill)
%     w = waitforbuttonpress;
%     
%     title('Binary Image with Filled Holes')
%     uint8Image = uint8(255 * (1-BWdfill));
%     I_eq = adapthisteq(uint8Image );
%     imshow(I_eq)
%     w = waitforbuttonpress;
%     
%     
%     bw = im2bw(I_eq, graythresh(I_eq));
%     imshow(bw)
%     w = waitforbuttonpress;
% 
%     bw2 = imfill(bw,'holes');
%     bw3 = imopen(bw2, ones(5,5));
%     bw4 = bwareaopen(bw3, 40);
%     bw4_perim = bwperim(bw4);
%     overlay1 = imoverlay(I_eq, bw4_perim, [.3 1 .3]);
%     [centers,radii] = imfindcircles(overlay1,[20 70],'Sensitivity',0.915) 
%     
%     imshow(overlay1)
    w = waitforbuttonpress;
end
