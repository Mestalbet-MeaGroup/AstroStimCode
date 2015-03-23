function [PropMat,PropMatS]=CalcBurstProp(SpikeOrders,bursts,MeaMap)
% function which takes spikeorders for burst matrices and returns a 16x16
% burst propogation map

G = fspecial('gaussian',[16 16],0.1);

for j=1:size(bursts,3)
    b = bursts(:,:,j);
    [~,PropMat(:,:,j)]=ismember(MeaMap,SpikeOrders(:,j));
    PropMatS(:,:,j) = convn(PropMat(:,:,j),G,'same');
end
end