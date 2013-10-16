function CalcPlotBurstInitiationPDF2(BurstData,ClusterIDs,CorrMat,MeaMap);
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
bursts=[];
j=1;
% for j=1:1000 %Create random seperations between non-sb bursts
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0));
    ind = randsample(size(bursts,3),round(size(bursts,3)/2));
    vec=1:size(bursts,3);
    notind = ~ismember(vec,ind);
    notind=sort(find(notind))';
    pdfpreC{i}=CalcBurstOrigins4PDF(bursts(:,:,ind));
    pdfpostC{i}=CalcBurstOrigins4PDF(bursts(:,:,notind));
    distCpre{i} = CalcDistBetweenBurstInits(bursts(:,:,ind));
    distCpost{i} = CalcDistBetweenBurstInits(bursts(:,:,notind));
    temp=pdfpostC{i}-pdfpreC{i};
    divcontrol(i,j)=mean(abs(temp(:)));
end
% end
divcontrol=mean(divcontrol,2)';
figure;

PlotPDFCultures(pdfpre,pdfpostC,pdfpost,StimSite,divcontrol,divpreppost,MeaMap);
export_fig 'BurstInitiationPDF_SBnsbC.png';
% close all;
% [h,p]=ttest2(divcontrol,divpreppost,'Alpha',0.1)


%% Limit to post
j=1;
% for j=1:1000 %Create random seperations between non-sb bursts
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0)&(BurstData.prepost==1));
    pdfpre{i} = CalcBurstOrigins4PDF(bursts);
    distpre{i} = CalcDistBetweenBurstInits(bursts);
    %     sum(pdfpre{i}(:))
end
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1)&(BurstData.prepost==1));
    pdfpost{i}= CalcBurstOrigins4PDF(bursts);
    distpost{i} = CalcDistBetweenBurstInits(bursts);
    temp=pdfpost{i}-pdfpre{i};
    divpreppost(i)=mean(abs(temp(:)));
    %     sum(pdfpost{i}(:))
end
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0)&(BurstData.prepost==1));
    ind = randsample(size(bursts,3),round(size(bursts,3)/2));
    vec=1:size(bursts,3);
    notind = ~ismember(vec,ind);
    notind=sort(find(notind))';
    pdfpreC{i}=CalcBurstOrigins4PDF(bursts(:,:,ind));
    pdfpostC{i}=CalcBurstOrigins4PDF(bursts(:,:,notind));
    distCpre{i} = CalcDistBetweenBurstInits(bursts(:,:,ind));
    distCpost{i} = CalcDistBetweenBurstInits(bursts(:,:,notind));
    temp=pdfpostC{i}-pdfpreC{i};
    divcontrol(i,j)=mean(abs(temp(:)));
end

divcontrol=mean(divcontrol,2)';
figure;
PlotPDFCultures(pdfpre,pdfpostC,pdfpost,StimSite,divcontrol,divpreppost,MeaMap);
export_fig 'BurstInitiationPDF_SBnsbC_onlyPost.png';
%% Between Regular bursts
j=1;
% for j=1:1000 %Create random seperations between non-sb bursts
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0)&(BurstData.prepost==0));
    pdfpre{i} = CalcBurstOrigins4PDF(bursts);
    distpre{i} = CalcDistBetweenBurstInits(bursts);
    %     sum(pdfpre{i}(:))
end
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0)&(BurstData.prepost==1));
    pdfpost{i}= CalcBurstOrigins4PDF(bursts);
    distpost{i} = CalcDistBetweenBurstInits(bursts);
    temp=pdfpost{i}-pdfpre{i};
    divpreppost(i)=mean(abs(temp(:)));
    %     sum(pdfpost{i}(:))
end
bursts=[];
for i=1:13
    bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==0)&(BurstData.prepost==0));
    ind = randsample(size(bursts,3),round(size(bursts,3)/2));
    vec=1:size(bursts,3);
    notind = ~ismember(vec,ind);
    notind=sort(find(notind))';
    pdfpreC{i}=CalcBurstOrigins4PDF(bursts(:,:,ind));
    pdfpostC{i}=CalcBurstOrigins4PDF(bursts(:,:,notind));
    distCpre{i} = CalcDistBetweenBurstInits(bursts(:,:,ind));
    distCpost{i} = CalcDistBetweenBurstInits(bursts(:,:,notind));
    temp=pdfpostC{i}-pdfpreC{i};
    divcontrol(i,j)=mean(abs(temp(:)));
end

divcontrol=mean(divcontrol,2)';
figure;
PlotPDFCultures(pdfpre,pdfpostC,pdfpost,StimSite,divcontrol,divpreppost,MeaMap);

    function PlotPDFCultures(pdfpre,pdfpostC,pdfpost,StimSite,divcontrol,divpreppost,MeaMap)
        counter=1;
        for k=1:13
            if (k~=8)&&(k~=11)
                subplot(4,3,counter);
                title(['Culture ' num2str(k)]);
                hold on;
                pcolor(cat(2,pdfpre{k},nan(16,1),pdfpostC{k},nan(16,1),pdfpost{k}));
                colormap(fliplr(cbrewer('div','RdYlBu',256)));
                shading flat;
                set(gca,'cLim',[0 0.02]);
                if ~isempty(StimSite{k})
                    [x,y]=find(MeaMap==StimSite{k});
                    %             plot(x,y,'.','color',[1 0 1],'MarkerSize',45);
                    plot(x+32,y,'.','color',[1 0 1],'MarkerSize',45);
                end
                hold off;
                counter=counter+1;
                axis('tight');
                axis('off');
                set(gca,'PlotBoxAspectRatio',[3 1 1]);
            end
        end
        
        subplot(4,3,12);
        notBoxPlot([divcontrol;divpreppost]');
        grid on;
        set(gca,'XTickLabel',{'Control','Stimulation'});
        maximize(gcf);
        set(gcf,'color','w');
    end
export_fig 'BurstInitiationPDF_NSBpreNSBpost.png';
end
%%
%%