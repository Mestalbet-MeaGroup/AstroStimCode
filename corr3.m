function corr = corr3(mat1,mat2)
cmat1 = bsxfun(@minus,mat1,mean(mat1(:)));
cmat2 = bsxfun(@minus,mat2,mean(mat2(:)));
if size(cmat1,3)>size(cmat2,3)
    cmat2 = padarray(cmat2,[0 0 size(cmat1,3)-size(cmat2,3)],'post');
elseif size(cmat1,3)<size(cmat2,3)
    cmat1 = padarray(cmat2,[0 0 size(cmat2,3)-size(cmat1,3)],'post');
end
dp = cmat1.*cmat2;
corr = sum(dp(:),'double')/( sum(cmat1(:),'double')*sum(cmat2(:),'double'));
end