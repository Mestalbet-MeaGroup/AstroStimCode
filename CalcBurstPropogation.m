function m=CalcBurstPropogation(t,ic,bs,be,MeaMap);

Nbursts=numel(bs);
m = nan(size(MeaMap,1),size(MeaMap,2),Nbursts);

ic = ConvertIC2Samora(ic);
[t,ix]=sort(t);
ic=ic(ix);

for j=1:Nbursts
    a=find(t>=bs(j) & t<=be(j));
    ChannelOrder=unique(ic(a),'stable');
    for i=1:size(ChannelOrder,2)
        [x,y]=find(MeaMap==ChannelOrder(i),1,'First');
        if ~isempty(x)
            m(x,y,j)=i;
        end
    end
end

end