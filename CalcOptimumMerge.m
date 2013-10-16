function ix = CalcOptimumMerge(clustMat)

numClust=size(clustMat,3);
numMerges=ceil(numClust*0.1);
sizes=0;
for i=2:numMerges
    sizes(i) = prod(numClust-(0:i-1))/factorial(i);
end
totalSize =sum(sizes);
combs=nan(totalSize,numMerges);

for i=2:ceil(numClust*0.1)
    temp = VChooseK(1:numClust,i);
    combs((1+sum(sizes(1:(i-1)))):sum(sizes(1:(i))),1:i)=temp;
end

for i=1:size(combs,1)
    corrMat = MergeMe(clustMat,combs(i,1:4));
    combs(i,5)=CalcMeanCorr(corrMat);
end

    function cor=CalcMeanCorr(m)
        cc = VChooseK(1:size(m,3),2);
        for q=1:size(cc,1)
            I1 = squeeze(m(:,:,cc(q,1)));
            I2 = squeeze(m(:,:,cc(q,2)));
            cor(q) = nancorr2(I1,I2);
        end
        cor=nanmean(cor);
    end

    function merged=MergeMe(mat,which)
        CID1=CID;
        merge=mat(which,1:2);
        merge=merge(~(ismember(merge(:,1),merge(:,2))),:);
        for kkk=1:size(merge,1)
            CID1( (CID==merge(kkk,1))|(CID==merge(kkk,2)) ) = merge(kkk,1)+100;
        end
        newIds=unique(CID1);
        for r=1:numel(newIds)
            CID1(CID1==newIds(r))=r;
        end
    end
end