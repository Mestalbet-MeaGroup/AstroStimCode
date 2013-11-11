function result = CalcWithinBurstCorr(t,ic,bs,be)
corrmat = nan(size(ic,2),size(ic,2),numel(bs));
for i=1:numel(bs)
    [t1,ic1]=CutSortChannel(t,ic,bs(i),be(i));
    
    t1 = t1 - min(t1)+1;
    index=[];
    m = zeros(round(max(t1(~isnan(t1)))),size(ic1,2));
    for j=1:size(ic,2)
        index = t1(ic1(3,j):ic1(4,j));
        index(isnan(index))=[];
%         [x(j),y(j)]=find(MeaMap==ic1(1,j),1,'First');
        if ~isempty(index)
            index=round(index);
            m(index,j)=1;
        end
    end
    if ~isempty(m)
    corrmat(:,:,i) = corr(logical(m));
    else
        corrmat(:,:,i) = nan(size(corrmat,1),size(corrmat,2));
    end
end
ans = diff(corrmat,1,3);
result = squeeze(nanmean(nanmean(ans,1),2));
end