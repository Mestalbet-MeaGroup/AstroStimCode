function [x,y] = FindNeighboringElectrodes(MeaMap,StimSite,k)

[i,j] = find(MeaMap==StimSite(k));
A = zeros(size(MeaMap));
A(i,j)=1;
[i1,j1] = find(A);
[y x] = ndgrid(1:size(A,1),1:size(A,2));
out = min(hypot(bsxfun(@minus,y,permute(i1,[3 2 1])),bsxfun(@minus,x,permute(j1,[3 2 1]))),[],3);
[x,y]=find(out<1.5);

end