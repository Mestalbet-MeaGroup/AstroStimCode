
load('DataSetOpto_trim4HA.mat');
CreatePrePostRasterTrimAroundStim(DataSetBase,DataSetStims,4)
set(gcf,'color','none');
maximize(gcf);
print('-depsc2','-r300','Fig3_ShortRaster.eps');
close all;


