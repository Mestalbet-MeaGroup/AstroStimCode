function [bs,be] = FindBurstsWithinSBs(t,ic,sbs,sbe,k,kk,rec,dpass)
[t,ic] = CutSortChannel2(t,ic,sbs,sbe);
tfull=t;
icfull=ic;
fr=histc(sort(t),min(t):100:max(t)+1000);
fr = filtfilt(MakeGaussian(0,3,5),1,fr);
[bs,be]=CalcOnOffsets(fr);
% [bs,be]=initfin( (fr>0)|([0,0,diff(diff(fr))]>0));
bs=bs*100+min(t)-100;
be=be*100+min(t)-100;
%------Remove implausibly short bursts-----%
bs((be-bs)./1200<=1)=[];
be((be-bs)./1200<=1)=[];

%------Remove bursts with fewer than 100 spikes-----%
for i=1:numel(bs)
    temp=histc(sort(t),[bs(i),be(i)]);
    spikecheck(i) = temp(1) > 100;
end

%------Set proper time------%
bs = bs(spikecheck==1)+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs
be = be(spikecheck==1)+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs

%----Remove Double Detection-----%
test = diff(be);
test  = ismember(test,0);
be(find(test==1)+1)=[];
bs(find(test==1)+1)=[];

test = diff(bs);
test  = ismember(test,0);
be(find(test==1))=[];
bs(find(test==1))=[];
%-----Verify That Wide Bursts Aren't Two Bursts------%
bw = be-bs;
test = find(bw>1.5*mean(bw));
bsTemp=bs;
beTemp=be;
bsTemp(test)=[];
beTemp(test)=[];
for i=1:numel(test)
    [t1,ic1] = CutSortChannel2(t,ic,bs(test(i))-10-sbs,be(test(i))+10-sbs);
    for ij=1:size(ic1,2)
        fr2(ij,:)=histc(t1(ic1(3,ij):ic1(4,ij)),min(t1):500:max(t1));
    end
    fr3=sum(fr2>0,1);
    fr3=padarray(fr3,[0,2]);
    mins=find(fr3<3);
    counter=1;
    [~,locs] = findpeaks(fr3,'MINPEAKHEIGHT',0.6*max(fr3),'MINPEAKDISTANCE',5);
    if (~isempty(mins))&&(~isempty(locs))
        for q=1:numel(locs)
            for r=2:numel(mins)
                if (locs(q)<mins(r)) && (locs(q)>mins(r-1))
                    bs1(counter)=mins(r-1);
                    be1(counter)=mins(r);
                    counter=counter+1;
                end
            end
        end
        bs1=unique(bs1);
        be1=unique(be1);
        bs1(bs1==0)=[];
        be1(be1==0)=[];
        bsTemp=[bsTemp,bs1*500+bs(test(i))-500];
        beTemp=[beTemp,be1*500+bs(test(i))-500];
        mins=[];
        locs=[];
        fr2=[];
        fr3=[];
        be1=[];
        bs1=[];
    end
end

bs=sort(bsTemp);
be=sort(beTemp);
if sum((bs-sbs)<0)>2
    error('');
else
    bs((bs-sbs)<0)=sbs+500;
end
if bs(1)<0
    bs(1)=1;
end
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
% 
% figure('visible','off')
% hold on;
% [spks,time] = MakeRaster(tfull+1,icfull,1,round(max(t))+2000);
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

