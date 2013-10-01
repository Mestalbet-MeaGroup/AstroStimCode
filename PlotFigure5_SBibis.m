fclose('all');clear all; close all;clc;
load('DataSetOpto_trim4HA.mat');
SBibi=[];
for i=1:size(DataSetStims,1)
    
    if numel(DataSetStims{i}.sbs)>2
        sbs=DataSetStims{i}.sbs;
        sbe=DataSetStims{i}.sbe;
        SBibi = [SBibi, sbe(2:end)-sbs(1:end-1)];
    end
    
end
SBibi=SBibi./12000;
[CdfY,CdfX,flo,fup] = ecdf(SBibi','Function','cdf');
CdfX=CdfX(2:end)';
CdfY=CdfY(2:end)';
flo=flo(2:end)';
fup=fup(2:end)';
xPred = fitdist(SBibi', 'lognormal');
[yPred,YLower,YUpper] = cdf(xPred,CdfX);
X = [CdfX,fliplr(CdfX)]; 
Y = [flo(1:end-1),CdfY(end),CdfY(end), fliplr(fup(1:end-1))];

% opengl('software');
h=figure('Renderer','painters');
hold on;
loglog(CdfX,CdfY,'ok','MarkerSize',4,'MarkerFaceColor','k');
loglog(CdfX,yPred,'-r','LineWidth',3);
patch(X,Y,'b','FaceAlpha',0.2,'EdgeColor','b');
plot([CdfX(:); NaN; CdfX(:);NaN],[YLower(:); NaN; YUpper(:);NaN;],':r','LineWidth',2);

title('cumulative density function');
xlabel('interval between superbursts [sec]');
ylabel('probability');
grid on;
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
print('-depsc2','-r300','Fig5_SBibiCDF.eps');

