% Supplementary Figures %

%% Load Data
fileList = getAllFiles('E:\AstroStimArticleDataSet\Pooled Stim MCDs');
load('DataSetOpto_trim4HA.mat');


%% Initialize Reagents Groups
culTypes = {'Melanopsin ','OptoA1','ChR2 '};
cultLabels =     {culTypes{1},culTypes{1},culTypes{1},culTypes{1},...
                  culTypes{2},culTypes{2},culTypes{2},...
                  culTypes{2},culTypes{2},...
                  culTypes{3},culTypes{3}, culTypes{3}, culTypes{3}};
              
              
%% Calculate Anova for Time till first Superburst
for i=1:size(fileList,1)
    [~,~,trigger]=GetTriggers(fileList{i});
    if ~isempty(trigger)
     triggers(i)=trigger(1);
    else
        triggers(i)=nan;
    end
end
    
for i=1:size(DataSetStims,1);
    if ~isnan(triggers(i))&&(~isempty(DataSetStims{i}.sbs))
        timetoSB(i) = DataSetStims{i}.sbs(1)-triggers(i);
    else
        timetoSB(i)=nan;
    end    
end

[p,table,stats] = anova1(timetoSB./12000,cultLabels);

%% Calculate Anova for Superburst Duration

sbws = cellfun(@(x) x.sbw,DataSetStims,'UniformOutput',false);
sbws{8}=nan;
sbws{11}=nan;
num = max(cellfun(@(x) numel(x),sbws));

SBdurations=nan(num,13);
for i=1:size(DataSetStims,1);
SBdurations(1:numel(sbws{i}),i)=sbws{i};
end

[p,table,stats] = anova1(SBdurations(:,[1:3,5:end])./12000,cultLabels([1:3,5:end]));
