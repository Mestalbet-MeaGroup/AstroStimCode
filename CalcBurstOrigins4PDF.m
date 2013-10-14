function bursts = CalcBurstOrigins4PDF(bursts)
burst=zeros(16,16);
numElec = 6; %Sets the number initial electrodes through which the burst initiation site is defined
f = fspecial('gaussian',[16 16],1);
for i=1:size(bursts,3)
    b = bursts(:,:,i);
    b(isnan(b))=0;
    burst=burst+((b<numElec)&(b>0));
%     burst = (burst<6);
%     bursts(:,:,i) = filter2(burst',f,'same');
end
% bursts=burst;
% bursts = filter2(burst'./(5*size(bursts,3)),f,'same');
% bursts = filter2(burst'./max(burst(:)),f,'same');
% bursts = (bursts-min(bursts(:)))/(max(bursts(:))-min(bursts(:)));
% bursts = mean(bursts,3);
% temp=burst'./size(bursts,3);
% temp=sum(temp(:));
% bursts = burst'./(temp*size(bursts,3)); %This forces the matrix to sum to 1. I am not sure if that is the correct thing
bursts = filter2(burst',f,'same');
bursts=bursts./(sum(bursts(:)));
end