clear all;
close all; clc;
format compact;
dataset = 'data_2'
myFolder = strcat(pwd,'/',dataset,'/');
centers_list = load( strcat(myFolder,'centers_list.mat') );
filePattern = fullfile(myFolder, '*.png');
png_files = dir(filePattern);
filename = strcat(myFolder ,png_files(1).name);
img_1 = imread( filename ); 


v = [1,-1]';
alpha = 300;
beta = 1;
gamma = 1;
dt = 1;

data_start = 1; data_end = 40;
P_init = gamma*[(size(img_1,2))^2,0; ...
                0,(size(img_1,1))^2];  
      
R_default = [900,0;0,900];
R = eye(2);
Q = beta *eye(2)*2;
% x_init = imfindcircles(img_3,[50,100])';
H = eye(2);

% x_km1 =x_init;
P_km1 = P_init;
error = zeros(length(png_files),1);
X_actual = zeros(length(png_files),2);
X_kalman = zeros(length(png_files),2);
Z_actual = zeros(length(png_files),2);
Z_kalman_dyn = zeros(length(png_files),2);
Error = zeros(length(png_files),2);
P_list = zeros(length(png_files),2);

Xkm = [321,322;...
       239,238];
   
X_kalman(1,:) = Xkm(1:2,1);
X_kalman(2,:) = Xkm(1:2,2);

X_actual(1,:) = X_kalman(1,:);
X_actual(2,:) = X_kalman(2,:);

% Z_actual(1,:) = X_kalman(1,:);
% Z_actual(2,:) = X_kalman(2,:);
timestep = 1:60;
for k = 3:length(png_files)
    filename = sprintf(strcat(dataset,'/img_%d.png'), k);
    sensor_all = imfindcircles(uint8(255-imread(filename)),[50,120],'Sensitivity',0.98)';
    number_circles = size(sensor_all,2);
    if size(sensor_all)~= 0 
        sensor_value = mean(sensor_all,2);
        R = number_circles*[var(sensor_all(1,1:end)),0;0,var(sensor_all(2,1:end))]+ [20,0;0,20];
    else
        sensor_value = [0;0];
        R = [size(img_1,2),0;0,size(img_1,1)]
    end
    A = [ 2-(Xkm(1,1)/Xkm(1,2)), 0;...
          0, 2-(Xkm(2,1)/Xkm(2,2))] ;
      
    x_kalman_predict = A*[Xkm(1,2);Xkm(2,2)];
    P_kalman_predict = A*P_km1*A' + Q
    
    
%     S = H*P_kalman_predict*H' + R
%     K = P_kalman_predict*H'*inv(S)
%     y = sensor_value - H*x_kalman_predict
    
    K = P_kalman_predict*H'*inv( H*P_kalman_predict*H'+R)
    x_kalman_update = x_kalman_predict+ K*(sensor_value - H*x_kalman_predict)
    P_kalman_update = (eye(2) - K*H)*P_kalman_predict
    
%     x_kalman_update = x_kalman_predict + K*y
%     P_kalman_update = (eye(size(x_kalman_update))-K*H)*P_kalman_predict
    
    Xkm = [Xkm(1,2),x_kalman_update(1);Xkm(2,2),x_kalman_update(2)]
    P_km1 = P_kalman_update
%     waitforbuttonpress
    X_actual(k,:) = centers_list.centers_list(k,:)';
    Z_actual(k,:) = sensor_value;
    X_kalman(k,:) = x_kalman_update;
    Error(k,:) = centers_list.centers_list(k,:)' - x_kalman_update;
    P_list(k,1) = P_kalman_update(1,1);
    P_list(k,2) = P_kalman_update(2,2);
end

figure(1)
plot(timestep,X_kalman(:,1),'--','DisplayName','Estimated from kalman x','LineWidth',3);
hold on
% plot(x_k_dyn_array(:,1),'DisplayName','x_k_dyn  x','LineWidth',3);
plot(timestep,Z_actual(:,1),'DisplayName','sensor measurement x','LineWidth',3);
scatter(timestep,X_actual(:,1),'filled','DisplayName','Ground truth x');
legend

figure(2)
plot(X_kalman(:,2),'--','DisplayName','Estimated from kalman x','LineWidth',3);
hold on
% plot(x_k_dyn_array(:,2),'DisplayName','x_k_dyn y','LineWidth',3);
plot(timestep,Z_actual(:,2),'DisplayName','sensor measurement y','LineWidth',3);
scatter(timestep,X_actual(:,2),'filled','DisplayName','Ground truth y');
legend
figure(3)
plot(P_list(3:end,1),'DisplayName','Covariance Estimated in x','LineWidth',3);
hold on
plot(P_list(3:end,2),'--','DisplayName','Covariance Estimated in y','LineWidth',3);

plot_circles(X_kalman,dataset)