function PlotBurstSiteChanges(DataSetStims,DataSetBase);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.01 0.1], [0.05 0.05]);
%% Set burst initiation zones
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


%% Plot Pre/Post Sites
% for i=1:size(DataSetStims)
%     h1 = figure;
%     b = PlotBurstInitiationCM(DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic,StimSite{i},[DataSetBase{i}.Trim.bs,DataSetBase{i}.sbs],[DataSetBase{i}.Trim.be,DataSetBase{i}.sbe]);
%     h2 = figure;
%     s = PlotBurstInitiationCM(DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic,StimSite{i},[DataSetStims{i}.Trim.bs,DataSetStims{i}.sbs],[DataSetStims{i}.Trim.be,DataSetStims{i}.sbe]);
%     h = figure;
%     ha1 = subplot(1,2,1);
%     copyobj(allchild(b),ha1);
%     set(ha1,'PlotBoxAspectRatio',[1 1 1]);
%     grid on;
%     xlim(ha1,[0 17]);
%     ylim(ha1,[0 17]);
%     title(ha1,'Baseline');
%     ha2 = subplot(1,2,2);
%     copyobj(allchild(s),ha2);
%     set(ha2,'PlotBoxAspectRatio',[1 1 1]);
%     grid on;
%     xlim(ha2,[0 17]);
%     ylim(ha2,[0 17]);
%     title(ha2,'Stimulation');
%     figHandles = findobj('Type','figure');
%     close(figHandles(2));
%     close(figHandles(3));
% end

for i=1:size(DataSetStims,1)
    subplot(5,6,2*i-1)
    [h, BaseD{i}]=PlotBurstInitiationCM(DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic,StimSite{i},sort([DataSetBase{i}.Trim.bs,DataSetBase{i}.sbs]),sort([DataSetBase{i}.Trim.be,DataSetBase{i}.sbe]));
    xlim(gca,[0 17]);
    ylim(gca,[0 17]);
    set(gca,'PlotBoxAspectRatio',[1 1 1]);
    title('baseline');
    subplot(5,6,2*i)
    [h, StimD{i}]=PlotBurstInitiationCM(DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic,StimSite{i},sort([DataSetStims{i}.Trim.bs,DataSetStims{i}.sbs]),sort([DataSetStims{i}.Trim.be,DataSetStims{i}.sbe]));
    xlim(gca,[0 17]);
    ylim(gca,[0 17]);
    set(gca,'PlotBoxAspectRatio',[1 1 1],'XTickLabel',[],'YTickLabel',[]);
    title('stimulation');
end
set(findall(gcf,'-property','FontSize'),'FontSize',12);
maximize(gcf);
set(gcf,'color','none');
export_fig 'CM_PrePost.png' -native
figure;

for i=1:size(DataSetStims,1)
    subplot(5,6,2*i-1)
    hist(BaseD{i});
    xlim([0 10]);
    set(gca,'PlotBoxAspectRatio',[1 1 1]);
    title('baseline');
    subplot(5,6,2*i)
    hist(StimD{i});
    xlim([0 10]);
    set(gca,'PlotBoxAspectRatio',[1 1 1]);
    title('stimulation');
end

set(findall(gcf,'-property','FontSize'),'FontSize',12);
maximize(gcf);
set(gcf,'color','none');
export_fig 'CM_PrePost_Distributions.png' -native

for j=1:size(DataSetStims,1)
[mBase,cBase] = PlotBurstPropogation(DataSetBase{j}.Trim.t,DataSetBase{j}.Trim.ic,sort([DataSetBase{j}.Trim.bs,DataSetBase{j}.sbs]),sort([DataSetBase{j}.Trim.be,DataSetBase{j}.sbe]));
figure;
[mStim,cStim]= PlotBurstPropogation(DataSetStims{j}.Trim.t,DataSetStims{j}.Trim.ic,sort([DataSetStims{j}.Trim.bs,DataSetStims{j}.sbs]),sort([DataSetStims{j}.Trim.be,DataSetStims{j}.sbe]));
[X,Y] = meshgrid(1:1:16,1:1:16);
[FXb,FYb,FZb] = gradient(mBase);
[FXs,FYs,FZs] = gradient(mStim);

figure;
hold all;
for i=1:size(mBase,3);
    quiver(X,Y,FXb(:,:,i),FYb(:,:,i));
end;
xlim([0,17]); ylim([0,17]);

figure;
hold all;
for i=1:size(mStim,3);
    quiver(X,Y,FXs(:,:,i),FYs(:,:,i));
end;
xlim([0,17]); ylim([0,17]);
end
end