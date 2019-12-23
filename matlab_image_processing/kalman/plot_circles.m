function plot_circles(centre_list, dataset)
myFolder = strcat(pwd,'/',dataset,'/');
centers_list = load( strcat(myFolder,'centers_list.mat') );
filePattern = fullfile(myFolder, '*.png');
png_files = dir(filePattern);
filename = strcat(myFolder ,png_files(1).name);
img_1 = imread( filename );

for i = 1:60
    filename = sprintf(strcat(dataset,'/img_%d.png'), i);
    imshow(filename)
    viscircles(centre_list(i,1:2),100)
    waitforbuttonpress
end