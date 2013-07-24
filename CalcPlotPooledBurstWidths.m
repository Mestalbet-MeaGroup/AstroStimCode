% Calculates the pooled burst widths
bwsPost=[];
bwsPre=[];
% vec = 1:size(DataSetStims,1);
% vec(11)=[];

for i=1:size(DataSetStims,1)
    bwsPost = [bwsPost,DataSetStims{i}.bw,DataSetStims{i}.sbw];
    bwsPre = [bwsPre,DataSetBase{i}.bw,DataSetBase{i}.sbw];
end

if numel(bwsPost)>numel(bwsPre)
    bwsPre(end+1:length(bwsPost))=nan;
end
[h,p,ci,stats]  = ttest(bwsPre,bwsPost);
notBoxPlot([bwsPre./12000;bwsPost./12000]');
set(gca,'Yscale','log');
set(gca,'XTickLabels',{'Baseline','Stimulated'});
ylabel('Burst Duration [Sec]','FontSize',18);
set(gca,'FontSize',18);
title('Pooled Burst durations','FontSize',18);
maximize(gcf);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
set(gcf,'color','w');
export_fig 'PooledBurstDuration.png'
% print(gcf, '-r600', '-dpng', 'PooledBurstDuration.png');
close all;
clear_all_but('DataSetStims','DataSetBase'); clc;

subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.05 0.05]);
for i=1:size(DataSetStims,1)
    bwsPost{i} = [DataSetStims{i}.bw,DataSetStims{i}.sbw];
    numPost(i) = numel(bwsPost{i});
    
    bwsPre{i} = [DataSetBase{i}.bw,DataSetBase{i}.sbw];
    numPre(i) = numel(bwsPre{i});
end

maxelements = max([numPost,numPre]);
bwsPres = nan(13,maxelements);
bwsPosts = nan(13,maxelements);

for i=1:size(DataSetStims,1)
    
bwsPosts(i,1:numPost(i))=bwsPost{i}./12000;
bwsPres(i,1:numPre(i))=bwsPre{i}./12000;
end
figure;
subplot(2,1,1);
h1 = notBoxPlot(bwsPres',[],[],'line'); 
set(gca,'XTickLabel',[]);
set(gca,'Yscale','log');
set(gca,'FontSize',18);
title('Baseline','FontSize',18);
ylim([1E-3,1E3]);
ylabel('Burst Duration [Sec]');
subplot(2,1,2);
h2  = notBoxPlot(bwsPosts',[],[],'line'); 
set(gca,'Yscale','log');
set(gca,'FontSize',18);
title('Stimulation','FontSize',18);
ylim([1E-3,1E3]);
xlabel('Cultures');
clear_all_but('DataSetStims','DataSetBase'); clc;
maximize(gcf);
set(gcf,'color','w');
export_fig 'AllBurstDurations.png';
% print(gcf, '-r600', '-dpng', 'AllBurstDurations.png');
