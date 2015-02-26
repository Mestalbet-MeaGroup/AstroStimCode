fclose('all');clear all; close all;clc;
load('F:\CalciumImagingArticleDataSet\Mat Files\DataSet.mat');
load('F:\CalciumImagingArticleDataSet\Mat Files\CombinedManualData\3334_ch014_FullSet.mat','triggers','traces','t','ic');
time = CalcTimeFromTriggers('F:\CalciumImagingArticleDataSet\MCD Files\NN3334_centered14FullPower.mcd');
tcenter=216*12000;
startframe=tcenter-2/2*(12000*60);
endframe=tcenter+2/2*(12000*60);
vec = [3,109,23,37,104];
vec1= [1,32,8,13,31];
pair=[2,5];
tr = DataSet{1}.Manual.FiltTraces(:,vec1(pair));
time1 = DataSet{1}.Manual.time(1:end-1);


% load('Neuropil_3334_014.mat');
% neuropilN=(neuropil-min(neuropil))./(max(neuropil)-min(neuropil));
% tr=traces(vec(pair),:)';
% 
% for i=1:size(tr,2)
%     tr(:,i)=(tr(:,i)-min(tr(:,i)))./(max(tr(:,i))-min(tr(:,i)));
%     tr(:,i) = tr(:,i)-neuropilN;
%     tr(:,i)=(tr(:,i)-min(tr(:,i)))./(max(tr(:,i))-min(tr(:,i)));
% end
% PlotRasterWithAstroTrace2(t,ic,time(1:end-1),[traces(vec(pair),:)',neuropil],startframe,endframe,[tr,neuropil],time(1:end-1));
figure;
PlotRasterWithAstroTrace2(t,ic,time1,tr,startframe,endframe);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
maximize(gcf);
set(gcf,'color','none');
% export_fig  'rasterTest.png' -native;
print('-depsc2','-r300','RasterWithTrace.eps');
close all;
PlotTracesFR (DataSet{2}.t,DataSet{2}.ic,DataSet{2}.Manual.time,DataSet{2}.Manual.FiltTraces,100,9.6);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
maximize(gcf);
set(gcf,'color','none');
print('-depsc2','-r300','TracesWithFR.eps');
close all;

% time = CalcTimeFromTriggers('C:\Users\Noah\Desktop\NN3334_centered122.mcd');
% load('C:\Users\Noah\Desktop\3334_ch122_FullSet.mat','triggers','traces','t','ic');
% PlotRasterWithAstroTrace(t,ic,216*12000,2,time,traces');

