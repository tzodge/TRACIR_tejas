%Force_plate registration
z=-23.1;
x=(37.9+48.1)/2;
y=(30.25+65.75)/2;
b=[x -y z;x y z;-x y z;-x -y z]';

load('datas.mat');
s=(datas([1,2,3,4],:));
s=s';
s=s*1000;

p=b;
q=s;
%1, centroids
pc=mean(p,2);
qc=mean(q,2);
%centered vectors
x=p-pc;
y=q-qc;
%covariance matrix
sc=x*y';
%SVD
[U S V]=svd(sc);
I=eye(3);
I(3,3)=det(V*U');
%Rcal- Calculated rotation matrix from robot to body frame
Rcal=V*I*U';
%pcal- Calculated translation vector from robot to body frame
pcal=qc-Rcal*pc;
ps_cal=Rcal*b+pcal;

figure(1);
sp1=subplot(2,1,1);
plot(ps_cal(2,:),ps_cal(1,:),'go','linewidth',1.3,'markerSize',8);
hold on
plot(s(2,:),s(1,:),'bx','linewidth',1.3,'markerSize',8);
a = gca;
a.TickLabelInterpreter = 'latex';
a.Box = 'on';
a.BoxStyle = 'full';
xlabel('y','Interpreter','latex');
ylabel('x','Interpreter','latex');
zlabel('z','Interpreter','latex');
title('\begin{tabular}{c} $Segmentation\ points\ represented\ in\ I\ frame$ \\ $and\ U\ frame\ after\ calibration\ X-Y\ view$ \end{tabular}','Interpreter','latex')
%title({'$Segmentation\ points\ represented\ in\ I\ frame$','$and\ U\ frame\ after\ calibration$'},'Interpreter','latex');
legend({'$I\ frame$','$U\ frame$'},'Interpreter','latex','location','southeast');
axis([-5 5 -5 25])
daspect([1 1 1])

sp2=subplot(2,1,2);
plot(ps_cal(2,:),ps_cal(3,:),'go','linewidth',1.3,'markerSize',8);

hold on
plot(s(2,:),s(3,:),'bx','linewidth',1.3,'markerSize',8);
a = gca;
a.TickLabelInterpreter = 'latex';
a.Box = 'on';
a.BoxStyle = 'full';
xlabel('y','Interpreter','latex');
ylabel('z','Interpreter','latex');
title('\begin{tabular}{c} $Segmentation\ points\ represented\ in\ I\ frame$ \\ $and\ U\ frame\ after\ calibration\ Y-Z\ view$ \end{tabular}','Interpreter','latex')
%title({'$Segmentation\ points\ represented\ in\ I\ frame$','$and\ U\ frame\ after\ calibration$'},'Interpreter','latex');
legend({'$I\ frame$','$U\ frame$'},'Interpreter','latex','location','southeast');
axis([-5 5 -5 25])
daspect([1 1 1])
sp2.Position = sp2.Position -[0 -0.08 0 0];
Rcal
pcal
%[ 0.0001766, 0.0004486, -0.0159676, 0.9998724 ]
q=UnitQuaternion(0.9998724,[ 0.0001766, 0.0004486, -0.0159676])