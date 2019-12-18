
function image = generate_circle(bw_image, radius, center)
%     imageSizeX = 640;
%     imageSizeY = 480;
    [imageSizeY,imageSizeX] = size(bw_image);
    [columnsInImage ,rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
 
    centerX = center(1);
    centerY = center(2);
    circlePixels = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= radius.^2;
    mask = 1-circlePixels ;
     
    img = uint8(mask).* bw_image;
    image = uint8(img);
end