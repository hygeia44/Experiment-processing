%% draw from processed csv files in 4 folders, 
% aorta ascending in main folder, aorta stj and sinus in /sinus,
% pulmonary ascending in /Pulm, pulmonary stj and sinus in /PulmSinus
close all
clearvars
fname = 'N23 Failure' ;
strchCol = 1 ; % 1/stretch 2/strain
xm = 3 ;  %3 stretch/2 strain
%change fname and b each time, put aorta long in sinus folder, pulm cir in
%pulm folfer, pulm long in plum sinus folder
wd = 'Output data/';
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
loc1 = ' Aorta Ascending'; 
loc2 = ' Aorta  STJ  Sinus'; 
loc3 = ' Pulmonary Ascending';
loc4 = ' Pulmonary  STJ  Sinus';

plotMulti(wd, 1, fname, loc1,  1, strchCol, xm); % mkr=0 ascending  mkr=1 sinus  mkr=2 leaflet
plotMulti(wds, 1, fname, loc2,  2, strchCol, xm);
plotMulti(wdp, 2, fname, loc3,  1, strchCol, xm);
plotMulti(wdps, 2, fname, loc4, 2, strchCol, xm);

function plotMulti(wd, pnum, fname, loc, snum, strchCol, xm) 
files = dir(strcat(wd,'*.csv'));
numFiles = length(files);
for n = 1:numFiles
    M = csvread(strcat(wd, files(n).name),1,0);
    figure (pnum);
    t1 = contains(files(n).name,'long','IgnoreCase',true) ;
%     t2 = contains(files(n).name,'sinus','IgnoreCase',true) ;
    set(gcf, 'Position', [30, -150, 750, 1000])
    subplot(2,1,snum);
    if t1==1
    plot(M(:,strchCol), M(:,3),'o', 'DisplayName',files(n).name); hold on
    xlabel('Stretch')
    ylabel('Cauchy Stress (Kpa)')
    xlim([1 xm])
    ylim([0 1000])
    legend ('Interpreter', 'none', 'location', 'northeastoutside')
%     elseif t2 ==1
%     plot(M(:,strchCol), M(:,3), '+', 'DisplayName',files(n).name); hold on
%     xlabel('Stretch')
%     ylabel('Cauchy Stress (Kpa)')
%     xlim([1 xm])
%     ylim([0 4000])
%     legend ('Interpreter', 'none', 'location', 'northeastoutside')
%     title(strcat(fname, loc, ' Circumferential'))
    else 
    plot(M(:,strchCol), M(:,3), 'DisplayName',files(n).name); hold on
    xlabel('Stretch')
    ylabel('Cauchy Stress (Kpa)')
    xlim([1 xm])
    ylim([0 1000])
    legend ('Interpreter', 'none', 'location', 'northeastoutside')
%     title(strcat(fname, loc, ' Circumferential'))
    end
    title(strcat(fname, loc))
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