clc;
clear; 
vx = 1;
vy = -1;
v = [vx, vy]; 
dt = 1;
center = [320,240];
n_images = 50; 
radius =  100;
% fig = figure();
mkdir('data');
centers_list = zeros(n_images,2);
for i = 1: n_images
    center_curr = center + i*dt*v;
    centers_list(i,:) = center_curr;
    img_out = generate_circle(radius ,center_curr);
    uint8Image = uint8(255 * img_out);
    imshow(img_out)
    viscircles(center_curr,3)
    waitforbuttonpress
    imwrite(img_out,  sprintf('data/img_%d.png', i)) ;
end
 
save('data/centers_list.mat','centers_list')
function image = generate_circle(radius, center)
    
    imageSizeX = 640;
    imageSizeY = 480;
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
 
    centerX = center(1)
    centerY = center(2)
    circlePixels = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= radius.^2;
    image = circlePixels ;
end