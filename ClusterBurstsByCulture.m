%% Initialize
fclose('all');clear all; close all;clc;
matlabpool open 8;
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.02], [0.05 0.05], [0.01 0.01]);
load('16x16MeaMap_90CW_Inverted.mat');
load('tempBurstsWithClusters.mat', 'BurstData')
%% Calculate Clusters
h = waitbarwithtime(0,'Calculating...');
numtypes=5;
% tic
% parfor i=1:max(BurstData.cultId)
%     [ClusterIDs{i},CorrMat{i}] = ClusterBursts2(BurstData.bursts(:,:,BurstData.cultId==i),numtypes);
%     %     waitbarwithtime(i/max(BurstData.cultId),h);
% end
% toc

parfor i=1:max(BurstData.cultId)
    ClusterIDs{i} = ClusterBurstsKmeans3(BurstData.bursts(:,:,BurstData.cultId==i));
    %         waitbarwithtime(i/max(BurstData.cultId),h);
end
%% Plot Sample Burst Clusters
% for k=1:max(BurstData.cultId);
opengl('software');
k=8
for k=1:max(BurstData.cultId)
    f1 = figure('name',['UnMerged Burst Clusters: Culture ' num2str(k)]);
    numtypes=max(ClusterIDs{k});
    for i=1:numtypes
        bursts = BurstData.bursts(:,:,BurstData.cultId==k);
        burstType(:,:,i)=nanmean(bursts(:,:,ClusterIDs{k}==i),3);
        subplot(ceil(sqrt(numtypes)),ceil(sqrt(numtypes)),i);
        imagescnan(burstType(:,:,i));
        title([num2str(i) ' - ' num2str(size(bursts(:,:,ClusterIDs{k}==i),3))]);
        set(gca,'XTick',[],'YTick',[],'PlotBoxAspectRatio',[1 1 1]);
    end
%     maximize(gcf);
    
    %% Additional Cluster Merge Step
    [~,list]=CalcDiffsBetBurstsProp(burstType); %Calculates the element-wise absolute difference between clustergroups
    list(:,3)=list(:,3)./max(list(:,3));
    list(:,4)=list(:,4)./max(list(:,4));
    merge = list(((list(:,3)<=0.6)&(list(:,4)<0.95)),1:2);
    MergedClusts = ClusterIDs{k};
    for kkk=1:size(merge,1)
        MergedClusts( (MergedClusts==merge(kkk,1))|(MergedClusts==merge(kkk,2)) ) = merge(kkk,1)+100;
    end
    newIds=unique(MergedClusts);
    for r=1:numel(newIds)
        MergedClusts(MergedClusts==newIds(r))=r;
    end
    figure('name',['Final Burst Clusters: Culture ' num2str(k)]);
    newNumTypes =max(MergedClusts);
    for i=1:newNumTypes
        bursts = BurstData.bursts(:,:,BurstData.cultId==k);
        MergedBurstType(:,:,i)=nanmean(bursts(:,:,MergedClusts==i),3);
        subplot(ceil(sqrt(newNumTypes)),ceil(sqrt(newNumTypes)),i);
        imagescnan(MergedBurstType(:,:,i));
        title([num2str(i) ' - ' num2str(size(bursts(:,:,MergedClusts==i),3))]);
        set(gca,'XTick',[],'YTick',[],'PlotBoxAspectRatio',[1 1 1]);
    end
    % ClusterCorr = ClusterCorr + ClusterCorr'+eye(size(ClusterCorr));
    % test=pdist(ClusterCorr);
    % tree=linkage(test,'average');
    % subplot(2,numtypes,i+1:2*numtypes);
    % [~,~,~] = dendrogram(tree,size(ClusterCorr,1));
    % [~,thresh] = ginput(1);
    % close f1;
    % MergeIDs  = cluster(tree,'CutOff',thresh,'Criterion','distance');
    % MergedClusts = ClusterIDs{k};
    % for i=1:numtypes
    %     MergedClusts(ClusterIDs{k}==i)=MergeIDs(i);
    % end
    % NewClusterIDs{k}=MergedClusts;
    
    clear newIds; clear burstType; clear MergedBurstType; clear test; clear tree; clear ClusterCorr;
end
%% Plot Burst types per culture
figure;
colors = {'Purples','Purples','Purples','Purples','Purples',...
    'Purples','Purples','Greys','Purples','Purples',...
    'Greys','Purples','Purples'};
cmap=[];
for k=1:size(colors,2)
    cmap = [cmap;cbrewer('seq', colors{k}, 5)];
end

diffs  = PlotSequentialBurstGroups(BurstData,ClusterIDs);

%% Plot bar chart of differences

subplot(4,4,14:16);
hold on;
for j=1:max(BurstData.cultId)
    bars=bar((1:numtypes)+(j-1)*(numtypes+1),diffs(:,j)','BarWidth',1);
    ch = get(bars,'Children'); %get children of the bar group
    fvd = get(ch,'Faces'); %get faces data
    fvcd = get(ch,'FaceVertexCData');
    for i=1:size(fvd,1)
        fvcd(fvd(i,:)) = i+(j-1)*numtypes;
    end
    set(ch,'FaceVertexCData',fvcd)
    colormap(cmap);
end
set(gca,'TickDir','out');
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
    [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
    [culTypes{3} '(1)'] [culTypes{3} '(2)']...
    [culTypes{4} '(1)'] [culTypes{4} '(2)'] [culTypes{4} '(3)'] [culTypes{4} '(4)']};
set(gca,'XTick',(numtypes+1)/2:(numtypes+1):(max(BurstData.cultId)*(numtypes+1)),'XTickLabel',cultLabels,'FontSize',8) %The plus one after numtypes accounts for a space between groups
box off;
maximize(gcf);
print('-depsc2','-r300','Fig6_BurstClusterDifferences.eps');
close all;
%% Plot burst propogation (color by location on MEA)
%--------------------------------%
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
%---------------------------------------%
% Colormap Diagram
figure;
[cmap,Z1]=MeaColorMap;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
% print('-dpng','-r300','Fig6_ColorMap.png');
close all;
%---------------------------------------%
% Burst Propagation

for i=1:13
    % i=8;
    if ~isempty(StimSite{i})
        figure;
        bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1));
        SpikeOrders=[];
        for j=1:size(bursts,3)
            b = bursts(:,:,j);
            for k=1:max(b(:))
                SpikeOrders(k,j) = MeaMap(find(b==k));
            end
        end
        
        %--------------------%
        % Stimulation Sight Location by Color
        s=subplot(4,1,2:4);
        f=figure;
        h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
        axis tight;
        axis off;
        copyobj(h,s);
        close(f);
        axis tight;
        axis off;
        [a,b]=find(MeaMap==StimSite{i});
        img(1:10,1:size(SpikeOrders,2))=Z1(a,b)+1;
        [X,Y] = meshgrid(1:1:size(img,1),1:1:size(img,2));
        subplot(4,1,1);
        imshow(img,cmap);
        shading flat;
        axis off;
        set(gcf,'ColorMap',[[0,0,0];cmap]);
        set(gcf,'color','w');
        maximize(gcf);
    end
    img=[];
    SpikeOrders=[];
    bursts=[];
end
% export_fig 'Fig6_BurstPropogation.png';
% print('-dpng','-r300','Fig6_BurstPropogation.png');
close all;
%%
