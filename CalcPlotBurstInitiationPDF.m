
function CalcPlotBurstInitiationPDF
fclose('all');clear all; close all;clc;
load('tempBurstsWithClusters.mat')

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
%------------------------------%
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0));
    pdfpre{i} = CalcBurstOrigins4PDF(bursts);
    distpre{i} = CalcDistBetweenBurstInits(bursts);
%     sum(pdfpre{i}(:))
end
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1));
    pdfpost{i}= CalcBurstOrigins4PDF(bursts);
    distpost{i} = CalcDistBetweenBurstInits(bursts);   
    temp=pdfpost{i}-pdfpre{i};
    divpreppost(i)=mean(abs(temp(:)));
%     sum(pdfpost{i}(:))
end

figure;
counter=1;
for i=1:13
    subplot(4,4,counter);
    title(['Culture ' num2str(i)]);
    hold on;
    pcolor(cat(2,pdfpre{i},nan(16,1),pdfpost{i}));
    colormap(fliplr(cbrewer('div','RdYlBu',256)));
    shading flat;
    set(gca,'cLim',[0 0.02]);
    if ~isempty(StimSite{i})
        [x,y]=find(MeaMap==StimSite{i});
        plot(x,y,'.','color',[1 0 1],'MarkerSize',45);
        plot(x+16,y,'.','color',[1 0 1],'MarkerSize',45);
    end
    hold off;
    counter=counter+1;
    axis('tight');
    axis('off');
    set(gca,'PlotBoxAspectRatio',[2 1 1]);
end
colorbar;
% subplot(4,4,14:15);
% barwitherr([cellfun(@std,distpre);cellfun(@std,distpost)]',[cellfun(@mean,distpre);cellfun(@mean,distpost)]','grouped');
maximize(gcf);
export_fig 'BurstInitiationPDF_SBvsNSB.png';
close all;
%% Control
bursts=[];
for j=1:1000 %Create random seperations between non-sb bursts 
    for i=1:13
        bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0));
        ind = randsample(size(bursts,3),round(size(bursts,3)/2));
        vec=1:size(bursts,3);
        notind = ~ismember(vec,ind);
        notind=sort(find(notind))';
        pdfpre{i}=CalcBurstOrigins4PDF(bursts(:,:,ind));
        pdfpost{i}=CalcBurstOrigins4PDF(bursts(:,:,notind));
        distCpre{i} = CalcDistBetweenBurstInits(bursts(:,:,ind)); 
        distCpost{i} = CalcDistBetweenBurstInits(bursts(:,:,notind));
        temp=pdfpost{i}-pdfpre{i};
        divcontrol(i,j)=mean(abs(temp(:)));
    end
end
divcontrol=mean(divcontrol,2)';

figure;
counter=1;
for i=1:13
    subplot(4,4,counter);
    title(['Culture ' num2str(i)]);
    hold on;
    pcolor(cat(2,pdfpre{i},nan(16,1),pdfpost{i}));
    colormap(fliplr(cbrewer('div','RdYlBu',256)));
    shading flat;
    set(gca,'cLim',[0 0.02]);
    if ~isempty(StimSite{i})
        [x,y]=find(MeaMap==StimSite{i});
        plot(x,y,'.','color',[1 0 1],'MarkerSize',45);
        plot(x+16,y,'.','color',[1 0 1],'MarkerSize',45);
    end
    hold off;
    counter=counter+1;
    axis('tight');
    axis('off');
    set(gca,'PlotBoxAspectRatio',[2 1 1]);
end
subplot(4,4,14:15);
% bar([divcontrol;divpreppost]','grouped');
barwitherr([cellfun(@std,distCpre);cellfun(@std,distCpost)]',[cellfun(@mean,distCpre);cellfun(@mean,distCpost)]','grouped');
subplot(4,4,16);
notBoxPlot([divcontrol;divpreppost]');
set(gca,'XTickLabel',{'Control','Stimulation'});
maximize(gcf);
export_fig 'BurstInitiationPDF_Control.png';
% close all;
% [h,p]=ttest2(divcontrol,divpreppost,'Alpha',0.1)
end
%%