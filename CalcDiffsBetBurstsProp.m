function [mat,list]=CalcDiffsBetBurstsProp(m)
% Function which recieves a matrix of size (m*m)*NumBursts representing
% burst propogation and calculates the absolute element wise difference between each pair.
combs = VChooseK(1:size(m,3),2);

for q=1:size(combs,1)
    a = squeeze(m(:,:,combs(q,1)));
    b = squeeze(m(:,:,combs(q,2)));
    a = a - nanmean(a(:));
    b = b - nanmean(b(:));
    temp=abs(a-b);
    numnan(q)=sum(isnan(temp(:)));
    a(isnan(a))=0;
    b(isnan(b))=0;
    temp=abs(a-b);
    diffs(q)=sum(temp(:));
end
list = [combs,diffs',numnan'];
mat = zeros(size(m,3),size(m,3));
for q=1:size(combs,1)
    mat(combs(q,1),combs(q,2))=diffs(q);
end
end