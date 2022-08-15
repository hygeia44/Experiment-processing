close all
clearvars
wd = 'data/';
files = dir(strcat(wd,'*.csv'));
%struct2cell(files.name)
fls = natsortfiles({files.name});
numFiles = length(files);

for k = 1:numFiles
    % print working file name
    %files(k).name
    % load biastreach data from csv
    % read Length Wigth Thickness from csv, width is transvese, chanel1, length is vertical, chanel 2
    L_W_T = LWT(string(strcat(wd, fls(k))));
    %L_W_T = LWT([wd files(k).name]);
    %output{k,1} = files(k).name;
    output{k,1} = fls(k);
    output{k,2} = L_W_T(3);
end