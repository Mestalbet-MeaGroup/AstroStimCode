%----Plot the increase in superbursting----%
%% Load Data and initialize
load('DataSetOpto_trim4HA.mat');
CultBase = cell2mat(cellfun(@(x) str2num(x.Record(1:4)), DataSetBase,'UniformOutput',false));
CultStims = cell2mat(cellfun(@(x) str2num(x.Record(1:4)), DataSetStims,'UniformOutput',false));

%% Calculate SB rate (Hz)
for i=1:size(DataSetBase,1)
   
    %----Baseline---%
    if isfield(DataSetBase{i},'sbs') %check to make sure the field superburst is present
        if ~isempty(DataSetBase{i}.sbs) %check to make sure there is at least on superburst
            cbase(i) = numel(DataSetBase{i}.sbs) / ((max(DataSetBase{i}.t)-min(DataSetBase{i}.t))/12000); %superbursts per second
        else
            cbase(i) = 0; %if no superbursts, set superburst rate to zero
        end
    else
        cbase(i) = 0; %if no superburst field, set superburst rate to zero
    end
    %----Stimulation---%
    if isfield(DataSetStims{i},'sbs')
        if ~isempty(DataSetStims{i}.sbs)
            cstims(i) = numel(DataSetStims{i}.sbs) / ((max(DataSetStims{i}.t)-min(DataSetStims{i}.t))/12000);
        else
            cstims(i) = 0;
        end
    else
        cstims(i) = 0;
    end
end

%% Statistics
[~,~,subjects]= unique([CultBase;CultStims],'stable');
g1 = [ones(numel(CultBase),1);ones(numel(CultStims),1).*2];
g2 = repmat([ones(4,1);ones(5,1).*2;ones(4,1).*3]+100,2,1);
vars = [cbase,cstims]';
anovan(vars, {g1;g2;subjects}, 'random', 3, 'nested', [0,0,0 ; 0,0,1 ; 1,0,0 ]);
RMAOV1([vars,g1,subjects]);

%% Plot Figure
figure('Color','white');
colors = cbrewer('qual','Set1',numel(unique(subjects)));
vals=[cbase.*60;cstims.*60;subjects(1:13)']';
hold on; 
for i=1:numel(cbase)
l1 = line([1;2],[vals(i,1),vals(i,2)],'Marker','.','MarkerSize',20,'color',colors(vals(i,3),:));
end
l2 = line([1,2],[mean(vals(:,1));mean(vals(:,2))],'LineStyle',':','Marker','d','MarkerSize',10,'LineWidth',3,'Color','k');
l3 = plot([1,2],[median(vals(:,1));median(vals(:,2))]','sk','MarkerSize',30);
xlim([0.8,2.2]);
ylim([-0.5,8.5].*1E-3*60);
set(gca,'XTick',[1,2],'XTickLabel',{'Baseline','Stimulation'},'TickDir','out','PlotBoxAspectRatio',[1,1,1]);
ylabel('superburst frequency [SB * min^{-1}]');
