function [m,clusters] = PlotBurstPropogation(t,ic,bs,be,MeaMap);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
% load('16x16MeaMap_90CW_Inverted.mat');
% load('MeaMapPlot.mat','MeaMap');
% MeaMap = rot90(MeaMap,-1);

Nbursts=numel(bs);
m = nan(size(MeaMap,1),size(MeaMap,2),Nbursts);

ic = ConvertIC2Samora(ic);
[t,ix]=sort(t);
ic=ic(ix);

for j=1:Nbursts
    a=find(t>=bs(j) & t<=be(j));
    ChannelOrder=unique(ic(a),'stable');
%     ChannelOrder=ic(a);
    
    %     cmap = createcolormap(MeaMap,'intensity',1,'invert',1,'N',numel(MeaMap)+1);
    for i=1:size(ChannelOrder,2)
        [x,y]=find(MeaMap==ChannelOrder(i),1,'First');
        cmap = colormap([[1 1 1];flipud(jet(numel(ChannelOrder)))]);
        if ~isempty(x)
            m(x,y,j)=i;
        end
    end
    if (sqrt(Nbursts)-floor(sqrt(Nbursts)))>0
        subplot(floor(sqrt(Nbursts)),floor(sqrt(Nbursts))+1,j);
        imshow(m(:,:,j),cmap);
        set(gca,'YDir','reverse','XDir','reverse');
        axis('off');
    else
        subplot(floor(sqrt(Nbursts)),floor(sqrt(Nbursts)),j);
        imshow(m(:,:,j),cmap);
        set(gca,'YDir','reverse','XDir','reverse');
        axis('off');
    end
%         test(1:20,j)=ChannelOrder(1:20);
end

combs = nchoosek(1:size(m,3),2);
m(isnan(m))=0;
for i=1:size(combs,1)
I1 = squeeze(m(:,:,combs(i,1)));
I1 = (I1-mean(I1(:)))/var(I1(:));
I2 = squeeze(m(:,:,combs(i,2)));
I2 = (I2-mean(I2(:)))/var(I2(:));
cor = xcorr2(I1,I2)./sqrt(sum(dot(I1,I1))*sum(dot(I2,I2))); 
corr(i)=abs(max(cor(:)));
end
mat = zeros(size(m,3),size(m,3));
for i=1:size(combs,1)
mat(combs(i,1),combs(i,2))=corr(i);
end
mat = mat + mat'+eye(size(mat));
figure;
imagescnan(mat);
[m1,n1] = size(mat);
test=pdist(mat);
test2=linkage(test,'weighted');
figure;
[~,~,vm] = dendrogram(test2,size(mat,1));
[~,y] = ginput(1);
clusters  = cluster(test2,'CutOff',y,'Criterion','distance','Depth',2); 
end




