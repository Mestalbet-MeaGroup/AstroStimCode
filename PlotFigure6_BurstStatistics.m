
% load('DataSetOpto_withControlCults.mat')
% load('16x16MeaMap_90CW_Inverted.mat');
% BurstData = GenerateBurstData(DataSetBase,DataSetStims,MeaMap);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.001], [0.05 0.05], [0.05 0.05]);

%% Plot Burst Width CDFs
regbw  = BurstData.bw(BurstData.nsbsb==0); % Outside of SBs
sbbw  = BurstData.bw(BurstData.nsbsb==1); % Inside of SBs
[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'./1200); % Convert to ms
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'./1200);
figure('renderer','opengl');
% subplot(1,3,1:2);
hold on;
%----Baseline----%
loglog(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
% patch(limRegX,limRegY,'b','FaceAlpha',0.2,'EdgeColor','b');
patch(limRegX,limRegY,'b','FaceColor','none','EdgeColor','b');
%----Stimulation----%
loglog(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
% patch(limSBX,limSBY,'r','FaceAlpha',0.2,'EdgeColor','r');
patch(limSBX,limSBY,'r','FaceColor','none','EdgeColor','r');
xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)/5]);
ylim([0 max(regCDFy)]);
xlabel('time [ms]');
ylabel('probability');
title('cumulative density function: burst durations');
hold off
legend('regular bursts','95% confidence bounds','bursts within superbursts','95% confidence bounds','Location','SouthEast');

%--------%
% 
% s = subplot(1,3,3);
% hold on;
% %----Baseline----%
% loglog(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
% % patch(limRegX,limRegY,'b','FaceAlpha',0.2,'EdgeColor','b');
% patch(limRegX,limRegY,'b','FaceColor','none','EdgeColor','b');
% %----Stimulation----%
% loglog(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
% % patch(limSBX,limSBY,'r','FaceAlpha',0.2,'EdgeColor','r');
% patch(limSBX,limSBY,'r','FaceColor','none','EdgeColor','r');
% xlim([min(xlimtest) max(xlimtest)]);
% % xlim([max(sbCDFx) max(regCDFx)]);
% ylim([0 max(regCDFy)]);
% legend('regular bursts','95% confidence bounds','bursts within superbursts','95% confidence bounds','Location','SouthEast');
% hold off;
% set(gca,'YTick',[],'YTickLabel',[],'XScale','log');
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFburstdurations.eps');
% print('-depsc2','-r300','Fig6_CDFburstdurations.eps');
% print('-dpng','-r300','Fig6_CDFburstdurations.png');
% export_fig -native 'Fig6_CDFburstdurations.png'
close all;

%% Plot Spike Numbers per burst CDFs

regfr  = BurstData.numspikes(BurstData.nsbsb==0);%./(BurstData.bw(BurstData.nsbsb==0))'; %Outside of SBs
sbfr   = BurstData.numspikes(BurstData.nsbsb==1);%./(BurstData.bw(BurstData.nsbsb==1))'; %Inside of SBs

[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr');
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr');

figure('renderer','opengl');
%----Baseline----%
hold on;
loglog(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
patch(limRegX,limRegY,'b','FaceColor','none','EdgeColor','b');
%----Stimulation----%
loglog(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
patch(limSBX,limSBY,'r','FaceColor','none','EdgeColor','r');
xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)/3]);
ylim([0 max(regCDFy)+0.02]);
xlabel('Spikes per channel');
ylabel('probability');
title('cumulative density function: number of spikes within bursts');
hold off

%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFspikecount.eps');
% print('-depsc2','-r300','Fig6_CDFspikecount.eps');
% print('-dpng','-r300','Fig6_CDFspikecount.png');
% export_fig -native 'Fig6_CDFspikecount.png';

close all;
%% Plot Average Spike Rate per burst CDFs

regfr  = BurstData.numspikes(BurstData.nsbsb==0)./(BurstData.bw(BurstData.nsbsb==0))'; %Outside of SBs
sbfr   = BurstData.numspikes(BurstData.nsbsb==1)./(BurstData.bw(BurstData.nsbsb==1))'; %Inside of SBs

[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr'.*12000);
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr'.*12000);

figure('renderer','opengl');
%----Baseline----%
hold on;
loglog(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
% patch(limRegX,limRegY,'b','FaceAlpha',0.2,'EdgeColor','b');
patch(limRegX,limRegY,'b','FaceColor','none','EdgeColor','b');
%----Stimulation----%
loglog(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
% patch(limSBX,limSBY,'r','FaceAlpha',0.2,'EdgeColor','r');
patch(limSBX,limSBY,'r','FaceColor','none','EdgeColor','r');
xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)]);
ylim([0 max(regCDFy)+0.02]);
c = -1; 
tit = sprintf('spikes*(seconds*channels)^{%.0f}', c);
xlabel(['frequency [' tit ']']);
ylabel('probability');
title('cumulative density function: firing rate within bursts');
hold off
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFfiringrates.eps');
% print('-depsc2','-r300','Fig6_CDFfiringrates.eps');
% print('-dpng','-r300','Fig6_CDFfiringrates.png');
% export_fig -native 'Fig6_CDFfiringrates.png';
close all;
%% Plot Average Channel Participation per burst

regfr  = BurstData.spikesPcntMax(BurstData.nsbsb==0); %Outside of SBs
sbfr   = BurstData.spikesPcntMax(BurstData.nsbsb==1); %Inside of SBs

[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr');
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr');

figure('renderer','opengl');
%----Baseline----%
hold on;
loglog(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
patch(limRegX,limRegY,'b','FaceColor','none','EdgeColor','b');
%----Stimulation----%
loglog(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
patch(limSBX,limSBY,'r','FaceColor','none','EdgeColor','r');
xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)]);
ylim([0 max(regCDFy)+0.02]);
xlabel('recruitment [%]');
ylabel('probability');
title('cumulative density function: Percentage Participation per Burst');
hold off
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFprecentageburstparticipation.eps');
% print('-depsc2','-r300','Fig6_CDFprecentageburstparticipation.eps');
% print('-dpng','-r300','Fig6_CDFprecentageburstparticipation.png');
% export_fig -native 'Fig6_CDFprecentageburstparticipation.png';
close all;
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
saveas(gcf,['Fig6_BurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig6_BurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig6_BurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig6_BurstInitiation',type, '.png']);
% export_fig -native ['Fig6_BurstInitiation',type, '.png'];
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
saveas(gcf,['Fig6_SpotBurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig6_SpotBurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig6_SpotBurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig6_SpotBurstInitiation',type, '.png']);
% export_fig -native ['Fig6_SpotBurstInitiation',type, '.png'];
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
saveas(gcf,['Fig6_BurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig6_BurstInitiation',type, '.eps']);
% print('-depsc2','-r300',['Fig6_BurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig6_BurstInitiation',type, '.png']);
% export_fig -native ['Fig6_BurstInitiation',type, '.png'];
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
% print('-depsc2','-r300',['Fig6_SpotBurstInitiation',type, '.eps']);
saveas(gcf,['Fig6_SpotBurstInitiation',type, '.eps'], 'epsc2');
fix_pcolor_eps(['Fig6_SpotBurstInitiation',type, '.eps']);
% print('-dpng','-r300',['Fig6_SpotBurstInitiation',type, '.png']);
% export_fig -native ['Fig6_SpotBurstInitiation',type, '.png'];
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
% print('-dpng','-r300','Fig6_ColorMap.png');
% export_fig('Fig6_ColorMap.eps');
saveas(gcf,'Fig6_ColorMap.eps', 'epsc2');
fix_pcolor_eps('Fig6_ColorMap.eps');
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
figure('renderer','zbuffer');
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
% saveas(gcf,'Fig6_sequentialburstprop1a.eps', 'epsc2');
% fix_pcolor_eps('Fig6_sequentialburstprop1a.eps');
% export_fig('Fig6_sequentialburstprop1.eps');
print('-depsc2','-r600','-cmyk ','Fig6_sequentialburstprop1.eps');
% print('-dpng','-r300','Fig6_sequentialburstprop1.png');
% export_fig -native 'Fig6_sequentialburstprop1.png';
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
figure('renderer','zbuffer');
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
% saveas(gcf,'Fig6_sequentialburstprop2.eps', 'epsc2');
% fix_pcolor_eps('Fig6_sequentialburstprop2.eps');
% export_fig('Fig6_sequentialburstprop2.eps');
print('-depsc2','-r600','Fig6_sequentialburstprop2.eps');
% print('-dpng','-r300','Fig6_sequentialburstprop2.png');
% export_fig -native 'Fig6_sequentialburstprop2.png';
close all;



