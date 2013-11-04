function CID=ClusterBurstsKmeans3(m)
% Function which recieves burst propogation matrix (mxm x number of bursts)
%% Normalize Propoagation Matrix to Zero-mean
for idx=1:size(m,3)
    temp=m(:,:,idx);
    temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
    m(:,:,idx)=temp;
end
m1=m;
m(isnan(m))=0;
%% Calc Similarity Matrix
%------Run K-means on Similarity Matrix-------%
% cmat=CalcCorr(m);
% cmat(cmat<0)=0;
%------Run K-means Directly on Bursts---------%
cmat = reshape(m,[(size(m,1)*size(m,2)),size(m,3)]);


%% Test Cell
% [fun,ans,CID,fval,options] = pca(cmat) %,'algorithm','als');
% X = real(fun(:,1:2));
% % scatter(X(:,1),X(:,2))
% % options = statset('Display','final');
% gm = gmdistribution.fit(X,2);
% % hold on
% % ezcontour(@(x,y)pdf(gm,[x y]),[-8 6],[-8 6]);
% % hold off
% idx = cluster(gm,X);
% cluster1 = (idx == 1);
% cluster2 = (idx == 2);
% 
% scatter(X(cluster1,1),X(cluster1,2),10,'r+');
% hold on
% scatter(X(cluster2,1),X(cluster2,2),10,'bo');
% hold off
% legend('Cluster 1','Cluster 2','Location','NW')

%---------------------------------------------%
%% Partition data into clusters
options = gaoptimset('Generations',200,'UseParallel','always');
rng(1,'twister');

%-----------Cluster Alg1------------%
% fun = @(x)KmeansClust(cmat,m,1,x);
%-----------Cluster Alg2------------%
fun = @(x)KmeansClust2(cmat',m1,1,x);
%---Search for Optimal # of Clusters---%
[MinCost,fval]=ga(fun,1,[],[],[],[],2,round(0.5*size(cmat,2)),[],1,options);
%-----------Cluster Alg1------------%
% CID = KmeansClust(cmat,m,0,MinCost);
%-----------Cluster Alg2------------%
CID = KmeansClust2(cmat',m1,0,MinCost);
%% Nested Functions
    function corr = nancorr2(a,b) %Calculates correlation between two items
        a = a - nanmean(a(:));
        b = b - nanmean(b(:));
        a(isnan(a))=0;
        b(isnan(b))=0;
        corr = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
    end

    function mat=CalcCorr(m) % Applies nancorr2 between every pair of bursts, creates an ajacency matrix
        combs = VChooseK(1:size(m,3),2);
        
        for q=1:size(combs,1)
            I1 = squeeze(m(:,:,combs(q,1)));
            I2 = squeeze(m(:,:,combs(q,2)));
            cor = nancorr2(I1,I2);
            corr(q)=cor;
        end
%         mat= corr;
        mat = zeros(size(m,3),size(m,3));
        for q=1:size(combs,1)
            mat(combs(q,1),combs(q,2))=corr(q);
        end
%         mat = mat + mat'+eye(size(mat));
    end

end