function [pdfpre,pdfpost]=CalcPlotBurstInitiationPDF3(BurstData,MeaMap,type);
% fclose('all');clear all; close all;clc;
% load('tempBurstsWithClusters.mat')

%% Experiment
%--------------------------------%
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
%------------------------------%

CultNoSBs = [8,11];
CultSBsPre = [7,12,13];
Stims = [1:6,9:10];

%% Between Regular bursts
j=1;
divcontrol=nan(1,13);

for i=1:max(BurstData.cultId)
    switch type
        case 'INvOUT'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1)&(BurstData.nsbsb==0));
        case 'PREvPOST'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==0));
        case 'RegPREvPOST'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==0)&(BurstData.nsbsb==0));
    end
%     if i==4
%         display(size(bursts,3));
%     end
    pdfpre{i} = CalcBurstOrigins4PDF(bursts);
    distpre{i} = CalcDistBetweenBurstInits(bursts);
end
bursts=[];

for i=1:max(BurstData.cultId)
    switch type
        case 'INvOUT'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1)&(BurstData.nsbsb==1));
        case 'PREvPOST'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1));
        case 'RegPREvPOST'
            bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.prepost==1)&(BurstData.nsbsb==0));
    end
%     if i==4
%         display(size(bursts,3));
%     end
    pdfpost{i}= CalcBurstOrigins4PDF(bursts);
    distpost{i} = CalcDistBetweenBurstInits(bursts);
    temp=pdfpost{i}-pdfpre{i};
    if (i==14)||(i==15)
        divcontrol(i-13)=max(abs(temp(:)));
    else
        divpreppost(i)=max(abs(temp(:)));
    end
end

figure('name','Between Regular Bursts: Pre Vs. Post');
PlotPDFCultures(pdfpre,pdfpost,StimSite,divcontrol,divpreppost,MeaMap,CultNoSBs,CultSBsPre,Stims);

    function PlotPDFCultures(pdfpre,pdfpost,StimSite,divcontrol,divpreppost,MeaMap,CultNoSBs,CultSBsPre,Stims)
        counter=1;
        for k=1:size(pdfpre,2)
                subplot(4,4,counter);
                title(['Culture ' num2str(k)]);
                hold on;
                mat4plot = cat(2,pdfpre{k},nan(16,1),pdfpost{k});
                pcolor(mat4plot);
                xlim([1 33]);
                ylim([1 16]);
                colormap(fliplr(cbrewer('div','RdYlBu',256)));
                shading flat;
                set(gca,'cLim',[0 max(mat4plot(:))]);
                if ~isempty(StimSite{k})
                    [x,y]=find(MeaMap==StimSite{k});
                    r=6.75/2;
                    ang=0:0.01:2*pi;
                    xp=r*cos(ang);
                    yp=r*sin(ang);
                    plot(x+xp,y+yp,'color',[1 0 1]);
                    plot(x+xp+16,y+yp,'color',[1 0 1]);
%                     plot(plot::Circle2d(6.75, [x, y])); 
%                     plot(x+16,y,'.','color',[1 0 1],'MarkerSize',45);
%                     plot(x,y,'.','color',[1 0 1],'MarkerSize',45);
                end
                hold off;
                counter=counter+1;
%                 axis('tight');
                axis('off');
                set(gca,'PlotBoxAspectRatio',[33 16 1]);
        end
        
        subplot(4,4,16);
        plotme = nan(4,15);
        plotme(1,1:length(divcontrol)) = divcontrol;
        plotme(2,1:length(divpreppost(Stims))) = divpreppost(Stims);
        plotme(3,1:length(divpreppost(CultNoSBs))) = divpreppost(CultNoSBs);
        plotme(4,1:length(divpreppost(CultSBsPre))) = divpreppost(CultSBsPre);
        notBoxPlot(plotme');
        grid on;
        set(gca,'XTickLabel',{'No Transfection','Stimulation','No SB Response','SBs in Pre'});
        rotateXLabels(gca(),20);
        maximize(gcf);
        set(gcf,'color','w');
    end
% export_fig 'BurstInitiationPDF_NSBpreNSBpost.png';
%% Bar plot of differences in spot
% figure; 
% for i=1:size(StimSite,2);
%     if ~isempty(StimSite{i})
%         [xs,ys]=find(MeaMap==StimSite{i});
%         spot = zeros(size(MeaMap));
%         spot(xs,ys)=1;
%         se = strel('disk',3);
%         spot = imdilate(spot,se);
%         spot(spot==0)=nan;
%         temp1 = spot.*pdfpre{i};
%         temp2 = spot.*pdfpost{i};
%         vals(i,1) = nanmean(temp1(:));
%         vals(i,2) = nanmean(temp2(:));
%     else 
%         vals(i,1) = nan;
%         vals(i,2) = nan;
%     end
% end
% bar(vals);
end