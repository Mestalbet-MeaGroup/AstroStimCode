function HAelec = FindHAelectrodes(t,ic,bs,be);

HAelec=[];
for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)));
    inB=0;
    for j=1:numel(bs)
        inB = inB+sum(t1>bs(j) & t1<be(j));
    end
    outB  =  numel(t1)-inB;
    if outB/inB>1
        HAelec = [HAelec;ic(1,i)];
    end
end


