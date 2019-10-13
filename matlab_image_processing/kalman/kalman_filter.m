
clear all;
close all; clc;
format compact;
 
myFolder = strcat(pwd,'/data/');
centers_list = load( strcat(myFolder,'centers_list.mat') );
filePattern = fullfile(myFolder, '*.png');
png_files = dir(filePattern);
filename = strcat(myFolder ,png_files(1).name);
img_1 = imread( filename ); 
 

% for k = 1:length(png_files)
%     filename = strcat(myFolder ,png_files(k).name);
%     
% end


v = [1,-1]';
alpha = 100;
beta = 01;
gamma = 1;
dt = 1;

data_start = 1; data_end = 101;
P_init = gamma*[size(img_1,2)^2,0; ...
          0,size(img_1,1)^2];  

R = alpha*eye(2);
Q = beta *eye(2);
x_init = imfindcircles(img_1,[50,100])';
H = eye(2);

x_km1 =x_init;
P_km1 = P_init;
error = zeros(length(png_files),1);
x_gt_array = zeros(length(png_files),2);
x_k_array = zeros(length(png_files),2);
z_k_array = zeros(length(png_files),2);
x_k_dyn_array = zeros(length(png_files),2);

for k = 1:length(png_files)
% for k = 1:5
    %% SENSOR MEASUREMENT
    
%     filename = strcat(myFolder ,png_files(k).name)
    filename = sprintf('data/img_%d.png', k);
    z_k = imfindcircles(imread(filename),[50,120])';
    z_k = z_k + (rand(2,1)-0.5)*50 
    %% PREDICTION STEP
    
    A = [(1 + v(1)*dt/x_km1(1)), 0; ...
         0, (1 + v(2)*dt/x_km1(2))] ;
     
    x_k_dyn = A*x_km1;  
    P_k_dyn = A*P_km1*A' + Q;
    
    %% UPDATE STEP
    K = P_k_dyn*H'*inv( H*P_k_dyn*H'+R);
    x_k = x_k_dyn+ K*(z_k - H*x_k_dyn);
    P_k = (eye(2) - K*H)*P_k_dyn;
    
    x_km1 = x_k;
    P_km1 = P_k;

    x_k_gt = centers_list.centers_list(k,:)'; 
    x_k
    z_k
    error(k)= norm(x_k-x_k_gt);
    z_k_array(k,:) = z_k;
    x_k_array(k,:) = x_k;
    x_gt_array(k,:) = x_k_gt;
    x_k_dyn_array(k,:) = x_k_dyn;
end

%% plotting 
% plot(error,'LineWidth',3)
figure(1)
plot(x_k_array(:,1),'DisplayName','x_k  x','LineWidth',3);
hold on
plot(x_k_dyn_array(:,1),'DisplayName','x_k_dyn  x','LineWidth',3);
plot(z_k_array(:,1),'DisplayName','z_k x','LineWidth',3);
plot(x_gt_array(:,1),'DisplayName','x_{gt} x','LineWidth',3);
legend

figure(2)
plot(x_k_array(:,2),'DisplayName','x_k  y','LineWidth',3);
hold on
plot(x_k_dyn_array(:,2),'DisplayName','x_k_dyn y','LineWidth',3);
plot(z_k_array(:,2),'DisplayName','z_k y','LineWidth',3);
plot(x_gt_array(:,2),'DisplayName','x_{gt} y','LineWidth',3);
legend

figure(3)
scatter(x_k_array(:,1),x_k_array(:,2),'filled','DisplayName','x_k');
hold on
scatter(z_k_array(:,1),z_k_array(:,2),'filled','DisplayName','z_k y' );
scatter(x_k_dyn_array(:,1),x_k_dyn_array(:,2),'filled','DisplayName','x_k_dyn y' );
scatter(x_gt_array(:,1),x_gt_array(:,2),'filled','DisplayName','x_{gt} y');
legend
