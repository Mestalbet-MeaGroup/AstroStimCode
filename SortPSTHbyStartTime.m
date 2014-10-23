[PairWisePSTH,PairWiseLags]=CalcPSTHastrotriggers(t,ic,traces,time,bs,be);
clusters = kmeans(PairWisePSTH',5);
[~,ix]=max([sum(clusters==1),sum(clusters==2),sum(clusters==3),sum(clusters==4),sum(clusters==5)]);
clusters(clusters~=ix)=0;
clusters(clusters==ix)=1;
[sIDX,eIDX]=initfin(~clusters');
for i=1:numel(sIDX)
    sc(i) = nansum(nansum(PairWisePSTH(:,sIDX(1):eIDX(1)),2));
end
sc(PairWiseLags(sIDX-1)<0)=nan;
[~,w]=nanmax(sc);
we = find(diff(eIDX(w:end))<5,1,'last')+w;
p = PairWisePSTH(:,sIDX(w)-2:sIDX(w)+10);
