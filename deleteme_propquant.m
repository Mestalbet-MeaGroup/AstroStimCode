fclose('all');clear all; close all;clc;
load('tempBurstsWithClusters.mat')
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
    [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
    [culTypes{3} '(1)*'] [culTypes{3} '(2)']...
    [culTypes{4} '(1)'] [culTypes{4} '(2)*'] [culTypes{4} '(3)'] [culTypes{4} '(4)'], 'Control (1)', 'Control (2)'};
%----------------------------%
StimSite{1} =[];
StimSite{2} =[];
StimSite{3} =13;
StimSite{4} =94;
StimSite{5} =150;
StimSite{6} =95;
StimSite{7} =138;
StimSite{8} =228;
StimSite{9} =[];
StimSite{10} =[];
StimSite{11} =[];
StimSite{12} =49;
StimSite{13} =[];
StimSite{14} =[];
StimSite{15} =[];

for i=1:13;
bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==0)&(BurstData.nsbsb==0));
SpikeOrders=[];
base = [];
stim = [];
basec=[];
stimc=[];
for j=1:size(bursts,3)
    b = bursts(:,:,j);
    for k=1:max(b(:))
        SpikeOrders(k,j) = MeaMap(find(b==k));
    end
    [~,base(:,:,j)]=ismember(MeaMap,SpikeOrders(:,j));
end

% %-----Sequential Burst Propogation-----%
bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1)&(BurstData.prepost==1));
SpikeOrders=[];
for j=1:size(bursts,3)
    b = bursts(:,:,j);
    for k=1:max(b(:))
        SpikeOrders(k,j) = MeaMap(find(b==k));
    end
      [~,stim(:,:,j)]=ismember(MeaMap,SpikeOrders(:,j));
end

stimch= zscore(squeeze(mean(mean(diff(stim,[],3),1),2)));
basech= zscore(squeeze(mean(mean(diff(base,[],3),1),2)));

if i~=6&&i~=7&&i~=8&&i~=11
[RP,~] = RPplot(basech',3,1,0.5,0);
[bRR(i),bDET(i),bENTR(i),bL(i)] = Recu_RQA(RP,0);

[RP,~] = RPplot(stimch',3,1,0.5,0);
[sRR(i),sDET(i),sENTR(i),sL(i)] = Recu_RQA(RP,0);
end
    
end

figure;
notBoxPlot([bRR;sRR]');

figure;
notBoxPlot([bDET;sDET]');

figure;
notBoxPlot([bENTR;sENTR]');

figure;
notBoxPlot([bL;sL]');