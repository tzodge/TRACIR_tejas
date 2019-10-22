clc
clear
syms px py pz
syms Tax Tay Taz
syms Fax Fay Faz
% 
% px =-0.026;
% py = -0.01;
% pz = 0.046 ;
% 
% Tax = (0.0174-0.0148);
% Tay = (0.086-0.067);
% Taz = (0.2106-0.21);
% 
% Fax = (-0.438+0.39429);
% Fay = -2.48+2.6;
% Faz = -15.41+13.91;



Ta = [Tax; Tay; Taz];
Fa = [Fax; Fay; Faz];

a = [0 -pz py;
     pz 0 -px;
    -py px 0];

R = [1,0,0;
    0 ,0, 1;
    0 ,-1, 0 ];

 
AdT_au = [R,zeros(3,3);
          a*R,R];  
      
AdT_au'*[Ta;Fa]      