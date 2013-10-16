%% Initialize
% fclose('all');clear all; close all;clc;
% matlabpool open 8;
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.01 0.01]);
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

for i=1:max(BurstData.cultId)
    [ClusterIDs{i},~,~] = ClusterBurstsKmeans2(BurstData.bursts(:,:,BurstData.cultId==i));
        waitbarwithtime(i/max(BurstData.cultId),h);
end
%% Plot Sample Burst Clusters
% for k=1:max(BurstData.cultId);
k=2; figure;

%Find top 6 clusters;
for i=1:max(ClusterIDs{k})
num(i) = sum(ClusterIDs{k}==i);
end
[val,ix]=sort(num,'descend');
vec=ix(1:6);

for i=1:numel(vec);
    %         %         figure;
    bursts = BurstData.bursts(:,:,BurstData.cultId==k);
    %     b2plot = bursts(:,:,ClusterIDs{k}==i);
    %     for j=1:size(b2plot,3)
    %         subplot(10,10,j);
    %         imagescnan(b2plot(:,:,j));
    %         set(gca,'XTick',[],'YTick',[]);
    %     end
    burstType=nanmean(bursts(:,:,ClusterIDs{k}==i),3);
%     subplot(3,ceil(max(ClusterIDs{k})/3),i);
subplot(2,3,i);
    imagescnan(burstType);
    title(['Burst Propogation Cluster ' num2str(i)]);
    set(gca,'XTick',[],'YTick',[],'PlotBoxAspectRatio',[1 1 1]);
end
% end

% colors = {'Reds','Blues','Oranges','Greens','Purples',...
%           'YlOrRd','YlGnBu','Greys','RdPu','PuBuGn',...
%           'Greys','BuGn','YlGn'};
maximize(gcf);
print('-dpng','-r300','Fig6_BurstClusters.png');
close all;
%% Plot Burst types per culture
figure;
colors = {'Purples','Purples','Purples','Purples','Purples',...
    'Purples','Purples','Greys','Purples','Purples',...
    'Greys','Purples','Purples'};
cmap=[];
for k=1:size(colors,2)
    cmap = [cmap;cbrewer('seq', colors{k}, 5)];
end

opengl('software');
diffs  = PlotSequentialBurstGroups(BurstData,ClusterIDs);

%% Plot bar chart of differences

subplot(4,4,14:16);
hold on;
for j=1:max(BurstData.cultId)
%     numtypes = max(ClusterIDs{j});
    numtypes = 6;
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
set(gca,'XTick',(numtypes+1)/2:(numtypes+1):(max(BurstData.cultId)*(numtypes+1)),'XTickLabel',cultLabels,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]) %The plus one after numtypes accounts for a space between groups
axis tight; 
% box off;
set(gcf,'color','k');
maximize(gcf);
export_fig 'Fig6_BurstClusterDifferencesWithCorr.png';
% print('-depsc2','-r300','Fig6_BurstClusterDifferencesWithCorr.eps');
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
