
% load('DataSetOpto_withControlCults.mat')
% load('16x16MeaMap_90CW_Inverted.mat');
% BurstData = GenerateBurstData(DataSetBase,DataSetStims,MeaMap);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.001], [0.05 0.05], [0.05 0.05]);
%% CDFs
PlotCDFwithDetectionErrorWithPatch;
%% PDF base vs. stim

%----------------------------%
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
%----------------------------%
k=4;
type = 'INvOUT'; % Sets the type of comparison to be calculated: 
% (PREvPOST = baseline versus stimulation, 
%  INvOUT   = regular bursts versus bursts within superbursts during stimulation,
%  RegPREvPOST = regular bursts during baseline versus regular bursts during stimulation)
[pdfpre,pdfpost]=CalcPlotBurstInitiationPDF3(BurstData,MeaMap,type);
close all;
%-----PDF of Burst Initiations---------%
PlotBurstInitPDF(pdfpre{k},pdfpost{k},StimSite{k},MeaMap);
title('burst initation probability density');
set(gcf,'color','none');
shading flat;
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
saveas(gcf,['Fig7_BurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig7_BurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig7_BurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig7_BurstInitiation',type, '.png']);
% export_fig -native ['Fig7_BurstInitiation',type, '.png'];
close all;

%-----Bar plot of differences in spot---------%
figure;
for i=1:size(StimSite,2);
    if ~isempty(StimSite{i})
        [xs,ys]=find(MeaMap==StimSite{i});
        spot = zeros(size(MeaMap));
        spot(xs,ys)=1;
        se = strel('disk',4);
        spot = imdilate(spot,se);
        spot(spot==0)=nan;
        temp1 = spot.*pdfpre{i};
        temp2 = spot.*pdfpost{i};
        vals(i,1) = nanmean(temp1(:));
        vals(i,2) = nanmean(temp2(:));
    else
        vals(i,1) = nan;
        vals(i,2) = nan;
    end
end
bar(vals);
set(gca,'XTickLabels',cultLabels);
rotateXLabels( gca(), 45 )

%-----Save and Close------%
title('average burst initation probability within illumination spot');
legend('Baseline','Stimulation','Location','NorthEast');
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
saveas(gcf,['Fig7_SpotBurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig7_SpotBurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig7_SpotBurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig7_SpotBurstInitiation',type, '.png']);
% export_fig -native ['Fig7_SpotBurstInitiation',type, '.png'];
close all;

type = 'RegPREvPOST'; % Sets the type of comparison to be calculated: 
[pdfpre,pdfpost]=CalcPlotBurstInitiationPDF3(BurstData,MeaMap,type);
close all;
%-----PDF of Burst Initiations---------%
PlotBurstInitPDF(pdfpre{k},pdfpost{k},StimSite{k},MeaMap);
title('burst initation probability density');
set(gcf,'color','none');
shading flat;
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
saveas(gcf,['Fig7_BurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig7_BurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig7_BurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig7_BurstInitiation',type, '.png']);
% export_fig -native ['Fig7_BurstInitiation',type, '.png'];
close all;

%-----Bar plot of differences in spot---------%
figure;
for i=1:size(StimSite,2);
    if ~isempty(StimSite{i})
        [xs,ys]=find(MeaMap==StimSite{i});
        spot = zeros(size(MeaMap));
        spot(xs,ys)=1;
        se = strel('disk',4);
        spot = imdilate(spot,se);
        spot(spot==0)=nan;
        temp1 = spot.*pdfpre{i};
        temp2 = spot.*pdfpost{i};
        vals(i,1) = nanmean(temp1(:));
        vals(i,2) = nanmean(temp2(:));
    else
        vals(i,1) = nan;
        vals(i,2) = nan;
    end
end
bar(vals);
set(gca,'XTickLabel',cultLabels);
rotateXLabels( gca(), 45 )

%-----Save and Close------%
title('average burst initation probability within illumination spot');
legend('Baseline','Stimulation','Location','NorthEast');
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
% print('-depsc2','-r300',['Fig7_SpotBurstInitiation',type, '.eps']);
saveas(gcf,['Fig7_SpotBurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig7_SpotBurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig7_SpotBurstInitiation',type, '.png']);
% export_fig -native ['Fig7_SpotBurstInitiation',type, '.png'];
close all;

%% Burst Propogation

%-----Color Coded Mea Map------%
figure('renderer','zbuffer');
% opengl('software');
[cmap,Z1]=MeaColorMap;
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
% print('-dpng','-r300','Fig7_ColorMap.png');
% export_fig('Fig7_ColorMap.eps');
saveas(gcf,'Fig7_ColorMap.eps', 'epsc2');
fix_pcolor_eps('Fig7_ColorMap.eps');
close all;

%-----Sequential Burst Propogation-----%
i=4;
bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1));
SpikeOrders=[];
for j=1:size(bursts,3)
    b = bursts(:,:,j);
    for k=1:max(b(:))
        SpikeOrders(k,j) = MeaMap(find(b==k));
    end
end
f = figure('renderer','zbuffer');
h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders,StimSite{i});
set(f,'ColorMap',[[0,0,0];cmap]);
axis tight;
set(gca,'PlotBoxAspectRatio',[size(SpikeOrders,1)+4,size(SpikeOrders,2),1]);
oldsize=size(SpikeOrders,2);
%-----Save and Close------%
title('sequential burst propogation (within superbursts)');
set(gcf,'color','none');
maximize(gcf);
xlabel('spike order within bursts');
ylabel('burst number');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'TickDir','out');
% saveas(gcf,'Fig7_sequentialburstprop1a.eps', 'epsc2');
% fix_pcolor_eps('Fig7_sequentialburstprop1a.eps');
% export_fig('Fig7_sequentialburstprop1.eps');
print('-depsc2','-r600','-cmyk ','Fig7_sequentialburstprop1.eps');
% print('-dpng','-r300','Fig7_sequentialburstprop1.png');
% export_fig -native 'Fig7_sequentialburstprop1.png';
close all;

%%
%-----Sequential Burst Propogation-----%
i=4;
bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0));
SpikeOrders=[];
for j=1:size(bursts,3)
    b = bursts(:,:,j);
    for k=1:max(b(:))
        SpikeOrders(k,j) = MeaMap(find(b==k));
    end
end
% SpikeOrders(:,end+(oldsize-j))=0;
f = figure('renderer','zbuffer');
h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders,StimSite{i});
% ylim([0 oldsize]);
set(f,'ColorMap',[[0,0,0];cmap]);
axis tight;
set(gca,'PlotBoxAspectRatio',[size(SpikeOrders,1)+4,oldsize,1]);
%-----Save and Close------%
title('sequential burst propogation (outside of superbursts)');
set(gcf,'color','none');
maximize(gcf);
xlabel('spike order within bursts');
ylabel('burst number');
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'TickDir','out');
% saveas(gcf,'Fig7_sequentialburstprop2.eps', 'epsc2');
% fix_pcolor_eps('Fig7_sequentialburstprop2.eps');
% export_fig('Fig7_sequentialburstprop2.eps');
print('-depsc2','-r600','Fig7_sequentialburstprop2.eps');
% print('-dpng','-r300','Fig7_sequentialburstprop2.png');
% export_fig -native 'Fig7_sequentialburstprop2.png';
close all;



