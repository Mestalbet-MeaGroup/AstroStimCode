function mat=CalcCorrBetBurstsProp(m)
% Function which recieves a matrix of size (m*m)*NumBursts representing
% burst propogation and calculates the correlation between each pair.
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