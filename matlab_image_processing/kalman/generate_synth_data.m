clc;
clear; 
vx = 1;
vy = -1;
v = [vx, vy]; 
dt = 1;
center = [320,240];
n_images = 60; 
radius =  100;
max_circles = 4;
detect_circle_probability = 0.8;
max_error_center = 100;

filename= 'data_2';
mkdir(filename);
centers_list = zeros(n_images,2);
for i = 1: n_images
    center_curr = center + i*dt*v;
    centers_list(i,:) = center_curr;
    base_image = uint8(ones(480,640)*255);
    if rand < detect_circle_probability
        base_image = generate_circle(base_image,radius ,center_curr);
        num_circles = randn(max_circles);
        for k=1:num_circles
            base_image = generate_circle(base_image,radius , ...
                                         center_curr +[randi(max_error_center),randi(max_error_center)] );
        end
    end 
    imshow(base_image)
    viscircles(center_curr,3)
    waitforbuttonpress
    imwrite(base_image,  sprintf(strcat(filename,'/img_%d.png'), i)) ;
end
 
save(strcat(filename,'/centers_list.mat'),'centers_list');

% function image = generate_circle(bw_image, radius, center)
% %     imageSizeX = 640;
% %     imageSizeY = 480;
%     [imageSizeY,imageSizeX] = size(bw_image);
%     [columnsInImage ,rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%  
%     centerX = center(1);
%     centerY = center(2);
%     circlePixels = (rowsInImage - centerY).^2 ...
%         + (columnsInImage - centerX).^2 <= radius.^2;
%     mask = circlePixels ;
%     img = mask .* bw_image;
%     image = uint8(255 * img);
% end