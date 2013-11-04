function [BurstVec,dists] = CalcBurstPropVec(bursts)
%Function to calculate the vector of propogation of a burst.
numBursts = size(bursts,3);
f = fspecial('gaussian',[16 16],3);
BurstVec=[];
dists=[];
for i=1:numBursts
    bs = bursts(:,:,i);
    be = bursts(:,:,i);
    %     begElecs = (sum(bs(:)>0))*0.2;
    %     endElecs = (sum(bs(:)>0))-(sum(bs(:)>0))*0.1;
    begElecs = 10;
    endElecs = max(be(:))-5;
    bs = (bs<begElecs)&(bs>0);
    be = (be>endElecs)&(be>0);
    bs = filter2(fliplr(bs),f,'same');
    bs = otsu(bs,4);
    be = filter2(fliplr(be),f,'same');
    be = otsu(be,4);
    CMs = regionprops(bs>3,'Centroid');
    CMe = regionprops(be>3,'Centroid');
    if size(CMe,1)>1
        CMe(1).Centroid = [(CMe(1).Centroid(1)+CMe(2).Centroid(1))/2,(CMe(1).Centroid(2)+CMe(2).Centroid(2))/2];
    end
    if isempty(CMs)||isempty(CMe)
        BurstVec(i,1:4)=nan(4,1);
    else
        BurstVec(i,:)=[CMs(1).Centroid,CMe(1).Centroid];
    end
end
BurstVec(find(isnan(BurstVec)))=[];
if size(BurstVec,1)>3
    x=BurstVec(:,1);
    y=BurstVec(:,2);
    DT = delaunay(x,y);
    dists=DT;
    %     dists=[];
    %     for j=1:size(DT,1)
    %         A(:,1)= [x(DT(j,1));y(DT(j,1))];
    %         A(:,2)= [x(DT(j,2));y(DT(j,2))];
    %         A(:,3)= [x(DT(j,3));y(DT(j,3))];
    %         dists=[dists; pdist(A')];
    %     end
end
end