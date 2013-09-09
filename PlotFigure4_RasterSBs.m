load('DataSetOpto_trim4test2.mat');
for i=[1,4]
figure;
[SumFirings,Firings] = CreatePeriSBhist(DataSetStims{i}.Trim.t,DataSetStims{i}.sbs,DataSetStims{i}.sbe);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
maximize(gcf);
set(gcf,'color','none');
% export_fig(['PeriSBhist' num2str(i) '.pdf']);
% plot2svg(['PeriSBhist' num2str(i) '.svg'], gcf,'png');
print('-depsc2','-r300',['PeriSBhist' num2str(i) '.eps']);
close all;
CreatePrePostRasterTrim(DataSetBase,DataSetStims,i);
set(gcf,'color','none');
maximize(gcf);
% export_fig(['PrePostRaster' num2str(i) '.pdf']);
% plot2svg(['PrePostRaster' num2str(i) '.svg'], gcf,'png');
print('-depsc2','-r300',['PrePostRaster' num2str(i) '.eps']);
close all;
end;
