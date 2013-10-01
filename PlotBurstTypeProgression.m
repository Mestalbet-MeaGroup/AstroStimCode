vals=1:9;
for i=1:max(BurstData.cultId)
    clustPre  = BurstData.ClusterIDs((BurstData.cultId==i)&(BurstData.prepost==0));
    clustPost  = BurstData.ClusterIDs((BurstData.cultId==i)&(BurstData.prepost==1));
    [~,clustPre]=ismember(clustPre,vals);
    [~,clustPost]=ismember(clustPost,vals);
    if i==4
        vals = sort(unique([clustPre;clustPost]));
        plot(clustPre,'.');
        hold on;plot(length(clustPre):length(clustPre)+length(clustPost)-1,clustPost,'.r');
        hold off;
        vals=1:9;
    end
    [numPre]=histc(clustPre,1:length(vals));
    numPre=numPre./sum(numPre);
    [numPost]=histc(clustPost,1:length(vals));
    numPost=numPost./sum(numPost);
    diffs(:,i) = numPost-numPre;
end
figure;
cmap = cbrewer('qual', 'Set1', max(BurstData.ClusterIDs));
% vec=[1:9];
% diffs=diffs(vec,:);
bars = bar(diffs','grouped');

for j=1:length(bars)
set(bars(j),'FaceColor',cmap(j,:));
end