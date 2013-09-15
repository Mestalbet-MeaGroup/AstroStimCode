[rankb,ranks,h,meanB,meanS,groupExpb,groupExps] = CalcRankinBurstsStimSit(DataSetBase,DataSetStims);
colors = jet(7);
hold on;
for i=1:7
h1 = notBoxPlot(rankb(groupExpb==i),ones(sum(groupExpb==i),1),[],'sdline');
d=[h1.data];
set(d(1:end),'markerfacecolor',colors(i,:),'color',colors(i,:),'markeredgecolor','none');
% 
meansb(i) = mean(rankb(groupExpb==i));
end

for i=1:7
h1 = notBoxPlot(ranks(groupExps==i),ones(sum(groupExps==i),1).*2,[],'sdline');
d=[h1.data];
set(d(1:end),'markerfacecolor',colors(i,:),'color',colors(i,:),'markeredgecolor','none');
meanss(i) = mean(ranks(groupExps==i));
end

T = get(gca,'Children');
Ttype = get(T,'Type');
locsP = find(strcmp(Ttype,'patch'));
vec=[1:7,1:7];
for i=1:length(locsP)
set(T(locsP(i)),'FaceColor',colors(vec(i),:),'FaceAlpha',0.5);
end
locs=find(strcmp(Ttype,'line'));
set(T(locs(2:2:end)),'color','k');

for i=1:7
    meansb(i) = mean(rankb(groupExpb==i));%-median(rankb(groupExpb==i));
    meanss(i) = mean(ranks(groupExps==i));%-median(ranks(groupExps==i));
end
bar(abs([meansb;meanss]'),'grouped');