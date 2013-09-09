function CreatePrePostRasterTrimAroundStim(DataSetBase,DataSetStims,which)
% Creates a raster plot from the end of one of the baseline recordings and
% next to it a raster from the beginning of the stimulation recording with
% HA neurons and low firing removed. See SortChannelsByFR.m for more
% information.

%% Make same set of electrodes pre/post

tpre=DataSetBase{which}.Trim.t;
icpre=DataSetBase{which}.Trim.ic;
tpost=DataSetStims{which}.Trim.t;
icpost=DataSetStims{which}.Trim.ic;
a=icpre(1,:);
b=icpost(1,:);

onlysame=ismember(a,b);
icpre=icpre(:,onlysame);

onlysame=ismember(b,a);
icpost=icpost(:,onlysame);

for i=1:size(icpost,2)
    icpre1(:,i) = icpre(:,icpre(1,:)==icpost(1,i));
end
icpre=icpre1;

%% Create Rasters
for i=1:2
    
    c=colormap(gray(64));
    min=0.5; %How many minutes do you want your window?
    
    if i==1
        t=tpre;
        ic=icpre;
        tcenter=max(t)-min/2*(12000*60); %Around what center in time do you want your window?
    end
    
    if i==2
        t=tpost;
        ic=icpost;
        tcenter=t(1)+min/2*(12000*60);
    end
    
    res=10000; %Resolution of Image
    startframe=tcenter-min/2*(12000*60);
    endframe=tcenter+min/2*(12000*60);
    NumC=size(icpre,2); %Number of recorded channels
    
    m=MakeRasterImage1(t,ic,min*(12000*60),tcenter,res,5);
    if i==1
        f=figure('visible','on','Position', get(0,'Screensize'));
        h=subplot(1,2,1);
        imagesc(m);
        lastframe=endframe/12000/60;
        set(gca,'XTick', round(linspace(1,res,4)),'XTickLabel',round(linspace(-(min*60/2),0,4)),'TickDir', 'out');
        set(gca,'YTick',[],'YTickLabel',[]);
        ylabel('electrodes');
        box('off');
        hold off
        annotation(gcf,'textbox',[0.6105 0.0463 0.0547 0.0297],'String',{'stimulation'},'FitBoxToText','on','LineStyle','no');
    end
    
    if i==2
        pos = get(gca, 'Position');
        hax = axes('Position', [3.6*pos(1) pos(2) pos(3) pos(4)]);
        f2 = imagesc(m);    
        xlim([0 res]);
        box('off');
        xval = round(linspace(0,res,4));
        xlab = round(linspace(0,(min*60)/2,4));
        set(gca,'XTick',xval,'XTickLabel',xlab(1:end),'TickDir', 'out');
        set(gca,'YTick',[],'YTickLabel',[]);
        xpos = 0.4645+0.00285;        
        annotation(gcf,'textbox',[0.2788 0.0459 0.0463 0.0297],'String',{'baseline'},'FitBoxToText','on','LineStyle','no');
        annotation(gcf,'arrow',[xpos xpos],[0.0963 0.1202],'LineWidth',6,'color','r');
        annotation(gcf,'arrow',[xpos xpos],[0.9449 0.9151],'LineWidth',6,'color','r');
        annotation(gcf,'line',[xpos xpos],[0.1069 0.9327],'LineWidth',2,'Color',[1 0 0]);
    end
    %
end
figHandles = findobj('Type','figure');
close(figHandles(2));
set(gcf,'Renderer','painter') ;
set(gcf,'DoubleBuffer','on')
set(findall(gcf,'-property','FontSize'),'FontUnits','pixels','FontSize',38);
end