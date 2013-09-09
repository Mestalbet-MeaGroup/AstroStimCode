fileList = getAllFiles('E:\AstroStimArticleDataSet\Pooled Stim MCDs');
load('DataSetOpto_trim4HA.mat');

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
        timetoSB(i) = DataSetStims{i}.sbs(1)./12000-triggers(i);
    else
        timetoSB(i)=nan;
    end    
end

for i=1:size(DataSetStims,1);
    if (length(DataSetStims{i}.sbs)>1)
        timetoSB(i) = (DataSetStims{i}.sbs(2)-DataSetStims{i}.sbs(1))./12000;
    else
        timetoSB(i)=nan;
    end    
end

[timetoSB,ix]=sort(timetoSB,'descend');
timetoSB(timetoSB<-2000)=nan;