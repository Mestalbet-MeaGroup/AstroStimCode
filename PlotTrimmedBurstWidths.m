function PlotTrimmedBurstWidths(DataSetBase,DataSetStims)

subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.05 0.05]);
for i=1:size(DataSetStims,1)
    bwsPost{i} = [DataSetStims{i}.Trim.bw,DataSetStims{i}.sbw];
%     bwsPost{i}(bwsPost{i}<50*12)=[];
    numPost(i) = numel(bwsPost{i});
    
    bwsPre{i} = [DataSetBase{i}.Trim.bw,DataSetBase{i}.sbw];
%     bwsPre{i}(bwsPre{i}<50*12)=[];
    numPre(i) = numel(bwsPre{i});
end

maxelements = max([numPost,numPre]);
bwsPres = nan(13,maxelements);
bwsPosts = nan(13,maxelements);

for i=1:size(DataSetStims,1)
bwsPosts(i,1:numPost(i))=bwsPost{i}./12000;
bwsPres(i,1:numPre(i))=bwsPre{i}./12000;
end
Statistics_CreateGroupsForBurstWidths;
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
tempAll = [bwsPres,bwsPosts];
display(min(tempAll(:)));
end
