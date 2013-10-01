function diffs  = PlotSequentialBurstGroups(BurstData,ClusterIDs)

subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.02], [0.05 0.05], [0.01 0.01]);
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
    [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
    [culTypes{3} '(1)'] [culTypes{3} '(2)']...
    [culTypes{4} '(1)'] [culTypes{4} '(2)'] [culTypes{4} '(3)'] [culTypes{4} '(4)']};


for i=1:max(BurstData.cultId)
    subplot(4,4,i);
    prepost=BurstData.prepost(BurstData.cultId==i);
    clustPre=ClusterIDs{i}(prepost==0);
    clustPost=ClusterIDs{i}(prepost==1);
    numclust = max([clustPre;clustPost]);
    [numPre]=histc(clustPre,1:numclust);
    numPre=numPre./sum(numPre);
    [numPost]=histc(clustPost,1:numclust);
    numPost=numPost./sum(numPost);
    [diffs(:,i),ix] = sort(numPost-numPre);
    row=zeros(max(unique([clustPre;clustPost])),length(clustPre)+length(clustPost));
    for idx=1:numel(unique([clustPre;clustPost]))
        k=ix(idx);
        row(idx,1:length(clustPre)) = (clustPre==k);
        row(idx,length(clustPre)+1:end) = (clustPost==k)*2;
    end
    row(find(row==0))=nan;
    imagescnan(row,'nancolor',[1,1,1]);
    set(gca,'XTick',[],'YTick',1:numclust);
%     ylabel('Burst Clusters');
%     xlabel('Burst Number');
    box off;
    axis tight;
    title(cultLabels{i});
    freezeColors;
    clear row;
end

end
