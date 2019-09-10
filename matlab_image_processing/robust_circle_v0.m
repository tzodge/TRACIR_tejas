function [BWsdil,centers,radii] = robust_circle_v0(I_cropped)
[~,threshold] = edge(I_cropped,'sobel');
    fudgeFactor = 0.5;
    BWs = edge(I_cropped,'sobel',threshold * fudgeFactor);

%     imshow(BWs)
    title('Binary Gradient Mask')

    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    BWsdil = imdilate(BWs,[se90 se0]);
%     imshow(BWsdil)
    [centers,radii] = imfindcircles(1-BWsdil,[20 500],'Sensitivity',0.915)
    % draw cross hair
    centers=int32(centers);
%     BWsdil(centers(1),:) = 0;
%     BWsdil(:,centers(2)) = 0;
    if isempty(centers)
        disp('circle not found')
    else
        BWsdil(:,centers(1)) = 0;
        BWsdil(centers(2),:) = 0;

    end

end

