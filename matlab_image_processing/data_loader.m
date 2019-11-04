%%%%%%%%% I suspect that this file is not been used anywhere
%%%%%%%%% Don't delete unless confirmed

function data_loader(data_file)
%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /home/abhimanyu/TRACIR/data_29Aug/ultrasound_scan_flat.txt
%
% Auto-generated by MATLAB on 30-Aug-2019 14:37:37

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "e06", "e1", "e05"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
file_name = strcat("~/",data_file,"/ultrasound_scan_flat.txt");
ultrasoundscanflat = readtable(file_name, opts);
us_pose = table2array(ultrasoundscanflat);
save('usprobe_pose.mat','us_pose')

%% Clear temporary variables
clear opts