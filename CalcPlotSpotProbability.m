% load('DataSet4Figure.mat')
type = 'RegPREvPOST'; % Sets the type of comparison to be calculated:
% (PREvPOST = baseline versus stimulation,
%  INvOUT   = regular bursts versus bursts within superbursts during stimulation,
%  RegPREvPOST = regular bursts during baseline versus regular bursts during stimulation)
[pdfpre,pdfpost]=CalcPlotBurstInitiationPDF3(BurstData,MeaMap,type);
close all;
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.05], [0.05 0.05]);
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
    [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
    [culTypes{3} '(1)*'] [culTypes{3} '(2)']...
    [culTypes{4} '(1)'] [culTypes{4} '(2)*'] [culTypes{4} '(3)'] [culTypes{4} '(4)'], 'Control (1)', 'Control (2)'};
%----------------------------%
StimSite{1} =[];
StimSite{2} =[];
StimSite{3} =13;
StimSite{4} =94;
StimSite{5} =150;
StimSite{6} =95;
StimSite{7} =138;
StimSite{8} =228;
StimSite{9} =[];
StimSite{10} =[];
StimSite{11} =[];
StimSite{12} =49;
StimSite{13} =[];
StimSite{14} =[];
StimSite{15} =[];

withinSpotPre=[];
withinSpotPost=[];

outsideSpotPre=[];
outsideSpotPost=[];

yOut=[];
yWithin=[];

for i=1:size(StimSite,2);
    if ~isempty(StimSite{i})
        %----Create Spot-----%
        [xs,ys]=find(MeaMap==StimSite{i});
        spot = zeros(size(MeaMap));
        spot(xs,ys)=1;
        se = strel('disk',4);
        spot = imdilate(spot,se);
        spotA=spot;
        spot(spot==0)=nan;
        
        %----Values within Spot---%
        temp1 = spot.*pdfpre{i};
        temp2 = spot.*pdfpost{i};
        v1=temp1(~isnan(temp1));
        v2=temp2(~isnan(temp2));
        
        %----Values Outside Spot---%
        spotA(spotA==1)=nan;
        spotA(spotA==0)=1;
        temp1A = spotA.*pdfpre{i};
        temp2A = spotA.*pdfpost{i};
        v1A=temp1A(~isnan(temp1A));
        v2A=temp2A(~isnan(temp2A));
            
        figure;
        s1=subplot(1,3,1); imagescnan(temp1); set(gca,'YDir','normal','PlotBoxAspectRatio',[1 1 1],'YTickLabel',[],'XTickLabel',[]); caxis([0 0.02]);
        s2=subplot(1,3,2);imagescnan(temp2);set(gca,'YDir','normal','PlotBoxAspectRatio',[1 1 1],'YTickLabel',[],'XTickLabel',[]);caxis([0 0.02]);
        title(['Culture ' cultLabels(i)]);
        colorbar('location','eastoutside');
        s1Pos = get(s1,'position');
        s2Pos = get(s2,'position');
        s2Pos(3:4) = s1Pos(3:4);
        set(s2,'position',s2Pos);
        if numel(v1)==numel(v2)
            subplot(1,3,3); hold on;
            [v1,ix]=sort(v1,'ascend');
            v2=v2(ix);
            plot(v1./sum(v1),v2./sum(v2),'ok','MarkerFaceColor','k','DisplayName','Inside Spot');
            xlabel('P_{baseline} / Total Probability Within Given Area');
            ylabel('P_{stimulation} / Total Probability Within Given Area');
            withinSpotPre = [withinSpotPre;v1];
            withinSpotPost = [withinSpotPost;v2];
        end
        
        if numel(v1A)==numel(v2A)
            [v1A,ixA]=sort(v1A,'ascend');
            v2A=v2A(ixA);
            plot(v1A./sum(v1A),v2A./sum(v1A),'or','DisplayName','Outside Spot');
            outsideSpotPre = [outsideSpotPre;v1A];
            outsideSpotPost = [outsideSpotPost;v2A];
%             line([0 0.03],[0 0.03]);
            %                 subplot(1,3,3); hold on; plot(v1,v2/(v1+v2),'.k'); plot(v1A,v2A/(v1A+v2A),'or');line([0,0.025],[0,1]);
        end
        set(gca,'PlotBoxAspectRatio',[1 1 1],'YAxisLocation', 'right');
        legend('-DynamicLegend');
%         ylim([0 0.035]); xlim([-0.001 0.03]);
        maximize(gcf);
        export_fig(['ProbabilityPbaseVsPstimNorm_',type,'_',num2str(i), '.png']);
        close all;
        
    end
end

for i=1:size(StimSite,2);
    if ~isempty(StimSite{i})
        %----Create Spot-----%
        [xs,ys]=find(MeaMap==StimSite{i});
        spot = zeros(size(MeaMap));
        spot(xs,ys)=1;
        se = strel('disk',4);
        spot = imdilate(spot,se);
        spotA=spot;
        spot(spot==0)=nan;
        
        %----Values within Spot---%
        temp1 = spot.*pdfpre{i};
        temp2 = spot.*pdfpost{i};
        v1=temp1(~isnan(temp1));
        v2=temp2(~isnan(temp2));
        
        %----Values Outside Spot---%
        spotA(spotA==1)=nan;
        spotA(spotA==0)=1;
        temp1A = spotA.*pdfpre{i};
        temp2A = spotA.*pdfpost{i};
        v1A=temp1A(~isnan(temp1A));
        v2A=temp2A(~isnan(temp2A));
            
        figure;
        s1=subplot(1,3,1); imagescnan(temp1); set(gca,'YDir','normal','PlotBoxAspectRatio',[1 1 1],'YTickLabel',[],'XTickLabel',[]); caxis([0 0.02]);
        s2=subplot(1,3,2);imagescnan(temp2);set(gca,'YDir','normal','PlotBoxAspectRatio',[1 1 1],'YTickLabel',[],'XTickLabel',[]);caxis([0 0.02]);
        title(['Culture ' cultLabels(i)]);
        colorbar('location','eastoutside');
        s1Pos = get(s1,'position');
        s2Pos = get(s2,'position');
        s2Pos(3:4) = s1Pos(3:4);
        set(s2,'position',s2Pos);
        if numel(v1)==numel(v2)
            subplot(1,3,3); hold on;
            [v1,ix]=sort(v1,'ascend');
            v2=v2(ix);
            plot(v1,v2,'ok','MarkerFaceColor','k','DisplayName','Inside Spot');
            line([0 0.03],[0 0.03],'DisplayName','P_{base}=P_{Stim}');
            xlabel('P_{baseline}');
            ylabel('P_{stimulation}');
            withinSpotPre = [withinSpotPre;v1];
            withinSpotPost = [withinSpotPost;v2];
        end
        
        if numel(v1A)==numel(v2A)
            [v1A,ixA]=sort(v1A,'ascend');
            v2A=v2A(ixA);
            plot(v1A,v2A,'or','DisplayName','Outside Spot');
            outsideSpotPre = [outsideSpotPre;v1A];
            outsideSpotPost = [outsideSpotPost;v2A];
        end
        set(gca,'PlotBoxAspectRatio',[1 1 1],'YAxisLocation', 'right');
        legend('-DynamicLegend');
        ylim([0 0.035]); xlim([-0.001 0.03]);
        maximize(gcf);
        export_fig(['ProbabilityPbaseVsPstim_',type,'_',num2str(i), '.png']);
        close all;
        
    end
end

yOut = outsideSpotPost./(outsideSpotPost+outsideSpotPre);
yWithin = withinSpotPost./(withinSpotPre+withinSpotPost);
figure; hold all; plot(withinSpotPre,yWithin,'.');plot(outsideSpotPre,yOut,'.');