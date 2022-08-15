%% process peeling test
% col: stretch load/width/thickness  mean and stress cir vs. long, tangent modulus
%when figure pop up, select the peak load region(begin and end 2 clicks) to calculate mean delamination strength
% copy the results from output double click
close all
clearvars
wd = 'Input_data/';
wd1 = 'Input_data/raw_ataa_peel/';
wd2 = 'Output data/';
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);
% OutputResult = 'File1';
alph = 1 ; % N1 - 11, alph= 0.5. The rest alph = 1; N20 = -0.5;
% beta = 1; % all displacement and force ae synced 
cth = 0; % 0=do not correct force thrshhold, 1=correct force threshold 

for k = 1:numFiles
    % print working file name
    files(k).name
    
    % read Length Width Thickness from csv, width is transvese, chanel1, length is vertical, chanel 2
    L_W_T = LWT([wd files(k).name]);
    
    % load biastreach data from csv
    Mr = csvread(strcat(wd, files(k).name),6,0);
    
    % M =  original matrix [ position1 position3 Load1] in csv file
    Mr = Mr(:,[4 6 2]);
    %Load devided by 2 for N1-11 and 20
    Mr = [Mr(:,1) Mr(:,2) Mr(:,3)*alph];
    
    %elongation in mm
    M1 = Mr(:,1)-min(Mr(:,1))+ Mr(:,2)- min(Mr(:,2)) ;
    %M1 = M1/L_W_T(2)+1;
    %force in N
    M2 = Mr(:,3);
    % tension = Load1/L (N/mm) 
    M3 = Mr(:,3)/L_W_T(1);
    %elongation/original width stretch
    M4 = M1/L_W_T(2) ;
    M = [M1 M2 M3 M4];
    M = rmmissing(M);
    
    if cth == 1
    figure('Name', [files(k).name,'Tension (Force/width) vs. Elongation ///pick the force threshold '])
    set(gcf, 'Position', [50, 70, 1200, 500])
    subplot(2,1,1);
    plot(M(:,1));
    subplot(2,1,2);
    plot(M(:,2));
%     plot(M(1:3500,1));%choose the M2 range
%     ylim([-1 1.5]);
    % get points of: 1 residual force after failure but before unloading, 
    % get points 2, redisual stress after unloading
%   [p1, p2] = ginput(2);
     p1 = ginput(1);   
    %frc_low = round(p1(1))-10 ; %M1_low = input('low boundary')
    %frc_up = round(p1(2))-20;  %M1_up =  input('upper boundary')
    
    %M1 = M(frc_low:frc_up, 1)- M(frc_low,1) +1;
    res1 = mean(M(round(p1(1))-2:round(p1(1))+2, 2));
%    res2 = mean(M(round(p1(2))-10:round(p1(2))+10, 2));
%     res = (res1-res2)/2 ;
%     M2 = M(:, 2)- res1 + res;
    M2 = M(:, 2) - res1 ;
    M3 = M2/L_W_T(1);
    %M3 = M(frc_low:frc_up, 3)- M(frc_low,3) +1;
    %M4 = M(frc_low:frc_up, 4)- M(frc_low,4) +1;
    
    Mt =[M(:,1) M2 M3 M(:,4)];
    %Mt = smoothdata(Mt, 'gaussian',10);
    close 
    elseif cth == 0
    Mt = M ;
    end
    figure('Name', [files(k).name,'+++adjusted Tension (Force/width) Elongation ////pick mean force range'])
    set(gcf, 'Position', [50, 70, 1200, 500])
    subplot(2,1,1);
    plot(Mt(:,1));
%    plot(M(1:3500,1));%choose the M2 range
    subplot(2,1,2);
    plot(Mt(:,2));
%      ylim([-1 1.5])
    % pick mean value(force) rang 
    [p3, p4] = ginput(2);
       
    frc_low = round(p3(1)) ; %M1_low = input('low boundary')
    frc_up = round(p3(2));  %M1_up =  input('upper boundary')
% calculate single parameters for each CSV  
    % t = 100;
    % mean delamination strength 
    sd = mean(Mt(frc_low:frc_up,3));
    fmean = mean(Mt(frc_low:frc_up,2));
    elomax = Mt(frc_up, 1) ;
    % total energy 2*(force/width)*
    wtol = 2*sd*elomax/2 ; 
    wela = sd*(elomax/2 - L_W_T(2)) ;
    % dissection energy
    wdisc = (wtol - wela)/L_W_T(2) ;
    % fracture energy
    wfra = fmean*elomax ;
    % energy relese rate
    wrls = fmean*elomax/L_W_T(1)/L_W_T(2) ;
  
    fid=fopen(strcat(wd2, files(k).name),'w');
    fprintf(fid,'%s, %s, %s, %s\n', 'elongation','force', 'force/width', 'elong/length');
    fclose(fid);
    dlmwrite(strcat(wd2, files(k).name),Mt, '-append');
    
    %move file to done_Uni in Input data folder
     movefile(strcat(wd, files(k).name), strcat(wd1, files(k).name), 'f');
    
% output parameters    
    output{k,1} = files(k).name;
    output{k,2} = sd;
    output{k,3} = fmean;
    output{k,4} = elomax;
    output{k,5} = wtol;
    output{k,6} = wela ;
    output{k,7}= wdisc ;
    output{k,8}= wfra ;
    output{k,9}= wrls ;
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

