function [BWsdil,centers,radii] = robust_circle_v0(I_cropped)
[~,threshold] = edge(I_cropped,'sobel');
    fudgeFactor = 0.5;
    BWs = edge(I_cropped,'sobel',threshold * fudgeFactor);

    imshow(BWs)
    "sobel gradient"
    waitforbuttonpress
    title('Binary Gradient Mask')

    se90 = strel('line',5,90);
    se0 = strel('line',5,0);
    BWsdil = imdilate(BWs,[se90 se0]);
    BWsdil = imerode(BWsdil,[se90 se0]);
    
    [centers,radii] = imfindcircles(BWsdil,[30 100],'Sensitivity',0.95)
    
    %% draw cross hair
%  
    centers=int32(centers);
%     BWsdil(centers(1),:) = 0;
%     BWsdil(:,centers(2)) = 0;
    if isempty(centers)
        disp('circle not found')
    else
        BWsdil(:,centers(1)) = 1;
        BWsdil(centers(2),:) = 1;

    end

end

