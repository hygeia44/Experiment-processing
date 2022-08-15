%% cauchy stress= true stress, 
% width is transvese, chanel1, length is vertical, chanel 2
%first Piola-Kirchhoff stress= nominal stress=engineering stress
% measured are green-Lagrange strain, second Piola-Kirchhoff stress.
%when figure pop up, select one full loading cycle from the showing figure 
close all
clearvars
wd = 'Input_data/';
wd2 = 'Output data/';
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);
alph = 1; % N1-11, alph= 0.5. The rest alph = 1; N20 = -0.5; N16 has no pulm
beta = 1; %0/1 equal  2=unequal; N1 N2 N10 N11 beta=0 stress strain not syncronized, rest of equal biaxial Beta = 1; =2 for unequal biaxial data
ss = 0; %1 ss=1 make monotonic and smooth % ss=0 gausian smooth only unequal 

for n = 2:(numFiles+1)
    k = n-1;
    % print working file name-
    files(k).name
    
    % read Length Wigth Thickness from csv, width is transvese, chanel1, length is vertical, chanel 2
    L_W_T = LWT([wd files(k).name]);
    
    % load biastreach data from csv
    M = csvread(strcat(wd, files(k).name),6,0);
    
    % M =  original matrix [Strain1 Load1 Strain2 Load2] in csv file
%   M = M(:,[10 2 11 3]);
    M = M(1:4:end,[10 2 11 3 4 6 5 7]);
    %Load devided by 2 for N1-11 and 20
    lamdax = M(:,5)-min(M(:,5))+ M(:,6)- min(M(:,6)) ;
    lamday = M(:,7)-min(M(:,7))+ M(:,8)- min(M(:,8)) ;
    M = [M(:,1) M(:,2)*alph M(:,3) M(:,4)*alph M(:,5)];
   
    %  StressCir1 = Load1/L/T*1000 while StressLong2 = Load2/W/T*1000, KPa
    M(:,2) = M(:,2)/L_W_T(1)/L_W_T(3)*1000;
    M(:,4) = M(:,4)/L_W_T(2)/L_W_T(3)*1000;
    %conver engieering stress to True stress lagrangian strain
     M(:,2) = M(:,2).*sqrt(2.*M(:,1)+1);
     M(:,4) = M(:,4).*sqrt(2.*M(:,3)+1);  
%      M(:,2) = M(:,2).*lamdax ;
%      M(:,4) = M(:,4).*lamday ;
    %convert lagrangian strain to true strain
    M(:,1)= 1- 1./sqrt(2.*M(:,1)+1) ;
    M(:,3)= 1- 1./sqrt(2.*M(:,3)+1) ;  
         
    %f1 = figure;           %choose the M1 range
    %set(gcf, 'Position', [50, 300, 1500, 600])
%     figure('Name','StrainCir')
%     plot(M(:,1));
%     [mx0, my0] = ginput(2)
%     if mx0(1)<mx0(2) %#ok<ALIGN>
        
    figure('Name','StrainCir')
    set(gcf, 'Position', [30, 40, 1200, 600])
    subplot(4,1,1);
    plot(M(:,1));
    subplot(4,1,2);
    plot(M(:,2));
    subplot(4,1,3);
    plot(M(:,3));
    subplot(4,1,4);
    plot(M(:,4));
    [m1x, m1y] = ginput(2);
    m1_low = round(m1x(1)); %M1_low = input('low boundary')
    m1_up = round(m1x(2));  %M1_up =  input('upper boundary')
    
    if beta==0
    figure('Name','StresCir')
    set(gcf, 'Position', [30, 90, 1200, 500])
    plot(M(:,2));%choose the M2 range
    [m2x, m2y] = ginput(2);
    m2_low = round(m2x(1)); %M1_low = input('low boundary')
    m2_up = round(m2x(2));  %M1_up =  input('upper boundary')
                  
    figure('Name','StressLong')
    set(gcf, 'Position', [30, 90, 1200, 500])
    plot(M(:,4));%choose the M4 range
    [m4x, m4y] = ginput(2);
    m4_low = round(m4x(1)); %M1_low = input('low boundary')
    m4_up = round(m4x(2));  %M1_up =  input('upper boundary')
    
    figure('Name','StrainLong')
    set(gcf, 'Position', [30, 90, 1200, 500])
    plot(M(:,3));%choose the M3 range
    [m3x, m3y] = ginput(2);
    m3_low = round(m3x(1)); %M1_low = input('low boundary')
    m3_up = round(m3x(2));  %M1_up =  input('upper boundary') 
    len = min([m1_up-m1_low, m2_up-m2_low, m3_up-m3_low, m4_up-m4_low]);
    [xm1, ym1] = find(M(m1_low:m1_up, 1)== max(M(m1_low:m1_up, 1)));
    [xm2, ym2] = find(M(m2_low:m2_up, 2)== max(M(m2_low:m2_up, 2)));
    [xm3, ym3] = find(M(m3_low:m3_up, 3)== max(M(m3_low:m3_up, 3)));
    [xm4, ym4] = find(M(m4_low:m4_up, 4)== max(M(m4_low:m4_up, 4)));
    M1 = M(xm1(1)+m1_low-len:xm1(1)+m1_low-1, 1)- min(M(xm1(1)+m1_low-len:xm1(1)+m1_low-1, 1)); 
    M2 = M(xm2(1)+m2_low-len:xm2(1)+m2_low-1,2)- min(M(xm2(1)+m2_low-len:xm2(1)+m2_low-1, 2)); 
    M3 = M(xm3(1)+m3_low-len:xm3(1)+m3_low-1,3)- min(M(xm3(1)+m3_low-len:xm3(1)+m3_low-1, 3)); 
    M4 = M(xm4(1)+m4_low-len:xm4(1)+m4_low-1,4)- min(M(xm4(1)+m4_low-len:xm4(1)+m4_low-1, 4)); 
%     M1 = M(m1_up-len:m1_up, 1)- min(M(m1_up -len :m1_up, 1));     
%     M2 = M(m2_up-len:m2_up, 2)- min(M(m2_up-len:m2_up, 2));
%     M3 = M(m3_up-len:m3_up, 3)- min(M(m3_up-len:m3_up, 3));
%     M4 = M(m4_up-len:m4_up, 4)- min(M(m4_up-len:m4_up, 4));    
    
    elseif beta==1
     [xm1, ym1] = find(M(m1_low:m1_up, 1)== max(M(m1_low:m1_up, 1)));   
%      M1 = M(m1_low:xm1(1)+m1_low-1, 1)- min(M(m1_low:xm1(1)+m1_low-1, 1)); 
     M1 = M(m1_low:xm1(1)+m1_low-1, 1);
     M2 = M(m1_low:xm1(1)+m1_low-1, 2)- min(M(m1_low:xm1(1)+m1_low-1, 2));       
%      M3 = M(m1_low:xm1(1)+m1_low-1, 3)- min(M(m1_low:xm1(1)+m1_low-1, 3));
     M3 = M(m1_low:xm1(1)+m1_low-1, 3)
     M4 = M(m1_low:xm1(1)+m1_low-1, 4)- min(M(m1_low:xm1(1)+m1_low-1, 4));   
    elseif beta ==2 %for unequal strech ratio
     M1 = M(m1_low:m1_up, 1)- min(M(m1_low:m1_up, 1));
     M2 = M(m1_low:m1_up, 2)- min(M(m1_low:m1_up, 2));
     M3 = M(m1_low:m1_up, 3)- min(M(m1_low:m1_up, 3));
     M4 = M(m1_low:m1_up, 4)- min(M(m1_low:m1_up, 4));
    end
    Mt = [M1 M2 M3 M4];
    Mt = rmmissing(Mt);
    if ss ==1
    M1s = mono(Mt(:,1)) - min(mono(Mt(:,1))); 
    M2s = mono(Mt(:,2)) - min(mono(Mt(:,2))); 
    M3s = mono(Mt(:,3)) - min(mono(Mt(:,3))); 
    M4s = mono(Mt(:,4)) - min(mono(Mt(:,4))); 
    elseif ss ==0
    M1s = smoothdata(Mt(:,1), 'gaussian',10);
    M2s = smoothdata(Mt(:,2), 'gaussian',10);
    M3s = smoothdata(Mt(:,3), 'gaussian',10);
    M4s = smoothdata(Mt(:,4), 'gaussian',10);
    end
    Ms = [M1s M2s M3s M4s];  
% %fit to exponential        
%        L1 = (1:1:length(M1s))';
%        L2 = (1:1:length(M2s))';
%        L3 = (1:1:length(M3s))';
%        L4 = (1:1:length(M4s))';
%        X = [1:1:max([length(M1s) length(M3s) length(M2s) length(M4s)])]';
%        
%      if length(L1)*length(L2)*length(L3)*length(L4)~=0
%        p1 = polyfit1(L1, M1s,2,0,0);
%        Mfit1 = polyval(p1,X);
%        
%        p2 = fit(L2,M2s,'exp1','StartPoint',[0,0]);
%        Mfit2 = p2(X);
%        Mfit2 = Mfit2 - min(Mfit2);
%        
%        p3 = polyfit1(L3, M3s,2,0,0);
%        Mfit3 = polyval(p3,X);      
%        
%        p4 = fit(L4,M4s,'exp1','StartPoint',[0,0]);
%        Mfit4 = p4(X);
%        Mfit4 = Mfit4 - min(Mfit4);
%        
%        Mfit = [Mfit1 Mfit2 Mfit3 Mfit4];
%        
    %write to csv
    fid=fopen(strcat(wd2, files(k).name),'w');
    fprintf(fid,'%s, %s, %s, %s\n', 'Epsilon_XX','Stress_XX','Epsilon_YY','Stress_YY');
    fclose(fid);
    dlmwrite(strcat(wd2, files(k).name),Ms,'-append');
    close all
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
% plot(x,y,'ro',x,ym,'b-*', x,yms,'g-');
end


