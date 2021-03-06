%% Normalize Traces
load('CorrFigAstroTracesData.mat'); % 4398 ch 199
clear fr;
% Select Traces with Signal
[tr,trtime]  = CalcDf_f(traces(:,600:end),fs,time(600:end));
for i=1:size(tr,1)
    [sdtr,wtr]=pwelch(tr(i,:)');
    score(i) = trapz(sdtr(1:find(wtr>0.1,1,'First')))/trapz(sdtr(find(wtr>0.9,1,'First'):end));
end
clusts = kmeans(score',2);
if mean(score(clusts==1))>mean(score(clusts==2))
    choose=1;
else
    choose=2;
end
tr2 = tr(score>25,:);

% Normalize traces to be Z-score values
 for i=1:size(tr2,1)
    tr2(i,:)=zscore(tr2(i,:));
 end

% Calculate FR according to samples of Ca-traces
for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)))./12;
        fr(:,i)  = histc(t1,trtime*1000);     % Calculate the firing rate for each electrode
end

%% Produce Figures
% screen_size = get(0, 'ScreenSize');
% figure('renderer','zbuffer','visible','off','Position', [0 0 screen_size(3) screen_size(4) ])
figure( 'renderer','zbuffer','visible','off','units', 'centimeters', 'Position', [0 0 173 89])
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.05], [0.05 0.05]);

%---Remove End Artifacts---%
tr2=tr2(:,1:end-15);
trtime=trtime(1:end-15);
fr=fr(1:end-15,:);

%-------Create Astro Trace 'Raster'------------%
subplot(10,1,1:5);
x = repmat(1:size(tr2,1),size(tr2,2),1);
y = repmat(trtime',1,size(tr2,1));
z = zeros(size(y));
area = trapz(tr2,2);
[~,order]=sort(area,'descend');
cdata = real2rgb(tr2(order,:)','-bone',[0,5]);
surface(y,x,z,cdata,'EdgeColor','none','FaceColor','texturemap','CDataMapping','direct'); axis('tight');
set(gca,'XTick',[],'YTick',[]); % hides the ticks on x-axis
set(gca,'YColor','w','XColor','w');
ylabel('Regions of Interest','color','k');
% Overlay Firing Rate
hold on;
patchline(trtime,zscore(mean(fr,2)),'linestyle','-','edgecolor','r','linewidth',28,'edgealpha',0.2);
hold off;
%----------------------------------%
subplot(10,1,6:10);
RasterPlotLineTrace(t,ic,min(trtime)*12000,max(trtime)*12000,mean(tr2,1),trtime.*12000);
%----------------------------------%
% Save figure
set(gcf,'Color','w');
export_fig('Fig_TraceRaster_A-B.png','-r1200');
% print('-depsc','-r300','Fig_TraceRasterA-B.eps');
close all;

%------------Burst+NoTrace-----------%
figure('renderer','zbuffer','visible','off','Position', [0 0 screen_size(3) screen_size(4) ])
RasterPlotLineTrace(t,ic,3.007E7,3.014E7,tr2(15:18,:),trtime.*12000);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
% print('-dpng','-r300','Fig_TraceRasterC.png');
export_fig('Fig_TraceRaster_C.eps','-r300');
close all;
%Minute 42
%-------------------------%

%------------Burst+Trace-----------%
figure('renderer','zbuffer','visible','off','Position', [0 0 screen_size(3) screen_size(4) ])
RasterPlotLineTrace(t,ic,1.157E7,1.164E7,tr2(15:18,:),trtime.*12000);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
% print('-dpng','-r300','Fig_TraceRasterD.png');
export_fig('Fig_TraceRaster_D.eps','-r300');
close all;
%Minute 16
%-------------------------%

%------------SB+Trace-----------%
figure('renderer','zbuffer','visible','off','Position', [0 0 screen_size(3) screen_size(4) ])
RasterPlotLineTrace(t,ic,5.132E6,5.202E6,tr2(15:18,:),trtime.*12000);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
% print('-dpng','-r300','Fig_TraceRasterE.png');
export_fig('Fig_TraceRaster_E.eps','-r300');
close all;
%Minute 7
%-------------------------%

%------------NoBurst+Trace-----------%
figure('renderer','zbuffer','visible','off','Position', [0 0 screen_size(3) screen_size(4) ])
RasterPlotLineTrace(t,ic,8.854E6,8.924E6,tr2(15:18,:),trtime.*12000);
set(gca,'PlotBoxAspectRatio',[1,1,1]);
% print('-dpng','-r300','Fig_TraceRasterF.png');
export_fig('Fig_TraceRaster_F.eps','-r300');
close all;
%Minute 12
%-------------------------%
