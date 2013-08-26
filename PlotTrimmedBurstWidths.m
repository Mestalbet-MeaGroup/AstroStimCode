function h = PlotTrimmedBurstWidths(DataSetBase,DataSetStims)
CalcPlotFRprePostTrim; close all;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.1 0.01], [0.05 0.05]);
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
Statistics_CreateGroupsForBurstWidths;
h = ChiPrePostBW(bwsPres,bwsPosts,DataSetStims,DataSetBase);
%%
figure;
%%
subplot(12,1,1);
bar(ratio,'k');
lenLine = 0:1:14;
line(lenLine,ones(length(lenLine)),'LineStyle','-.','Color','r','LineWidth',3);
% ylabel('$\frac{''Spikes Post''}{''Spikes Pre''}$','interpreter','latex');
ylabel(['Spikes Post:', sprintf('\n') 'Spikes Pre'],'position',[-0.37 0.555]);
set(gca,'XTickLabel',[],'YTick',[1,3],'YTickLabel',{'1    ','3    '},'TickDir','in');
set(gca, 'Ticklength', [0.008 0],'box','off');

%%
subplot(12,1,2:5);
hold on;
for i=1:size(bwsPres,1)
    temp1=bwsPres(i,bwsPres(i,:)<5);
    temp2=bwsPres(i,bwsPres(i,:)>=5);
    bws(i,1:length(temp1))=temp1;
    sbws(i,1:length(temp2))=temp2;
end
h1 = notBoxPlot(bws',[],[],'line');
h2  = notBoxPlot(sbws',[],[],'line');
d=[h2.data];
set(d(1:end),'markerfacecolor','b','color','b');
set(gca,'Yscale','log');
set(gca,'XTick',[],'XTickLabel',[],'YTick',[1E-1,1E0,1E1,1E2]);
ylim([0.05,2E2]);
t = title('Baseline','color','b');
pos=get(t,'Pos');
set(t,'pos', [0.352 99.5]);
ylabel('Burst Duration [Sec]');
hold off;

%%
subplot(12,1,6:9);
hold on;
vec=zeros(numel(h)*2,1);
vec(1:2:end) = (1:length(h))-0.03;
vec(2:2:end) = (1:length(h))+0.03;
vals=ones(size(vec)).*0.06;
vals(1:2:end)=vals(1:2:end).*h';
vals(2:2:end)=vals(2:2:end).*h';
plot(vec-0.5,vals,'*r','MarkerSize',12);
for i=1:size(bwsPosts,1)
    temp1=bwsPosts(i,bwsPosts(i,:)<5);
    temp2=bwsPosts(i,bwsPosts(i,:)>=5);
    bws(i,1:length(temp1))=temp1;
    sbws(i,1:length(temp2))=temp2;
end
h3  = notBoxPlot(bws',[],[],'line');
h4  = notBoxPlot(sbws',[],[],'line');
d=[h4.data];
set(d(1:end),'markerfacecolor','r','color','r');
% Plot Significance 

hold off;
set(gca,'XTick',[],'XTickLabel',[],'Yscale','log','YTick',[1E-1,1E0,1E1,1E2]);

ylim([0.05,2E2]);
t= title('Stimulation','color','r');
pos=get(t,'Pos');
set(t,'pos', [0.452 99.5]);
ylabel('Burst Duration [Sec]');


%%
subplot(12,1,10:12);
base=[];
for i=1:size(DataSetBase,1)
    base = [base,(numel(DataSetBase{i}.sbw))/((max(DataSetBase{i}.t)-min(DataSetBase{i}.t))/(12000*60))]; %numel(find(DataSetBase{i}.Trim.bw>10*12000))
end

stim=[];
for i=1:size(DataSetStims,1)
    stim = [stim,(numel(DataSetStims{i}.sbw))/((max(DataSetStims{i}.t)-min(DataSetStims{i}.t))/(12000*60))]; %+numel(find(DataSetStims{i}.Trim.bw>10*12000))
end

bar([base;stim]','Stack');
ylabel('Superburst per minute','position',[-0.385 0.492]);
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-P2A-tRFP ','ChR2 '};
ylab = 0:0.2:1;
ylab1{1}=[num2str(ylab(1)) '    ']; 
for i=2:numel(ylab); ylab1{i}=[num2str(ylab(i)) ' ']; end; 
set(gca,'YTick',ylab,'YTickLabel',ylab1);
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
              [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
              [culTypes{3} '(1)'] [culTypes{3} '(2)']...
              [culTypes{4} '(1)'] [culTypes{4} '(2)'] [culTypes{4} '(3)'] [culTypes{4} '(4)']};
set(gca,'Ticklength', [0.008 0],'box','off')
set(gca,'XTickLabel',cultLabels);
rotateXLabels(gca(),20);

%%
set(gcf,'color','w');
set(findall(gcf,'-property','FontSize'),'FontSize',16)
maximize(gcf);

%%
% export_fig 'AllBurstDurations.png';
% tempAll = [bwsPres,bwsPosts];
% display(min(tempAll(:)));
end
