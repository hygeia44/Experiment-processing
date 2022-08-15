%calculate the failure stress and peak tanent modulus based on the processed failure data 
% popup figure, pick the two points before failure for peak tangent modulus
close all
clearvars
wd = 'Input_data/';
%wd1 = 'Input_data/done_uni/';
%wd2= 'Output data/' ;
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);


for k = 1:numFiles
    % print working file name
    files(k).name
    % load biastreach data from csv
    Mr = csvread(strcat(wd, files(k).name),6,0);
    idx= find (Mr(:,3) == max(Mr(:,3)));
    output{k,1} = files(k).name;
    output{k,2} = Mr(idx,1);
    output{k,3} = max(Mr(:,3));
    %output{k,4} = Mr(idx,2);
% Tangent modulus section
    figure('Name',files(k).name)
    set(gcf, 'Position', [50, 70, 1200, 500])
    plot(Mr(:,1),Mr(:,3));%choose the M2 range
    [p1, p2] = ginput(2);
      
    InRange = (Mr(:,1)>=p1(1)) & (Mr(:,1)<=p1(2));
    M1 = Mr(InRange, 1);
    M2 = Mr(InRange, 3);
    tm =  polyfit(M1, M2, 1);
    output{k,5} = tm(1) ;
   close all
   %clearvars
end

