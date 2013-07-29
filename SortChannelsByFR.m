function [tNew,icNew,bsNew,beNew,bwNew] = SortChannelsByFR(t,ic,bs,be,bw)
% Function which removes highly active neurons, non-biological bursts and sorts t,indexchannel by
% how many consecutive bursts electrode participates in.
% Revision 1: 25/07/2013
% Written by: Noah Levine-Small

%% Remove Burst Artifacts
minSize = 150;
idx = (bw > minSize);
cutOut = find(bw<=minSize);
bsNew = bs(idx);
beNew = be(idx);
bwNew = bw(idx);
told=t;
icold=ic;
for i=1:numel(cutOut)
    [t,ic]=RemoveSections(t,ic,bs(cutOut(i)),be(cutOut(i)));
end

[t,ic] = RemoveHAneurons(t,ic,bsNew,beNew);
vec = FindLowFRelectrodes(t,ic,bsNew,beNew);
[~,ix]=sort(vec);
tNew=[];
if numel(vec)>=45
    for i=1:numel(ix)
        t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
        tNew =  [tNew,t1];
        icNew(1,i) = ic(1,ix(i));
        icNew(2,i)=1;
        icNew(3,i)=numel(tNew)-numel(t1)+1;
        icNew(4,i)=numel(tNew);
    end
else
    t= told;
    ic = icold;
    [t,ic] = RemoveHAneurons(t,ic,bsNew,beNew);
    vec = FindLowFRelectrodes(t,ic,bsNew,beNew);
    [~,ix]=sort(vec);
    tNew=[];
    if numel(vec)>=45
        for i=1:numel(ix)
            t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
            tNew =  [tNew,t1];
            icNew(1,i) = ic(1,ix(i));
            icNew(2,i)=1;
            icNew(3,i)=numel(tNew)-numel(t1)+1;
            icNew(4,i)=numel(tNew);
        end
    else
        t= told;
        ic = icold;
        vec = FindLowFRelectrodes(t,ic,bsNew,beNew);
        [~,ix]=sort(vec);
        tNew=[];
        if numel(vec)>=45
            for i=1:numel(ix)
                t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
                tNew =  [tNew,t1];
                icNew(1,i) = ic(1,ix(i));
                icNew(2,i)=1;
                icNew(3,i)=numel(tNew)-numel(t1)+1;
                icNew(4,i)=numel(tNew);
            end
        else
            tNew= told;
            icNew = icold;
        end
    end
end