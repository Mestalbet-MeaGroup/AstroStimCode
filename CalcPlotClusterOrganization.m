function CalcPlotClusterOrganization(BurstData)
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.05], [0.01 0.01]);
load('16x16MeaMap_90CW_Inverted.mat');
cm = createcolormap(MeaMap,'intensity',3,'invert',1); % Samora colormap function
PosClusts=unique(BurstData.ClusterIDs);

for i=1:max(BurstData.cultId)
    PreTypes(:,i)=histc(BurstData.ClusterIDs((BurstData.prepost==0)&(BurstData.cultId==i)),PosClusts);
    PostTypes(:,i)=histc(BurstData.ClusterIDs((BurstData.prepost==1)&(BurstData.cultId==i)),PosClusts);
end

preFactor = sum(PreTypes,1);
postFactor = sum(PostTypes,1);
for i=1:size(PreTypes,2)
    PreTypes(:,i)= PreTypes(:,i)./preFactor(i);
    PostTypes(:,i)= PostTypes(:,i)./postFactor(i);
end

mPre = mean(PreTypes,2);
mPost = mean(PostTypes,2);
sPre = std(PreTypes,[],2);
sPost = std(PostTypes,[],2);
% errY=[[zeros(size(sPre)),zeros(size(sPost))];[sPre,sPost]];
% Not sure what to do about the zeros
% barwitherr([sPre,sPost],[mPre,mPost],'grouped');
bar([mPre,mPost],'grouped');
title('Burst Incidence');
ylabel('Occurance Fraction');
xlabel('Burst Type');
legend('Baseline','Stimulation');
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
export_fig -native 'ClusteringBurstTypes.png' 
close all;
figure;
for i=1:max(BurstData.ClusterIDs)
    burstType(:,:,i)=nanmean(BurstData.bursts(:,:,BurstData.ClusterIDs==i),3);
    subplot(3,3,i);
    imagescnan(burstType(:,:,i));
    set(gca,'XTick',[],'YTick',[]);
end
set(gcf,'NextPlot','add');
axes;
h = title('Burst Propagation Types');
set(gca,'Visible','off');
set(h,'Visible','on');
set(gcf,'color','w');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
export_fig -native 'BurstPropogationClusters.png';
close all;
%% Pre vs. Post Bursts
figure;
[cmap,~]=MeaColorMap;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
export_fig -native 'BurstLocationColorMap.png'
close all;
figure;
for i=1:max(BurstData.cultId)
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==0));
    SpikeOrders=[];
    for j=1:size(bursts,3)
        b = bursts(:,:,j);
        for k=1:max(b(:))
            SpikeOrders(k,j) = MeaMap(find(b==k));
        end
    end
    s=subplot(2,13,i);
    f=figure;
    h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
    copyobj(h,s);
    close(f);
    axis tight;
    axis off;
end

for i=1:max(BurstData.cultId)
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1));
    SpikeOrders=[];
    for j=1:size(bursts,3)
        b = bursts(:,:,j);
        for k=1:max(b(:))
            SpikeOrders(k,j) = MeaMap(find(b==k));
        end
    end
    s=subplot(2,13,i+max(BurstData.cultId));
    f=figure;
    h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
    copyobj(h,s);
    close(f);
    axis tight;
    axis off;
end
set(gcf,'ColorMap',[[0,0,0];cmap]);
set(gcf,'NextPlot','add');
axes;
h = title('Baseline vs Stimulation');
set(gca,'Visible','off');
set(h,'Visible','on');
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
export_fig -native 'BurstsPrePost.png';
close all;
%% Bursts not within superbursts versus bursts within SBs
figure;
[cmap,~]=MeaColorMap;
figure;
for i=1:max(BurstData.cultId)
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0));
    SpikeOrders=[];
    for j=1:size(bursts,3)
        b = bursts(:,:,j);
        for k=1:max(b(:))
            SpikeOrders(k,j) = MeaMap(find(b==k));
        end
    end
    s=subplot(2,13,i);
    f=figure;
    h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
    copyobj(h,s);
    close(f);
    axis tight;
    axis off;
end

for i=1:max(BurstData.cultId)
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1));
    SpikeOrders=[];
    for j=1:size(bursts,3)
        b = bursts(:,:,j);
        for k=1:max(b(:))
            SpikeOrders(k,j) = MeaMap(find(b==k));
        end
    end
    if ~isempty(SpikeOrders)
    s=subplot(2,13,i+max(BurstData.cultId));
    f=figure;
    h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
    copyobj(h,s);
    close(f);
    axis tight;
    axis off;
    else
        s=subplot(2,13,i+max(BurstData.cultId));
        set(s,'box','off','XTick',[],'YTick',[]);
    end
end
set(gcf,'ColorMap',[[0,0,0];cmap]);
set(gcf,'NextPlot','add');
axes;
h = title('Bursts outside vs within SBs');
set(gca,'Visible','off');
set(h,'Visible','on');
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
export_fig -native 'BurstsNsbSB.png';
close all;
end