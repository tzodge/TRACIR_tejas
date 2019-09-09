function plotCircle3D(center,normal,radius,image_num)

theta=0:0.01:2*pi;
v=null(normal);
points=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
plot3(points(1,:),points(2,:),points(3,:),'r-');
size(points)
hold on;
textscatter3(points(1,1),points(2,1),points(3,1),string(image_num));
end