%%
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

%%
% [cmap,Z1]=MeaColorMap;
 
%-----Sequential Burst Propogation-----%
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

G = fspecial('gaussian',[16 16],2);
for ii=1:size(base,3)
    basec(:,:,ii) = convn(base(:,:,ii),G,'same');
%     imagesc(basec(:,:,i));
%     pause(0.2);
end
for ii=1:size(stim,3)
    stimc(:,:,ii) = convn(stim(:,:,ii),G,'same');
%     imagesc(stimc(:,:,i));
%     pause(0.2);
end
figure;
subplot(2,1,1);
plot(zscore(squeeze(mean(mean(diff(basec,[],3),1),2))));
subplot(2,1,2);
plot(zscore(squeeze(mean(mean(diff(stimc,[],3),1),2))));
end


% subplot(4,1,1);
% plot(zscore(squeeze(mean(mean(diff(basec,[],3),1),2))));
% subplot(4,1,2);
% test = fft(zscore(squeeze(mean(mean(diff(basec,[],3),1),2))));
% plot(real(test),imag(test),'.');
% subplot(4,1,3);
% plot(zscore(squeeze(mean(mean(diff(stimc,[],3),1),2))));
% subplot(4,1,4);
% test = fft(zscore(squeeze(mean(mean(diff(stimc,[],3),1),2))));
% plot(real(test),imag(test),'.');

% for i=1:min([size(base,3),size(stim,3)])
%     imagesc(mat(:,:,i));
%     subplot(1,2,1);
%     imagesc(convn(base(:,:,i),G,'same'))
%     subplot(1,2,2);
%     imagesc(convn(stim(:,:,i),G,'same'))
%     pause(0.5);
% end


% [~,prop] = ismember(MeaMap,SpikeOrders(:,1));
% prop(prop==0)=nan;
% 
% options=unique(prop(~isnan(prop)));
% for i=1:max(options)
%     [x(i),y(i)]=find(prop==options(i));
% end
