function [tHA,icHA] = CalcFracSpikesInBursts(t,ic,bs,be);
%Finds HA electrodes
for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)));
    if numel(t1)>mean(ic(4,:)-ic(3,:))
        inB=0;
        for j=1:numel(bs)
            inB = inB+sum(t1>bs(j) & t1<be(j));
        end
        spikes(i)= inB/numel(t1);
    else
        spikes(i)=1;
    end
end
spikes=1-spikes;
ix=find(spikes>0.1);


tHA=[];
for i=1:numel(ix)
    t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
    tHA =  [tHA,t1];
    icHA(1,i) = ic(1,ix(i));
    icHA(2,i)=1;
    icHA(3,i)=numel(tHA)-numel(t1)+1;
    icHA(4,i)=numel(tHA);
end

end