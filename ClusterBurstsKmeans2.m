function [CID1,mat,r]=ClusterBurstsKmeans2(m)

% Normalize Propoagation Matrix
for idx=1:size(m,3)
    temp=m(:,:,idx);
    temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
    m(:,:,idx)=temp;
end
%% Calc Similarity Matrix
cmat=CalcCorr(m);

%% Partition data into clusters
[CID,mat,r,ins,outs] = KmeansClust(cmat);

%% Plot Clusters before second pass
% subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.02], [0.05 0.05], [0.01 0.01]);
% f1 = figure('name','Clusters Before Merge');
% numClust=max(CID);
% for ii=1:numClust
%     subplot(ceil(numClust/3),ceil(numClust/2),ii)
%     imagescnan(nanmean(m(:,:,CID==ii),3));
%     title(num2str(ii));
% end
% 

%% Merge clusters which correlate more than 70%
numClust = max(CID);
if numClust >1
    for k=1:numClust
        temp=nanmean(m(:,:,CID==k),3);
        temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
        newMat(:,:,k) = temp;
    end
else
    CID1=CID;
    return;
end
% [CID2,mat2,r2,ins2,outs2] = KmeansClust(newMat);
corrMat=CalcNewCorr(newMat);
corrMat(corrMat<0)=0;
[a,~]=find(corrMat(:,3)>0.7);
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

%% Plot Merged Clusters
% f2 = figure('name','Clusters After Merge');
% numClust=max(CID1);
% if numClust>3
%     for ii=1:numClust
%         subplot(ceil(numClust/3),ceil(numClust/2),ii)
%         imagescnan(nanmean(m(:,:,CID1==ii),3));
%         title(num2str(ii));
%     end
% else
%     for ii=1:numClust
%         subplot(ceil(numClust),1,ii)
%         imagescnan(nanmean(m(:,:,CID1==ii),3));
%         title(num2str(ii));
%     end
% end
%% Nested Functions
    function corr = nancorr2(a,b)
        a = a - nanmean(a(:));
        b = b - nanmean(b(:));
        a(isnan(a))=0;
        b(isnan(b))=0;
        corr = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
    end

    function [CID,mat,r,ins,outs] = KmeansClust(mat)  %Fix here
        r(1)=0;
        for i=2:size(mat,2)-1
            [CID,~,ins,outs] = kmeans(mat,i,'distance','cityblock','emptyaction','drop');               
            in=mean(ins);
            vec=1:size(outs,2);
            vec(vec==i)=[];
            for j=1:numel(vec)
                tt(j)=sum(outs(CID==i,vec(j)));
            end
            out=min(tt);
            r(i)=in/out;
        end
        [r,ix]=max(r);
        [CID,~,ins,outs] = kmeans(mat,ix,'distance','cityblock','emptyaction','drop'); 
    end

    function mat=CalcCorr(m)
        combs = VChooseK(1:size(m,3),2);
        
        for q=1:size(combs,1)
            I1 = squeeze(m(:,:,combs(q,1)));
            I2 = squeeze(m(:,:,combs(q,2)));
            cor = nancorr2(I1,I2);
            corr(q)=cor;
        end
        
        mat = zeros(size(m,3),size(m,3));
        for q=1:size(combs,1)
            mat(combs(q,1),combs(q,2))=corr(q);
        end
    end

    function combs=CalcNewCorr(m)
        combs = VChooseK(1:size(m,3),2);
        
        for q=1:size(combs,1)
            I1 = squeeze(m(:,:,combs(q,1)));
            I2 = squeeze(m(:,:,combs(q,2)));
            cor = nancorr2(I1,I2);
            combs(q,3)=cor;
        end
    end
end