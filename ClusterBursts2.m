function [ClusterIDs,mat] = ClusterBursts2(m,numtypes)
combs = VChooseK(1:size(m,3),2);
% m(isnan(m))=0;
% h = waitbarwithtime(0,'Calculating...');
for q=1:size(combs,1)
    I1 = squeeze(m(:,:,combs(q,1)));
    I2 = squeeze(m(:,:,combs(q,2)));
    I1(isnan(I1))=0;
    I2(isnan(I2))=0;
    cor = corr2(I1,I2);
    corr(q)=cor;
    %     waitbarwithtime(q/size(combs,1),h);
end
mat = zeros(size(m,3),size(m,3));
for q=1:size(combs,1)
        mat(combs(q,1),combs(q,2))=corr(q);
%     mat(q) = corr(q);
end
mat = mat + mat'+eye(size(mat));
test=pdist(mat);
tree=linkage(test,'average');
% leafOrder = optimalleaforder(tree,test);
% figure;
% [~,~,~] = dendrogram(tree,size(mat,1),'Reorder',leafOrder);
% hold on;
% index = 1:numel(get(gca,'XTick'));
% line(index,ones(length(index),1).*(0.7*max(tree(:,3))),'color','r');
% [~,thresh] = ginput(1);
% thresh = 0.7*max(tree(:,3));
ClusterIDs  = cluster(tree,'MaxClust',numtypes,'Criterion','distance');
end

