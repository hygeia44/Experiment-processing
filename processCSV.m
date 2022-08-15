close all
clearvars
wd ='Input_data/*.csv'
files = dir(wd);
numFiles = length(files);

%1st column is the file names; 2nd column is the max values;
%3rd column is the average values.
output = cell(numFiles,3);

for k = 1:numFiles
    output{k,1} = files(k).name;
    [output{k,2},output{k,3}] = readCSV(strcat(wd, output{k,1}));
end
