function PlotRasterWithAstroTrace(t,ic,tcenter,minutes,time,trace)
% Creates a raster plot

% tcenter=max(t)-min/2*(12000*60); %Around what center in time do you want your window?
res=10000; %Resolution of Image
startframe=tcenter-minutes/2*(12000*60);
endframe=tcenter+minutes/2*(12000*60);
NumC=size(ic,2); %Number of recorded channels
m=MakeRasterImage1(t,ic,minutes*(12000*60),tcenter,(endframe-startframe)/100,5);
f=figure('visible','on','Position', get(0,'Screensize'));
set(gcf,'Renderer','painter');
set(gcf,'DoubleBuffer','on');
imagesc(m);
ax1 = gca;
% set(ax1,'XTick', linspace(1,res,4),'XTickLabel',round(linspace(1,minutes/2,4)*10)/10,'FontSize',16,'TickDir', 'out');
set(ax1,'YTick',[],'YTickLabel',[]);
box('off');
xticks=round(linspace(1,res,10));
xticklabs = round(linspace(startframe/12000,endframe/12000,10));
set(ax1,'XTick',xticks,'XTickLabel',xticklabs);
xlabel(ax1,'time [sec]');
% ReTime = linspace(time(1)*12000,time(end)*12000, (endframe-startframe)/((time(end)-time(1))*12000)*size(m,2));
% RaTime = linspace(startframe,endframe,size(m,2));
% start=find(RaTime(1)<=ReTime,1,'First');
% stop=find(RaTime(end)<=ReTime,1,'First');
% trace=resample(trace,round((endframe-startframe)/((time(end)-time(1))*12000)*size(m,2)),size(trace,1));
% CutTime=ReTime(start:stop);
x=resample(time*12000,res,length(time));
y=resample(trace,res,length(time));
start=find(x>=startframe,1,'First');
stop=find(x>=endframe,1,'First')-1;
CutTime = x(start:stop);
% start=find(time*12000>=startframe,1,'First');
% stop=find(time*12000>=endframe,1,'First')-1;
% CutTime = time(start:stop);
ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none');
% set(ax2,'PlotBoxAspectRatio',[1,1,1]);
axis(ax2,'off');
vec = [1,32,8,13,31,51,3];
for i=1:2
%     CutTrace = trace(start:stop,vec(i));
    CutTrace = y(start:stop,vec(i));
    CutTrace = ( CutTrace-min(CutTrace) )/ (max(CutTrace) - min(CutTrace));
    line(CutTime,CutTrace+i*0.8,'Parent',ax2,'LineWidth',2);
%     line(CutTime,ones(length(CutTime),1).*(min(CutTrace)+i*0.7),'Parent',ax2,'LineWidth',2,'LineStyle','-.');
    ylim(ax2,[0.5 2.5]);
    
    withBoxAspectRatio = 0.7306;
    NoBoxAspectRatio = 0.9105;
%     annotation(gcf,'textbox',[withBoxAspectRatio,(min(CutTrace)+i*0.7)/2.5,0.0748,0.0373],'String',...
%         {['Astrocyte ' num2str(i)]},'FitBoxToText','on','fontsize',16,'Color','b','LineStyle','none');
    annotation(gcf,'textbox',[NoBoxAspectRatio,(min(CutTrace)+i*0.7)/2.5,0.0748,0.0373],'String',...
        {['Astrocyte ' num2str(i)]},'FitBoxToText','on','fontsize',16,'Color','b','LineStyle','none');
end

% set(gca,'XTick',[round(CutTime(1)):20:round(CutTime(end))],'XTickLabel',[round(CutTime(1)):20:round(CutTime(end))]-round(CutTime(1)));
maximize(gcf);
set(gcf,'color','none');

% export_fig 'RasterWithCaTrace.png';



end