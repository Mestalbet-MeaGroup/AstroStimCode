
fclose('all');clear all; close all;clc;
load('tempBurstsWithClusters.mat')
i=4;
SpikeOrders=[];
SpikeOrdersp=[];
base = [];
stim = [];
basec=[];
stimc=[];
G = fspecial('gaussian',[16 16],2);

%% Baseline
bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==0)&(BurstData.nsbsb==0));

for j=1:size(bursts,3)
    b = bursts(:,:,j);
    for k=1:max(b(:))
        SpikeOrders(k,j) = MeaMap(find(b==k));
        so(k,j) = find(b==k);
    end
    [~,base(:,:,j)]=ismember(MeaMap,SpikeOrders(:,j));
    basec(:,:,j) = convn(base(:,:,j),G,'same');
end

%% Stimulation
burstsp  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1)&(BurstData.prepost==1));

for j=1:size(burstsp,3)
    b = burstsp(:,:,j);
    for k=1:max(b(:))
        SpikeOrdersp(k,j) = MeaMap(find(b==k));
        sosp(k,j) = find(b==k);
    end
    [~,stim(:,:,j)]=ismember(MeaMap,SpikeOrdersp(:,j));
    stimc(:,:,j) = convn(stim(:,:,j),G,'same');
end

%% Cluster
ClustMatM = CreatePropVecForClustering(bursts,SpikeOrders,MeaMap,'LocalMean');
ClustMatV = CreatePropVecForClustering(bursts,SpikeOrders,MeaMap,'LocalVar');
ClustMatCV = CreatePropVecForClustering(bursts,SpikeOrders,MeaMap,'LocalCV');
ClustMatMM = CreatePropVecForClustering(bursts,SpikeOrders,MeaMap,'MaxMin');

% [~,perfPre]=ClusterBursts(so,1,ClustMatM,ClustMatV,ClustMatCV,ClustMatMM);
[clustPre,~]=ClusterBursts(so,0,ClustMatM,ClustMatV,ClustMatCV,ClustMatMM);

ClustMatMp = CreatePropVecForClustering(burstsp,SpikeOrdersp,MeaMap,'LocalMean');
ClustMatVp = CreatePropVecForClustering(burstsp,SpikeOrdersp,MeaMap,'LocalVar');
ClustMatCVp = CreatePropVecForClustering(burstsp,SpikeOrdersp,MeaMap,'LocalCV');
ClustMatMMp= CreatePropVecForClustering(burstsp,SpikeOrdersp,MeaMap,'MaxMin');

% [~,perfPost]=ClusterBursts(sosp,1,ClustMatMp,ClustMatVp,ClustMatCVp,ClustMatMMp);
[clustPost,~]=ClusterBursts(sosp,0,ClustMatMp,ClustMatVp,ClustMatCVp,ClustMatMMp);


%% Categories

[PropMat,PropMatS]=CalcBurstProp(SpikeOrdersp,burstsp,MeaMap);
PropMatS(PropMatS==0)=nan;
PropMat(PropMat==0)=nan;

uval = unique(clustPost(:,2),'stable');
for i=1:numel(uval)
    ClustMeans(:,:,i) = nanmean(PropMat(:,:,clustPost(:,2) == uval(i)),3);
    subplot(floor(sqrt(numel(uval))),ceil(sqrt(numel(uval))),i);
    imagescnan(squeeze(ClustMeans(:,:,i)));
end

% 
% uval = unique(CID2,'stable');
% for i=1:numel(uval)
%     ClustMeans(:,:,i) = nanmean(PropMat(:,:,CID2 == uval(i)),3);
%     subplot(floor(sqrt(numel(uval))),ceil(sqrt(numel(uval))),i);
%     imagescnan(squeeze(ClustMeans(:,:,i)));
% end

%% Plots
figure;
idx = randperm(size(PropMat,3));

for i=1:size(PropMat,3)/2
    subplot(floor(sqrt(size(PropMat,3)/2)),ceil(sqrt(size(PropMat,3)/2)),i);
    temp = squeeze(PropMatS(:,:,idx(i)));
    while nansum(temp(:)>0)<100
        temp = squeeze(PropMatS(:,:,idx(randi(numel(idx,1)))));
    end
    imagescnan(temp);
    axis off;
end

for j=1:size(clustPost,2)
%     figure;
    uval = unique(clustPost(:,j),'stable');
    for i=1:numel(uval)
        tempset = PropMat(:,:,clustPost(:,j) == uval(i));
        if size(tempset,3)>1
        ClustMeans(:,:,i) = nanmean(tempset,3);
        tempset(isnan(tempset))=0;
        combs = nchoosek(1:size(tempset,3),2);
        for k=1:size(combs,1)
            rval = randi(numel(uval),1);
            while rval~=uval(i)
                rval = randi(numel(uval),1);
            end
            controlset = squeeze(PropMat(:,:,clustPost(:,j) == uval(rval)));
            controlset(isnan(controlset))=0;
            controlset = controlset(:,:,randi(size(controlset,3),1));
            a = xcorr2(tempset(:,:,combs(k,1)));
            b = xcorr2(tempset(:,:,combs(k,2)));
            c = xcorr2(controlset);
            autocorr = max(a(:))*max(b(:));
            controlautocorr = max(a(:))*max(c(:));
            tempscore(k) = max(max(xcorr2(tempset(:,:,combs(k,1)),tempset(:,:,combs(k,2)))/(sqrt(autocorr))));
            controlscore(k) = max(max(xcorr2(tempset(:,:,combs(k,1)),controlset)/(sqrt(controlautocorr))));
        end
        clustscore(i,j)=nanmean(tempscore);
        clustscoreControl(i,j)=nanmean(controlscore);
        else
            ClustMeans(:,:,i)=tempset;
            clustscore(i,j)=nan;
        end
%         subplot(floor(sqrt(numel(uval))),ceil(sqrt(numel(uval))),i);
%         imagescnan(squeeze(ClustMeans(:,:,i)));
    end
end

figure;
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
subplot(3,1,1)
clustscore(clustscore==0)=nan;
notBoxPlot(clustscore(:,1:5),1:5);
axis tight;
box off;
set(gca,'XTickLabels',[],'TickDir','out');
subplot(3,1,2)
clustscoreControl(clustscoreControl==0)=nan;
notBoxPlot(clustscoreControl(:,1:5),1:5);
axis tight;
box off;
set(gca,'XTickLabels',[],'TickDir','out');
subplot(3,1,3)
bar(1:5,[nanmean(clustscore(:,1:5),1)./nanmean(clustscoreControl(:,1:5),1)]',0.75);
axis tight;
set(gca,'XTickLabels',{'spike order','local mean','local variance', 'local cv', 'max to min'},'TickDir','out');
set(findall(gcf,'-property','FontSize'),'FontSize',16);

figure;
subplot(1,2,1);
plot(100:100:5000,perfPre);
title('Bursts');
subplot(1,2,2);
plot(100:100:5000,perfPost);
title('Superbursts');
legend({'Spike Order','Mean','Var','CV','Max2min'});

%% Mixed clustering
test=pdist(sosp','cosine');
[clusters1,~]=ClusterBursts(squareform(test),0,squareform(pdist(sosp','seuclid')));

[PropMat,PropMatS]=CalcBurstProp(SpikeOrdersp,burstsp,MeaMap);
PropMatS(PropMatS==0)=nan;
PropMat(PropMat==0)=nan;

uval = unique(clusters1(:,2),'stable');
for i=1:numel(uval)
    temp = nanmean(PropMat(:,:,clusters1(:,2) == uval(i)),3);
    ClustMeans(:,i)=temp(:);
end

ClustMeans(isnan(ClustMeans))=0;
[cl,~]=ClusterBursts(squareform(pdist(ClustMeans','cosine')),0,squareform(pdist(ClustMeans','euclid')));

[~,b]=ismember(clusters1(:,2),cl(:,1));
b=b+1;

figure;
uval = unique(b,'stable');
for i=1:numel(uval)
    cm(:,:,i) = nanmean(PropMat(:,:,b == uval(i)),3);
    subplot(floor(sqrt(numel(uval))),ceil(sqrt(numel(uval))),i);
    imagescnan(squeeze(cm(:,:,i)));
    title(num2str(sum(b == uval(i))));
end


