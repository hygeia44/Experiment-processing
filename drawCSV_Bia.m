%% draw from processed csv files in a folder
close all
clearvars
wd = 'C:\Users\hygei\Documents\Biaxial_normal\bia_location_equal\Aor_Asc_A';
fname = 'N1 Failure';
loc1 = ' Aorta';  
loc2 = ' Pulmonary';
% wd = 'Output data/';
wds= 'Output data/sinus/';
wdp = 'Output data/pulm/';
wdps = 'Output data/pulmSinus/';
files1 = dir(strcat(wd,'*.csv'));
numFiles1 = length(files1);
files2 = dir(strcat(wds,'*.csv'));
numFiles2 = length(files2);
files3 = dir(strcat(wdp,'*.csv'));
numFiles3 = length(files3);
files4 = dir(strcat(wdps,'*.csv'));
numFiles4 = length(files4);


plotMulti(wd, 1, fname, loc1, 0); % mkr=0 ascending  mkr=1 sinus  mkr=2 leaflet
plotMulti(wds, 1, fname, loc1, 1);
plotMulti(wdp, 2, fname, loc2, 0);
plotMulti(wdps, 2, fname, loc2, 1);

function plotMulti(wd, pnum, fname, loc, mkr) 
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);
for n = 1:numFiles
    M = csvread(strcat(wd, files(n).name),1,0);
    figure (pnum);
    set(gcf, 'Position', [30, -150, 750, 1000])
    subplot(2,1,1);
    if mkr == 0
    plot(M(:,1), M(:,2), 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside')
    title(strcat(fname, loc, ' Circumferential'))
    subplot(2,1,2);
    plot(M(:,3), M(:,4), 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside') 
     title(strcat(fname, loc, ' Longitudinal'))
    elseif mkr ==1
    plot(M(:,1), M(:,2), 'o', 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside')
    title(strcat(fname, loc, ' Circumferential'))
    subplot(2,1,2);
    plot(M(:,3), M(:,4), 'o', 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside') 
     title(strcat(fname, loc, ' Longitudinal'))
    elseif mkr ==2
    plot(M(:,1), M(:,2), '+', 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside')
    title(strcat(fname, loc, ' Circumferential'))
    subplot(2,1,2);
    plot(M(:,3), M(:,4), '+', 'DisplayName',files(n).name); hold on
    xlabel('True Strain')
    ylabel('Cauchy Stress (Kpa)')
    legend ('Interpreter', 'none', 'location', 'northeastoutside') 
     title(strcat(fname, loc, ' Longitudinal'))
    end
end
end

% for k = 1:numFiles1
%     % print working file name
% %     files1(k).name
%     % load biastreach data from csv
%     Ma = csvread(strcat(wd, files1(k).name),1,0);
%     figure (1)
%     set(gcf, 'Position', [30, 90, 900, 700])
%     subplot(2,2,1);
%     plot(Ma(:,1), Ma(:,2), 'DisplayName',files1(k).name); hold on
%     title(strcat(fname, loc, 'Circumferential'));
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')
%     subplot(2,2,2);
%     plot(Ma(:,3), Ma(:,4), 'DisplayName',files1(k).name); hold on
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')
%     title(strcat(fname, loc, 'Longitudinal'))
% end
% 
% plotMulti(wds, 2, fname, loc1);
% plotMulti(wdp, 3, fname, loc1);
% 
% 
% for j = 1:numFiles2
%     Mas = csvread(strcat(wds, files2(j).name),1,0);
%     figure (1);
%     subplot(2,2,1);
%     plot(Mas(:,1), Mas(:,2), 'o', 'DisplayName',files2(j).name); hold on
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')
%     subplot(2,2,2);
%     plot(Mas(:,3), Mas(:,4), 'o', 'DisplayName',files2(j).name); hold on
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')   
% end
% 
% for i = 1:numFiles3
%     Mp = csvread(strcat(wdp, files3(i).name),1,0);
%     figure (1)
%     subplot(2,2,3);
%     plot(Mp(:,1), Mp(:,2), 'DisplayName',files3(i).name); hold on
%     title(strcat(fname, loc, ' Circumferential'));
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')
%     subplot(2,2,4);
%     plot(Mp(:,3), Mp(:,4), 'DisplayName',files1(k).name); hold on
%     xlabel('True Strain')
%     ylabel('Cauchy Stress (Kpa)')
%     legend ('Interpreter', 'none', 'location', 'northwest')
%     title(strcat(fname, loc, ' Longitudinal'))
% end