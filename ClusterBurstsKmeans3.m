function CID=ClusterBurstsKmeans3(m)

% Normalize Propoagation Matrix
for idx=1:size(m,3)
    temp=m(:,:,idx);
    temp = (temp - min(temp(:)))./(max(temp(:))-min(temp(:)));
    m(:,:,idx)=temp;
end
%% Calc Similarity Matrix
cmat=CalcCorr(m);
cmat(cmat<0)=0;
% test = KmeansClust(cmat,m,5);

% [CID,score] = KmeansClust(cmat,m);
%% Partition data into clusters
% options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter');
rng(1,'twister');
fun = @(x)KmeansClust(cmat,m,1,x);
[MinCost,fval]=ga(fun,1,[],[],[],[],2,50,[],1);
CID = KmeansClust(cmat,m,0,MinCost);

%% Nested Functions
    function corr = nancorr2(a,b)
        a = a - nanmean(a(:));
        b = b - nanmean(b(:));
        a(isnan(a))=0;
        b(isnan(b))=0;
        corr = sum(sum(a.*b))/sqrt(sum(sum(a.*a))*sum(sum(b.*b)));
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

end