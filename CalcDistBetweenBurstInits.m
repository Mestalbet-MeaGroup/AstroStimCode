function Dist = CalcDistBetweenBurstInits(bursts)

burst=zeros(16,16); Dist=[];
numElec = 6; %Sets the number initial electrodes through which the burst initiation site is defined
f = fspecial('gaussian',[16 16],1);
Xcm=[];Ycm=[]; x=0; y=0;
for i=1:size(bursts,3)
    b = bursts(:,:,i);
    b(isnan(b))=0;
    b = (b<numElec)&(b>0);
    b = filter2(b',f,'same');
    test = regionprops((b>0.80*max(b(:))),'Centroid');
    %     display(size(test,1))
    %     for j=1:size(test,1)
    %         x = x+test(j).Centroid(1);
    %         y = y+test(j).Centroid(2);
    %     end
    %     Xcm = [Xcm; x/size(test,1)];
    %     Ycm = [Ycm; y/size(test,1)];
    Xcm(i)=test(1).Centroid(1);
    Ycm(i)=test(1).Centroid(2);
end

combs = VChooseK(1:numel(Xcm),2);

for j=1:size(combs,1)
    Dist(j)=sqrt( (Xcm(combs(j,1))-Xcm(combs(j,2)))^2 + (Ycm(combs(j,1))-Ycm(combs(j,2)))^2 );
end

end

