function [bwPre,sbwPre,bwPost,sbwPost]=CalcEventWidths(DataSetBase,DataSetStims)
% CalcPlotFRprePostTrim; close all;

for i=1:size(DataSetStims,1)
    bwsPost{i} = [DataSetStims{i}.Trim.bw,DataSetStims{i}.sbw];
    numPost(i) = numel(bwsPost{i});
    
    bwsPre{i} = [DataSetBase{i}.Trim.bw,DataSetBase{i}.sbw];
    numPre(i) = numel(bwsPre{i});
end

maxelements = max([numPost,numPre]);
bwsPres = nan(13,maxelements);
bwsPosts = nan(13,maxelements);
bws=bwsPosts;
sbws=bwsPosts;
for i=1:size(DataSetStims,1)
    bwsPosts(i,1:numPost(i))=bwsPost{i}./12000;
    bwsPres(i,1:numPre(i))=bwsPre{i}./12000;
end
for i=1:size(bwsPres,1)
    temp1=bwsPres(i,bwsPres(i,:)<5);
    temp2=bwsPres(i,bwsPres(i,:)>=5);
    bwPre(i,1:length(temp1))=temp1;
    sbwPre(i,1:length(temp2))=temp2;
end

for i=1:size(bwsPosts,1)
    temp1=bwsPosts(i,bwsPosts(i,:)<5);
    temp2=bwsPosts(i,bwsPosts(i,:)>=5);
    bwPost(i,1:length(temp1))=temp1;
    sbwPost(i,1:length(temp2))=temp2;
end
bwPre(bwPre==0)=nan;
sbwPre(sbwPre==0)=nan;
bwPost(bwPost==0)=nan;
sbwPost(sbwPost==0)=nan;
%---Figure---%
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.01], [0.05 0.05]);
subplot(1,2,1);
h1 = notBoxPlot(bwPre',[],[],'line');
h2 = notBoxPlot(sbwPre',[],[],'line');
d=[h2.data];
set(d(1:end),'markerfacecolor',[0 0 1],'color',[0 0 1]);
% set(gca,'Yscale','log');
% set(gca,'XTick',[],'XTickLabel',[],'YTick',[1E-1,1E0,1E1,1E2],'YMinorTick','on');
ylim([0.05,3E2]);
% view(gca,[90 90]);

subplot(1,2,2);
h1 = notBoxPlot(bwPost',[],[],'line');
h2 = notBoxPlot(sbwPost',[],[],'line');
d=[h2.data];
set(d(1:end),'markerfacecolor',[128/255 0 0],'color',[128/255 0 0]);
% set(gca,'Yscale','log');
% set(gca,'XTick',[],'XTickLabel',[],'YTick',[1E-1,1E0,1E1,1E2],'YMinorTick','on');
ylim([0.05,3E2]);
% view(gca,[90 90]);
end
