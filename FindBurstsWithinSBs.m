function [bs,be] = FindBurstsWithinSBs(t,ic,sbs,sbe)
[t,ic] = CutSortChannel2(t,ic,sbs,sbe);
fr=histc(sort(t),min(t):100:max(t));
fr = filtfilt(MakeGaussian(0,3,12),1,fr);
[bs,be]=initfin( (fr>0)|([0,0,diff(diff(fr))]>0));
bs=bs.*100;
be=be.*100;
for i=1:numel(bs)
    temp=histc(sort(t),[bs(i),be(i)]);
    spikecheck(i) = temp(1) > 100;
end
bs = bs(spikecheck)+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs
be = be(spikecheck)+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs
end