function HAelec = FindHAelectrodesNoThresh(t,ic,bs,be);

HAelec=[]; test=[];
for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)));
    inB=0;
    for j=1:numel(bs)
        inB = inB+sum(t1>bs(j) & t1<be(j));
    end
    outB  =  numel(t1)-inB;
    if outB/inB>1
        HAelec = [HAelec;ic(1,i)];
%         outliers = bsxfun(@gt, diff(t1), median( diff(t1)));
%         test = [test;sum(outliers)/numel(outliers)];
    end
end
% HAelec = HAelec(test<0.499); %changed from 0.475
end