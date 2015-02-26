function DataSet = CreateATPdataset();
fileList = getAllFiles('E:\ATP_Blockade\*.mat'); % select directory with Mat files containing EAfile variables
cd E:\ATP_Blockade\;

for j=1:size(fileList,1)
    load(fileList{j}(strfind(fileList{j},'at\')+3:end));
%     [t,DataSet{j}.ic] = ConvertNoahSamora('s2n',EAfile);
%     DataSet{j}.t=t';
    DataSet{j}.bs = (EAfile.EVENTDETECTION.NETWORKEVENTONSETS*12/1000)';
    DataSet{j}.be = (EAfile.EVENTDETECTION.NETWORKEVENTOFFSETS*12/1000)';
    DataSet{j}.bw = DataSet{j}.be-DataSet{j}.bs;
    DataSet{j}.vec = EAfile.CLEANDATA.SPIKECHANNEL;
    DataSet{j}.t=(EAfile.CLEANDATA.SPIKETIME*12)/1000;
    ix  = find(cellfun(@(x) strcmp(x,'DPM'),EAfile.CLEANDATA.ADA.drug));
    iy  = find(EAfile.CLEANDATA.ADA.conc>=10,1,'first');
    iz = intersect(ix,iy);
    
    DataSet{j}.label=fileList{j}(strfind(fileList{j},'at\')+3:end);
    deadtime = ((600*1000*1000)*12)/1000; %600 second deadtime
    DataSet{j}.stimT1(1) = (EAfile.CLEANDATA.ADA.time(1)*12)/1000+deadtime;
    DataSet{j}.stimT1(2) = (EAfile.CLEANDATA.ADA.time(2)*12)/1000;
    DataSet{j}.stimT2(1) = (EAfile.CLEANDATA.ADA.time(iz)*12)/1000+deadtime;
    DataSet{j}.stimT2(2) = (EAfile.CLEANDATA.ADA.time(iz+1)*12)/1000;
%--------Burst Rate Control--------%
    ctrl = find(DataSet{j}.bs<=DataSet{j}.stimT1(2));
    DataSet{j}.bRate(1) = numel(ctrl) / DataSet{j}.stimT1(2); 
%      DataSet{j}.bRate(1) = mean(diff(DataSet{j}.bs(ctrl)));
%--------Burst Rate 10uM Dipramodyl (ATP->Adenosine blockade)----------%
    stim = find((DataSet{j}.bs>DataSet{j}.stimT2(1)) & (DataSet{j}.bs<=DataSet{j}.stimT2(2)));
    DataSet{j}.bRate(2) = numel(stim) / (DataSet{j}.stimT2(2)-DataSet{j}.stimT2(1));
    DataSet{j}.bRate=DataSet{j}.bRate*12000*60;
%       DataSet{j}.bRate(2) = mean(diff(DataSet{j}.bs(stim)));
end

figure('Color','white');
hold on; 
l1 = line([ones(1,5);ones(1,5).*2],[cellfun(@(x) x.bRate(1),DataSet);cellfun(@(x) x.bRate(2),DataSet)]./repmat(cellfun(@(x) x.bRate(1),DataSet),2,1),'Marker','.','MarkerSize',20);
l2 = line([1,2],[mean(cellfun(@(x) x.bRate(1),DataSet));mean(cellfun(@(x) x.bRate(2),DataSet))]./repmat(mean(cellfun(@(x) x.bRate(1),DataSet)),2,1),'LineStyle',':','LineWidth',3,'Color','k');
legend([l1;l2],{'NetWork 1','NetWork 2','NetWork 3','NetWork 4','NetWork 5','Mean Line'},'Location','NorthWest');
% set(gca,'YScale','log');
p1 = plot([0 3],[1 1],'k-','LineWidth',3);
bp1 = boxplot([zeros(1,5);cellfun(@(x) x.bRate(2),DataSet)./cellfun(@(x) x.bRate(1),DataSet)]','colors','wk');
h = findobj(gca,'tag','Median');
set(h,'linewidth',3);
xlim([0.9,2.2]);
ylim([0.9 6.9]);
set(gca,'XTickLabel',{'Baseline','10uM DPM'},'TickDir','out');
ylabel(gca,'burst rate increase over baseline');
set(findall(gcf,'-property','FontSize'),'FontSize',18)
ratios = cellfun(@(x) x.bRate(2)/x.bRate(1),DataSet);
p = ranksum(ratios, ones(6,1))

close all;

figure('Color','white');
hold on; 
l1 = line([ones(1,5);ones(1,5).*1.2],[cellfun(@(x) x.bRate(1),DataSet);cellfun(@(x) x.bRate(2),DataSet)],'Marker','.','MarkerSize',20);
l2 = line([1,1.2],[mean(cellfun(@(x) x.bRate(1),DataSet));mean(cellfun(@(x) x.bRate(2),DataSet))],'Marker','.','MarkerSize',30,'LineStyle',':','LineWidth',3,'Color','k');
% set(gca,'YScale','log');
% p1 = plot([0 3],[1 1],'k-','LineWidth',3);
% bp1 = boxplot([cellfun(@(x) x.bRate(1),DataSet);cellfun(@(x) x.bRate(2),DataSet)]','colors','kk');
l3 = plot ([1,1.2],median([cellfun(@(x) x.bRate(1),DataSet);cellfun(@(x) x.bRate(2),DataSet)]'),'sk','MarkerSize',30);
legend([l1;l2;l3(1)],{'Network 1','Network 2','Network 3','Network 4','Network 5','Mean Line','Median'},'Location','NorthWest');
% h = findobj(gca,'tag','Median');
% set(h,'linewidth',3);
xlim([0.9,1.3]);
set(gca,'XTick',[1,1.2]);
ylim([0 40]);
set(gca,'XTickLabel',{'Baseline','10uM DPM'},'TickDir','out','PlotBoxAspectRatio',[1,1,1]);
ylabel(gca,'burst frequency [bursts * min^{-1}]');
set(findall(gcf,'-property','FontSize'),'FontSize',18)
ratios = cellfun(@(x) x.bRate(2)/x.bRate(1),DataSet);
p = ranksum(ratios, ones(6,1))