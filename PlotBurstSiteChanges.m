function PlotBurstSiteChanges(DataSetStims,DataSetBase);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.05 0.05]);
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
for i=1:size(DataSetStims)
    h1 = figure;
    b = PlotBurstInitiationCM(DataSetBase{i}.t,DataSetBase{i}.ic,StimSite{i});
    h2 = figure;
    s = PlotBurstInitiationCM(DataSetStims{i}.t,DataSetStims{i}.ic,StimSite{i});
    h = figure;
    ha1 = subplot(1,2,1);
    copyobj(allchild(b),ha1);
    set(ha1,'PlotBoxAspectRatio',[1 1 1]);
    grid on;
    xlim(ha1,[0 17]);
    ylim(ha1,[0 17]);
    title(ha1,'Baseline');
    ha2 = subplot(1,2,2);
    copyobj(allchild(s),ha2);
    set(ha2,'PlotBoxAspectRatio',[1 1 1]);
    grid on;
    xlim(ha2,[0 17]);
    ylim(ha2,[0 17]);
    title(ha2,'Stimulation');
    figHandles = findobj('Type','figure');
    close(figHandles(2));
    close(figHandles(3));
end