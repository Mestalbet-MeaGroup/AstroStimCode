function m= PlotBurstPropogation(t,ic,bs,be);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
load('16x16MeaMap_90CW_Inverted.mat');

Nbursts=numel(bs);
m = nan(size(MeaMap),size(MeaMap),Nbursts);

ic = ConvertIC2Samora(ic);
[t,ix]=sort(t);
ic=ic(ix);

for j=1:Nbursts
    a=find(t>=bs(j) & t<=be(j));
    ChannelOrder=unique(ic(a),'stable');
    cmap = jet(size(ChannelOrder,2));
    %     cmap = createcolormap(MeaMap,'intensity',1,'invert',1,'N',numel(MeaMap)+1);
    for i=1:size(ChannelOrder,2)
        [x,y]=find(MeaMap==ChannelOrder(i),1,'First');
        if ~isempty(x)
            m(x,y,j)=i;
        end
    end
    if (sqrt(Nbursts)-floor(sqrt(Nbursts)))>0
        subplot(floor(sqrt(Nbursts)),floor(sqrt(Nbursts))+1,j);
        imagescnan(m(:,:,j));
        set(gca,'YDir','reverse','XDir','reverse');
        axis('off');
    else
        subplot(floor(sqrt(Nbursts)),floor(sqrt(Nbursts)),j);
        imagescnan(m(:,:,j));
        axis('off');
    end
    %     test(1:80,j)=ChannelOrder(1:80);
end

h=gcf;

end


