function [cost] = KmeansClust(mat,bursts,costorCID,ix)
% display(size(mat));
% display(ix);
try
    [CID,~,ins,outs] = kmeans(mat,ix,'distance','cityblock','emptyaction','drop');
catch
    cost=Inf;
    return;
end
if costorCID==1
    numClust = max(CID);
    in=mean(ins);
    for j=1:size(outs,2)
        vec=1:size(outs,2);
        vec(vec==j)=[];
        temp=outs(CID==j,vec);
        tt(j)=min(sum(temp,1));
    end
    out=min(tt);
    r=out/in;
    
    if numClust >1
        for k=1:numClust
            temp=nanvar(bursts(:,:,CID==k),0,3);
            newMat(k) = max(temp(:));
        end
        corr=mean(newMat);
        
        %         for k=1:numClust
        %             temp=nanmean(bursts(:,:,CID==k),3);
        %             temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
        %             newMat(:,:,k) = temp;
        %         end
        %     end
        % %     [~,list]=CalcDiffsBetBurstsProp(burstType);
        % %     corr=1./min(list(:,3));
        %     corr=CalcNewCorr(newMat);
%         display(corr);  display(r); display(numClust^(1/3));
        cost=corr+r+numClust^(1/3);
    else
        cost=r+numClust^(1/3)+1;
    end
else
    numClust = max(CID);
    if numClust >1
        for k=1:numClust
            temp=nanmean(bursts(:,:,CID==k),3);
            temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
            newMat(:,:,k) = temp;
        end
    else
        CID1=CID;
        return;
    end
    corrMat=CalcNewCorr2(newMat);
    corrMat(corrMat<0)=0;
    [a,~]=find(corrMat(:,3)>0.8);
    CID1=CID;
    merge=corrMat(a,1:2);
    merge=merge(~(ismember(merge(:,1),merge(:,2))),:);
    for kkk=1:size(merge,1)
        CID1( (CID==merge(kkk,1))|(CID==merge(kkk,2)) ) = merge(kkk,1)+100;
    end
    newIds=unique(CID1);
    for r=1:numel(newIds)
        CID1(CID1==newIds(r))=r;
    end
    cost=CID1;
end
    function corr = nancorr2(a,b)
        a = a - nanmean(a(:));
        b = b - nanmean(b(:));
        a(isnan(a))=0;
        b(isnan(b))=0;
        corr = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
    end

    function cor=CalcNewCorr(m)
        combs = VChooseK(1:size(m,3),2);
        
        for q=1:size(combs,1)
            I1 = squeeze(m(:,:,combs(q,1)));
            I2 = squeeze(m(:,:,combs(q,2)));
            cor = nancorr2(I1,I2);
            combs(q,3)=cor;
        end
        cor=mean(combs(:,3));
    end

    function combs=CalcNewCorr2(m)
        combs = VChooseK(1:size(m,3),2);
        
        for q=1:size(combs,1)
            I1 = squeeze(m(:,:,combs(q,1)));
            I2 = squeeze(m(:,:,combs(q,2)));
            cor = nancorr2(I1,I2);
            combs(q,3)=cor;
        end
    end
end