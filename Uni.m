%% Process Failure testing
% stretch load/width/thickness  failure stretch and stress cir vs. long, tangent modulus
%when figure pop up, select from the begining to the load drop close to 0
% then use the Uni_peak_slope.m to calculte the failure stress and peak
% tangent modulus
close all
clearvars
wd = 'Input_data/';
wd1 = 'Input_data/raw_ataa_falr/';
wd2= 'Output data/' ;
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);
% OutputResult = 'File1';
alph = 0.5 ; % N1 - 11, alph= 0.5. The rest alph = 1; N20 = -0.5;
beta = 1; % 0not sync/1sync N 1, 2, 10, 11 beta = 0, stress strain not syncronized, the rest Beta = 1;

for k = 1:numFiles
    % print working file name
    files(k).name
    
    % read Length Wigth Thickness from csv, width is transvese, chanel1, length is vertical, chanel 2
    L_W_T = LWT([wd files(k).name]);
    
    % load biastreach data from csv
    Mr = csvread(strcat(wd, files(k).name),6,0);
    
    % M =  original matrix [ position1 position3 Load1] in csv file
    Mr = Mr(:,[4 6 2 10]);
    %Load devided by 2 for N1-11 and 20
    Mr = [Mr(:,1) Mr(:,2) Mr(:,3)*alph Mr(:,4)];
    
    %stretch
    M1 = Mr(:,1)-min(Mr(:,1))+ Mr(:,2)- min(Mr(:,2)) ;
    M1 = M1/L_W_T(2)+1;
    %strain
    M2 = Mr(:,4);
    %convert lagrangian strain to true strain
    M2= 1- 1./sqrt(2.*M2+1) ;
    % StressCir1 = Load1/L/T*1000 while StressLong2 = Load2/W/T*1000, KPa
    M3 = Mr(:,3)/L_W_T(1)/L_W_T(3)*1000;
    %convert engieering stress to True stress
    lamda = M1 ;   
    M3 = M3.*lamda ;
%   M3 = M3.*sqrt(2.*Mr(:,4)+1);
    M = [M1 M2 M3];
    M = rmmissing(M);
       
    figure('Name','TrueStress')
    set(gcf, 'Position', [50, 70, 1200, 500])
    subplot(2,1,1);
    plot(M(1:length(M),3));%choose the M2 range
    subplot(2,1,2);
    plot(M(1:length(M),2));
    [p1, p2] = ginput(2);
       
    m3_low = round(p1(1)); %M1_low = input('low boundary')
    m3_up = round(p1(2));  %M1_up =  input('upper boundary')
    
    if beta ==1
    M1 = M(m3_low:m3_up+20, 1)- M(m3_low,1) +1;
    M2 = M(m3_low:m3_up+20, 2)- M(m3_low,2) +1;
    M3 = M(m3_low:m3_up+20, 3)- p2(1);
    
    elseif beta ==0
    figure('Name','Strain')
    set(gcf, 'Position', [30, 90, 1200, 500])
    plot(M(:,2));%choose the strain range
    [m2x, m2y] = ginput(2);
    m2_low = round(m2x(1)); %M1_low = input('low boundary')
    m2_up = round(m2x(2));  %M1_up =  input('upper boundary')
    
    len = min([m2_up-m2_low, m3_up-m3_low]);
    [xm2, ym2] = find(M(m2_low:m2_up, 2)== max(M(m2_low:m2_up, 2)));
    [xm3, ym3] = find(M(m3_low:m3_up, 3)== max(M(m3_low:m3_up, 3)));
    M1 = M(xm3(1)+m3_low-len:xm3(1)+m3_low-1,1)- min(M(xm3(1)+m3_low-len:xm3(1)+m3_low-1, 1))+1;  
    M2 = M(xm2(1)+m2_low-len:xm2(1)+m2_low-1,2)- min(M(xm2(1)+m2_low-len:xm2(1)+m2_low-1, 2))+1; 
    M3 = M(xm3(1)+m3_low-len:xm3(1)+m3_low-1,3)- min(M(xm3(1)+m3_low-len:xm3(1)+m3_low-1, 3)); 
    end
    Mt =[M1 M2 M3];
    Mt = smoothdata(Mt, 'gaussian',10);
    % tangent modulus before failure last t points 
%     t = 100;
%     idx1= find (M2 == max(Mt(:,2)));
%     M1f = M1((idx1-t):idx1);
%     M2f = M2((idx1-t):idx1);
%     tm =  polyfit(M1f, M2f, 1);
  
    fid=fopen(strcat(wd2, files(k).name),'w');
    fprintf(fid,'%s, %s, %s\n', 'Stretch','Stretch (strain)', 'True Stress');
    fclose(fid);
    dlmwrite(strcat(wd2, files(k).name),Mt, '-append');
    
    %move file to done_Uni in Input data folder
      movefile(strcat(wd, files(k).name), strcat(wd1, files(k).name));
    
%output tangent modulus    
% output{k,1} = files(k).name;
% % output{k,2} = 'failure stretch';
% % output{k,4} = 'failure stress';
% output{k,2} = Mt(idx1,1);
% output{k,3} = max(Mt(:,2));
% % output{k,6} = 'Tangent modulus before failure';
% output{k,4} = tm(1);
close all
clc;
end

function yms = mono(y)
x = 1:1:length(y);
n = length(x);
C = eye(n);
D = y;
A = diag(ones(n,1),0) - diag(ones(n-1,1),1);
A(end,:) = [];
b = zeros(n-1,1);
opts = optimset('lsqlin');
opts.LargeScale = 'off';
opts.Display = 'none';
ym = lsqlin(C,D,A,b,[],[],[],[],[],opts);
yms = smoothdata(ym, 'gaussian',10);
plot(x,y,'ro',x,ym,'b-*', x,yms,'g-');
end

