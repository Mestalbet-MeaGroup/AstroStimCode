function [t,ic]=PostTrimHAdetection(t,ic)
% Removes remaining HA neurons using firing rates after first sorting, removal of low FR and
% HA removal (using participation in bursts).
for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)));
    numSpikes(i)=numel(t1);
end
thresh = mean(numSpikes)+2*std(numSpikes);
extraHA=ic(1,numSpikes>=thresh);
% HAelec = [HAelec;extraHA'];
% HAelec = unique(HAelec);

for i=1:numel(extraHA)
    [t,ic]=removeNeuronsWithoutPrompt(t,ic,[extraHA(i);1]);
end
end