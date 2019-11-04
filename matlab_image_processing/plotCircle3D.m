function plotCircle3D(fig1,center,normal,radius,image_num)

%% to plot circles
figure(fig1);
% xlim([-90 -60 ]); ylim([600 620 ]); zlim([340 440])
axis([-90 -60 600 620 340 440])
view(-25,7)
daspect([1 1 1]);
%  axis equal
theta=0:0.1:2*pi;
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
plot3(points(1,:),points(2,:),points(3,:),'r-');
%% to plot centers only
hold on;
% scatter3(center(1),center(2),center(3),'r*');
% textscatter3(center(1),center(2),center(3),string(image_num));
end