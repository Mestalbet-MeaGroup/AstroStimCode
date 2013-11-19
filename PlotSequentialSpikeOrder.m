function h = PlotSequentialSpikeOrder(MeaMap,SpikeOrders,StimSite);

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
if ~isempty(StimSite)
    img(end+1:end+5,:)=ones(5,size(img,2)).*Z1(find(MeaMap==StimSite));
end
[X,Y] = meshgrid(1:1:size(img,1),1:1:size(img,2));
figure;
if (size(img,1)>1)&&(size(img,2)>1)
%     h = pcolor(X,Y,img');
   h = imagesc(img');
    shading flat;
    set(gcf,'ColorMap',cmap);
    set(gca,'YDir','reverse','PlotBoxAspectRatio',[size(img,2) size(img,1) 1]);
else
    h=pcolor(zeros(16,16));
end
end

