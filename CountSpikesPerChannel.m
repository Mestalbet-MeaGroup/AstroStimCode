function numspikes = CountSpikesPerChannel(t,ic,bs,be);
% Calculates the percentage of maximum firing for each channel for each burst and takes the mean across bursts. 
numspikes=[];
for i=1:numel(bs)
[t1,ic1] = CutSortChannel2(t,ic,bs(i),be(i));
for j=1:size(ic1,2)
    numspikes(i,j)=numel(t1(ic1(3,j):ic1(4,j)));
end
end
% maxnum = max(numspikes,[],1);
maxnum = nanmean(numspikes,1);
for i=1:size(numspikes,2)
    numspikes(:,i)=numspikes(:,i)./maxnum(i);
end
numspikes=mean(numspikes,2);
end