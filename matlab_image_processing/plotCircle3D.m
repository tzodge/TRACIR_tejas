function plotCircle3D(center,normal,radius,image_num)

%% to plot circles
% theta=0:0.1:2*pi;
% v=null(normal);
% 
% points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
% plot3(points(1,:),points(2,:),points(3,:),'r-');
%% to plot centers only
hold on;
size(center)
scatter3(center(1),center(2),center(3),'r*');
textscatter3(center(1),center(2),center(3),string(image_num));
end