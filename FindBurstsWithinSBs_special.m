function [bs,be] = FindBurstsWithinSBs_special(t,ic,sbs,sbe,k,kk,rec,dpass)

[t,ic] = CutSortChannel2(t,ic,sbs,sbe);
tfull=t;
icfull=ic;
[firings,~]=FindNeuronFrequency(t,ic,25,1);
Corr=nan(size(firings,1),size(firings,1));
for i=1:size(firings,1)
    for j=i:size(firings,1)-1
        Corr(i,j)=NormalizedCorrelation(firings(i,:),firings(j,:));
    end
end

% thr = nanmean(Corr(:))+nanvar(Corr(:));
test = nanmean(Corr,2);
thr = quantile(test,10);
thr=thr(6);
[remove,~]=find(test<thr);

ictemp=ic;
for i=1:numel(remove)
    [t,ic]=removeNeuronsWithoutPrompt(t,ic,[ictemp(1,remove(i));1]);
end
[bs,be,~]=CalcBurstsSamora(t,ic);
if bs(1)<0
    bs(1)=1;
end
% [bs,be] = FindBurstsWithinSBs(t,ic,sbs,sbe,k,kk,rec);
%------Remove implausibly short bursts-----%
bw=(be-bs);
bs(bw./1200<=1)=[];
be(bw./1200<=1)=[];

%------Remove bursts with fewer than 100 spikes-----%
spikecheck=[];
for i=1:numel(bs)
    temp=histc(sort(tfull),[bs(i),be(i)]);
    spikecheck(i) = temp(1) > 100;
end
if ~isempty(spikecheck)
    bs1 = bs(spikecheck==1)+sbs;
    be1 = be(spikecheck==1)+sbs;
else
    bs1=bs+sbs;
    be1=be+sbs;
end
bs=bs1;
be=be1;
%-----Run Second Pass----%
if dpass>0 %Run a second pass
    for i=1:numel(bs)
        [t,ic]=RemoveSections(t,ic,bs(i)-sbs,be(i)-sbs);
    end
    [bs1,be1,~]=CalcBurstsSamora(t,ic);
    bs=[bs,(bs1+sbs)];
    be=[be,(be1+sbs)];
end

bs=sort(bs);
be=sort(be);
if bs(1)<sbs
    bs(1)=sbs+1;
end
%------Remove bursts with fewer than 100 spikes from second pass-----%
spikecheck=[];
for i=1:numel(bs)
    temp=histc(sort(tfull),[bs(i)-sbs,be(i)-sbs]);
    spikecheck(i) = temp(1) > 100;
end
if ~isempty(spikecheck)
    bs1 = bs(spikecheck==1);
    be1 = be(spikecheck==1);
else
    bs1=bs;
    be1=be;
end
bs=bs1;
be=be1;
%------Remove implausibly short bursts from second pass-----%
bw=(be-bs);
bs(bw./1200<=1)=[];
be(bw./1200<=1)=[];
%-----------Save Burst detection proof------%
% t=tfull;
% ic=icfull;
% figure('visible','off')
% hold on;
% [spks,time] = MakeRaster(t+1,ic,1,round(max(t))+2000);
% plot(time,spks,'k');
% for i=1:numel(bs)
%     
%     b=round(bs(i)-sbs);
%     e=round(be(i)-sbs);
%     %     display(i);
%     %     display(b);
%     %     display(e);
%     %
%     line([time(b*2),time(b*2)],[0,size(ic,2)*2],'Color','b');
%     line([time(e*2),time(e*2)],[0,size(ic,2)*2],'Color','r');
% end
% axis tight;
% saveas(gcf,['BurstDetection',num2str(k),'_',num2str(kk),'_',rec,'.png']);
% close all;
end

