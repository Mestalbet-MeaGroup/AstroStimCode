function h = PlotSequentialSpikeOrder(MeaMap,SpikeOrders);

[cmap,Z1] = MeaColorMap;
close;

img=zeros(size(SpikeOrders));
for i=1:size(SpikeOrders,1)
    for j=1:size(SpikeOrders,2)
        [a,b]=find(MeaMap==SpikeOrders(i,j));
        if ~isempty(a)
            img(i,j) = Z1(a,b);
        end
    end
end

[X,Y] = meshgrid(1:1:size(img,1),1:1:size(img,2));
figure;
h = pcolor(X,Y,img'); 
shading flat;
% cmap = [[0,0,0];cmap];
set(gcf,'ColorMap',cmap);
set(gca,'YDir','reverse','PlotBoxAspectRatio',[size(img,2) size(img,1) 1]);
end

