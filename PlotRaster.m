function PlotRaster(t,ic,tcenter,min)
% Creates a raster plot 
    
% tcenter=max(t)-min/2*(12000*60); %Around what center in time do you want your window?
res=10000; %Resolution of Image
startframe=tcenter-min/2*(12000*60);
endframe=tcenter+min/2*(12000*60);
NumC=size(ic,2); %Number of recorded channels
m=MakeRasterImage1(t,ic,min*(12000*60),tcenter,res,5);
f=figure('visible','on','Position', get(0,'Screensize'));
set(gcf,'Renderer','painter');
set(gcf,'DoubleBuffer','on');
imagesc(m);
set(gca,'XTick', linspace(1,res,4),'XTickLabel',round(linspace(1,min/2,4)*10)/10,'FontSize',16,'TickDir', 'out');
set(gca,'YTick',[],'YTickLabel',[]);
ylabel('Electrodes','FontSize',18);
box('off');
maximize(gcf);
set(gcf,'color','w');
end