function [tNew,icNew,bsNew,beNew,bwNew] = SortChannelsByFR(t,ic,bs,be,bw)
% Function which removes highly active neurons, non-biological bursts and sorts t,indexchannel by
% how many consecutive bursts electrode participates in.
% Revision 1: 25/07/2013
% Written by: Noah Levine-Small

%% Remove Burst Artifacts
minSize = 120;
idx = (bw > minSize);
cutOut = find(bw<=minSize);
bsNew = bs(idx);
beNew = be(idx);
bwNew = bw(idx);
% bsNew=bs;
% beNew=be;
% bwNew=bw;

told=t;
icold=ic;
% for i=1:numel(cutOut)
%     [t,ic]=RemoveSections(t,ic,bs(cutOut(i)),be(cutOut(i)));
% end
%%
[t,ic] = RemoveHAneurons(t,ic,bsNew,beNew);

%%
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
    [tNew,icNew]=PostTrimHAdetection(tNew,icNew);
end
%% Re-do Burst Detection on reduced TIC
% Firing rates and minimum number of channels
t1=tNew;
ic1=icNew;
[Firings,~]=FindNeuronFrequency(t1,ic1,500,1);
Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
[Firings,ix]=sort(Firings,'descend');
ix = ix((Firings<1E-4)|(Firings>0.024));
for i=1:length(ix)
    k=ix(i);
    [t1,ic1]=removeNeuronsWithoutPrompt(t1,ic1,[icNew(1,k);1]);
end
tt = sort(t1);
f = savgol(10,1,0);
increment=5;
frB = histc(tt,0:increment:max(tt));
frB = filtfilt(f,1,frB);
frB = filtfilt(MakeGaussian(0,30,120),1,frB);
[pks,locs]=findpeaks(frB,'MinPeakHeight',mean(frB));
Y = quantile(pks,10);

frB(frB<Y(2))=0;
% frB(frB<(max(frB)-mean(frB))/6)=0; %Must find a more adaptive threshold
 [a,b]=initfin(frB);

 % Are there enough spikes to qualify?
if ~isempty(a)
for j=1:length(a)
    area(j) = trapz(frB(a(j):b(j)));
    for k=1:size(ic1,2)
        ttemp = t1(ic1(3,k):ic1(4,k));
        ttemp = ttemp(ttemp>a(j)*increment);
        ttemp = ttemp(ttemp<b(j)*increment);
    end
end
athresh=15;
subset1 = (area > athresh);
bsNew = a(subset1).*increment;
beNew = b(subset1).*increment;

% What percentage of channels participate?
for j=1:length(bsNew)
    ChanSpks(j)=0;
    for k=1:size(icNew,2)
        ttemp = tNew(icNew(3,k):icNew(4,k));
        ttemp = ttemp(ttemp>bsNew(j));
        ttemp = ttemp(ttemp<beNew(j));
        ChanSpks(j) = ChanSpks(j) + ~isempty(ttemp);
    end
end
subset2 = (ChanSpks>0.15*size(ic1,2));

% subset = (subset1+subset2)>1;
bsNew = bsNew(subset2);
beNew = beNew(subset2);

% Merge bursts whose IBIs are below a threshold
ibi = bsNew(2:end)-beNew(1:end-1);
thresh = 0.2*12000; %200 ms is minimum biologically plausable IBI 
bIdx = find(ibi<thresh);
bsNew(bIdx+1)=[];
beNew(bIdx)=[];
else
    bsNew=[];
    beNew=[];
end

%PlotRasterWithBursts(tNew,icNew,bsNew,beNew);

%%
bwNew = beNew-bsNew;
minSize = 120;%*12; 
idx = (bwNew > minSize);
cutOut = find(bwNew<=minSize);
for i=1:numel(cutOut)
    [tNew,icNew]=RemoveSections(tNew,icNew,bsNew(cutOut(i)),beNew(cutOut(i)));
end
bsNew = bsNew(idx);
beNew = beNew(idx);
bwNew = bwNew(idx);

% PlotRasterWithBursts(tNew,icNew,bsNew,beNew);
end
