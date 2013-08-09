function [sbs,sbe,sbw] = ManualSuperBurstSelection(t,ic);
addpath(genpath('C:\Users\Noah\Documents\GitHub\Detect'));
[Firings,SumFirings]=FindNeuronFrequency(t,ic,25,1);
clipboard('copy',round(max(t)/12000));
fs = length(SumFirings)/(max(t)/12000);
labelSet = markEvents(Firings,{'1'},'srate',fs);
if ~isempty(labelSet)
    sbs = cell2mat(labelSet(1:end,2))*12000+min(t)+12000;
    sbe = cell2mat(labelSet(1:end,3))*12000+min(t)+12000;
    sbs=sbs';
    sbe=sbe';
    sbw=sbe-sbs;
else
    sbs=[];
    sbe=[];
    sbw=[];
end
rmpath(genpath('C:\Users\Noah\Documents\GitHub\Detect'));
end