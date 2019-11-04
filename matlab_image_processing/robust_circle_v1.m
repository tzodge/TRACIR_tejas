function [img_circ_gausf,centers,radii] = robust_circle_v1(img_circ_grey)

if min(img_circ_grey(:))> 30 ||  max(img_circ_grey(:))< 220
    img_circ_grey_double = double(img_circ_grey);
    img_circ_norm=(img_circ_grey_double-min(img_circ_grey_double(:)))/   ...
        (max(img_circ_grey_double(:))-min(img_circ_grey_double(:)));
    img_circ_norm = uint8(img_circ_norm*255);
else
    img_circ_norm = img_circ_grey;
end

img_circ_hist = histeq(img_circ_norm );

img_circ_gaus1=imgaussfilt(img_circ_hist,10);
img_circ_gaus2=imgaussfilt(img_circ_hist,50);
img_circ_gausf = img_circ_gaus1- img_circ_gaus2;

[centers, radii]=imfindcircles(255-img_circ_gausf,[30 60],'Sensitivity',0.85);
polt_on = 0;
if ~isempty(centers) && polt_on ==1
    fig3 = figure();
    figure(fig3);
    imshow(img_circ_grey)
    viscircles(centers,radii,'Color','g');
    pause
    close (fig3)
    plot_centers(img_circ_grey,centers,radii);
end

end

