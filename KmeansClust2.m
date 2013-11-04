function cost = KmeansClust2(mat,bursts,costorCID,ix)
%Function which returns either the cost given a certain number of guessed
%clusters (ix) or the clustering of the bursts (CID) using kmeans
numClust = nan;
iter=1;

while (numClust~=ix)&&(iter<200) % Kmeans has a random seed so sometimes the number of clusters does not equal the number I requested. 
    [CID,~,ins,outs] = kmeans(mat,ix,'distance','correlation','emptyaction','drop');
    numClust=max(CID);
    iter=iter+1;
end

if costorCID==1 % Calculate cost
    numClust = max(CID);
    in=mean(ins);
    for j=1:size(outs,2)
        vec=1:size(outs,2);
        vec(vec==j)=[];
        temp=outs(CID==j,vec);
        tt(j)=min(sum(temp,1));
    end
    out=min(tt);
    r=out/in; %ratio of distances between clusters over mean, max distances to center of mass within clusters
    
    if (numClust >1) && (numClust<size(bursts,3))
        for k=1:numClust
            temp=nanvar(bursts(:,:,CID==k),0,3);
            newMat(k) = nanmean(temp(:));
        end
        corr=max(newMat);
%         display(numClust);
%         display(r); display(corr);
%         display(r); display(corr); display((numClust/3)^(1/4));
%         cost=corr+r+(numClust/3)^(1/4);
        cost=corr+r+2*numClust/round(0.5*size(mat,2));%+(numClust/3)^(1/4);
    else
        cost=r+numClust^(1/3)+1;
    end
else
cost = CID;        
end
    
end


