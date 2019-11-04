function plotCenters3D(fig1,center,image_num)
%% to plot centers only
hold on;
figure(fig1)
scatter3(center(1),center(2),center(3),'r*');
% textscatter3(center(1),center(2),center(3),string(image_num));
end