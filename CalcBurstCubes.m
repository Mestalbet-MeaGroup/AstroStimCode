function m = CalcBurstCubes(t,ic,bs,be,MeaMap)
% matObj = matfile('myBigData.mat','Writable',true);
% bin = 100;
% m(1:size(MeaMap,1),1:size(MeaMap,2),1:ceil(max(t(ic(4,:))-t(ic(3,:)))/bin),1:length(bs))=0;
for i=1:length(bs)
    [t1,ic1{i}] = CutSortChannel2(t,ic,bs(i),be(i));
    t1=t1-min(t1)+1;
    [fr{i},~]=FindNeuronFrequency(t1,ic1{i},0.5,1);
    maxfr(i)=size(fr{i},2);
end
maxfr=max(maxfr);
% maxfr=2000;
m=zeros(size(MeaMap,1),size(MeaMap,2),maxfr,length(bs),'single');
for i=1:size(ic1,2)
    ic1b=ic1{i};
    fra=fr{i};
    for j=1:size(ic1b,2)
        [x,y]=find(MeaMap==ic1b(1,j),1,'First');
        m(x,y,1:size(fra,2),i)=fra(j,:);
    end
end
test=squeeze(sum(m,4));
test=sum(sum(test));
test=squeeze(test);
test=test>0;
[a,~]=initfin(test');
a=a(end);
m=m(:,:,1:a,:);
end

