function CreatePrePostRasterTrim(DataSetBase,DataSetStims,which)
% Creates a raster plot from the end of one of the baseline recordings and
% next to it a raster from the beginning of the stimulation recording with
% HA neurons and low firing removed. See SortChannelsByFR.m for more
% information.

%% Make same set of electrodes pre/post
% load(cultures{vec(1)});
% which=6;
% load('E:\AstroStimArticleDataSet\Code\DataSetStim.mat');

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

% icpre=icpre(:,1:100);
% icpost=icpost(:,1:100);
%% Create Rasters
for i=1:2
    
    c=colormap(gray(64));
    min=6; %How many minutes do you want your window?
    
    if i==1
        t=tpre;
        ic=icpre;
        tcenter=max(t)-min/2*(12000*60); %Around what center in time do you want your window?
    end
    
    if i==2
        t=tpost;
        ic=icpost;
        %     tcenter=t(1)+min/2*(12000*60); %Around what center in time do you want your window?
        if ~isempty(DataSetStims{which}.sbs)
            if DataSetStims{which}.sbe(1)-min/2*(12000*60)>0
                if DataSetStims{which}.sbe(1)+min/2*(12000*60)<max(DataSetStims{which}.Trim.t)
                    tcenter=DataSetStims{which}.sbe(1)-min/2*(12000*60); %Around what center in time do you want your window?
                else
                    temp=DataSetStims{which}.sbe(1)-abs(max(DataSetStims{which}.Trim.t) - (DataSetStims{which}.sbe(1)+min/2*(12000*60)) )-min/2*(12000*60); %moves center so window doesn't exceed last recorded spike
                    tcenter=temp+min/2*(12000*60);
                end
            else
                temp=DataSetStims{which}.sbe(1)+abs(DataSetStims{which}.sbe(1)-min/2*(12000*60))-min/2*(12000*60); %moves center so window doesn't begin before recording start
                tcenter=temp+min/2*(12000*60); %Around what center in time do you want your window?
            end
        else
            %             if which==13
            %                 tcenter=1804118+min/2*(12000*60);
            %             else
            tcenter=t(1)+min/2*(12000*60);
            %             end%Around what center in time do you want your window?
        end
    end
    res=10000; %Resolution of Image
    startframe=tcenter-min/2*(12000*60);
    endframe=tcenter+min/2*(12000*60);
    NumC=size(icpre,2); %Number of recorded channels
    
    m=MakeRasterImage1(t,ic,min*(12000*60),tcenter,res,5);
    %         close all;
    if i==1
        f=figure('visible','on','Position', get(0,'Screensize'));
        h=subplot(1,2,1);
        imagesc(m);
        %     hold on; h=image(M3);
        %     box(gca,'on');
        %     alpha(h, 0.5);
        %         s{1}=num2str(floor((startframe/12000/60)));
        %         s{2}=num2str(floor((tcenter/12000/60)));
        lastframe=endframe/12000/60;
        set(gca,'XTick', linspace(1,res,4),'XTickLabel',round(linspace(1,min/2,4)*10)/10,'FontSize',16,'TickDir', 'out');
        set(gca,'YTick',[],'YTickLabel',[]);
        ylabel('Electrodes','FontSize',18);
        box('off');
        hold off
        annotation(gcf,'textbox',[0.6105 0.0463 0.0547 0.0297],'String',{'Baseline'},'FontSize',12,'FitBoxToText','on','LineStyle','no');
    end
    
    if i==2
        pos = get(gca, 'Position');
        hax = axes('Position', [3.5715*pos(1) pos(2) pos(3) pos(4)]);
%         m(:,1:10,:) = repmat([1 0 0],[],218);
%         m(:,1:300,:)=repmat([1 0 0],[218, 100,3]);
        f2 = imagesc(m);    
        box('off');
        xval = linspace(1,res,4);
        xlab = round(linspace(min/2,min,4)*10)/10;
        set(gca,'XTick',xval,'XTickLabel',{[],xlab(2:end)},'FontSize',16,'TickDir', 'out');
        set(gca,'YTick',[],'YTickLabel',[]);
        xpos = 0.4645;        
        annotation(gcf,'textbox',[0.2788 0.0459 0.0463 0.0297],'String',{'Stimulation'},'FontSize',12,'FitBoxToText','on','LineStyle','no');
        annotation(gcf,'arrow',[xpos xpos],[0.0476 0.0715],'LineWidth',6,'color','r');
        annotation(gcf,'arrow',[xpos xpos],[0.9625 0.9327],'LineWidth',6,'color','r');
        annotation(gcf,'line',[xpos xpos],[0.1069 0.9327],'LineWidth',2,'Color',[1 0 0]);
    end
    %
end
figHandles = findobj('Type','figure');
close(figHandles(2));
set(gcf,'Renderer','painter') ;
set(gcf,'DoubleBuffer','on')
end