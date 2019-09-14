function [] = plot_centers(img_gray,centers,radii)
centers_32=int32(centers);
img_rgb = cat(3, img_gray, img_gray, img_gray);
% imshow(img_rgb);
viscircles(centers_32,radii);

end

