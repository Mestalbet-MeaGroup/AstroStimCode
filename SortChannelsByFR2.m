function [tNew,icNew,bsNew,beNew,bwNew] = SortChannelsByFR2(t,ic,bs,be,bw)
% Function which removes highly active neurons, non-biological bursts and sorts t,indexchannel by
% how many consecutive bursts electrode participates in.
% Revision 2: 07/08/2013 *modified version of SortChannelsByFR
% Written by: Noah Levine-Small

%% Trim and sort channel list
% [t1,ic1] = RemoveHAneurons(t,ic,bsNew,beNew);
[Firings,~]=FindNeuronFrequency(t,ic,500,1);
Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
[~,ix]=sort(Firings,'descend');
t1=[];
for i=1:numel(ix)
        tt1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
        t1 =  [t1,tt1];
        ic1(1,i) = ic(1,ix(i));
        ic1(2,i)=1;
        ic1(3,i)=numel(t1)-numel(tt1)+1;
        ic1(4,i)=numel(t1);
end
[Firings,~]=FindNeuronFrequency(t1,ic1,500,1);
Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
[~,ix]=sort(Firings,'descend');
ix = ix((Firings<1E-4)|(Firings>0.024));
ictemp=ic1;
for i=1:length(ix)
    k=ix(i);
    [t1,ic1]=removeNeuronsWithoutPrompt(t1,ic1,[ictemp(1,k);1]);
end

%% Setup Samora data structure for Samora's functions
ic2 = ConvertIC2Samora(ic1);
load('16x16MeaMap_90CW_Inverted.mat');
EAfile.INFO.MEA.TYPE = '16x16';
EAfile.RAWDATA.CHANNELMAP = MeaMap; % or your channelmap variable
EAfile.RAWDATA.SPIKETIME = (t1/12)*1000; %Spikes in Microscecond
EAfile.RAWDATA.SPIKECHANNEL = ic2;
EAfile.RAWDATA.GROUNDEDCHANNEL = [];
EAfile.RAWDATA.REFERENCECHANNEL = [];
EAfile.INFO.FILE.LIMITS=[0,inf];
% clear t; clear ic2;
clear vec; clear MeaMap;
EAfile = EA_CLEANDATA2(EAfile);
% EAfile = EA_CLEANDATA2(EAfile,'synch_precision',10e3);
t1 = ((EAfile.CLEANDATA.SPIKETIME*12)/1000)';
ic1 = ConvertSamora2IC(EAfile.CLEANDATA.SPIKECHANNEL);
clear EAfile;

[Firings,~]=FindNeuronFrequency(t,ic,500,1);
Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
[~,ix]=sort(Firings,'descend');
t1=[];
for i=1:numel(ix)
        tt1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
        t1 =  [t1,tt1];
        ic1(1,i) = ic(1,ix(i));
        ic1(2,i)=1;
        ic1(3,i)=numel(t1)-numel(tt1)+1;
        ic1(4,i)=numel(t1);
end
[Firings,~]=FindNeuronFrequency(t1,ic1,500,1);
Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
[~,ix]=sort(Firings,'descend');
ix = ix((Firings<1E-4)|(Firings>0.024));
ictemp=ic1;
for i=1:length(ix)
    k=ix(i);
    [t1,ic1]=removeNeuronsWithoutPrompt(t1,ic1,[ictemp(1,k);1]);
end

% [t1,ic1]=PostTrimHAdetection(t1,ic1);
%% Re-do Burst Detection on reduced TIC
% Firing rates and minimum number of channels
tt = sort(t1);
f = savgol(10,1,0);
increment=5;
frB = histc(tt,0:increment:max(tt));
frB = filtfilt(f,1,frB);
frB = filtfilt(MakeGaussian(0,30,120),1,frB);
[pks,locs]=findpeaks(frB,'MinPeakHeight',mean(frB));
Y = quantile(pks,10);
frB(frB<Y(2))=0;
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
    for k=1:size(ic1,2)
        ttemp = t1(ic1(3,k):ic1(4,k));
        ttemp = ttemp(ttemp>bsNew(j));
        ttemp = ttemp(ttemp<beNew(j));
        ChanSpks(j) = ChanSpks(j) + ~isempty(ttemp);
    end
end
subset2 = (ChanSpks>0.25*size(ic1,2));
bsNew = bsNew(subset2);
beNew = beNew(subset2);

% Filter non-biologically plausible bursts
bwNew = beNew-bsNew;
minSize = 120*12;
idx = (bwNew > minSize);
cutOut = find(bwNew<=minSize);
for i=1:numel(cutOut)
    [t1,ic1]=RemoveSections(t1,ic1,bsNew(cutOut(i)),beNew(cutOut(i)));
end
bsNew = bsNew(idx);
beNew = beNew(idx);
bwNew = bwNew(idx);

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


tNew=t1;
icNew=ic1;

% minSize = 120*12; 
% idx = (bwNew > minSize);
% cutOut = find(bwNew<=minSize);
% tNew=t1;
% icNew=ic1;
% for i=1:numel(cutOut)
%     [tNew,icNew]=RemoveSections(t1,ic1,bsNew(cutOut(i)),beNew(cutOut(i)));
% end
% bsNew = bsNew(idx);
% beNew = beNew(idx);
% bwNew = bwNew(idx);
end
