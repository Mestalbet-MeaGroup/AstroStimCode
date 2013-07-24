
[DataSetStims,DataSetBase]=SepStimFromBase(DataSet);
for i=1:size(DataSetBase,1)
    CreatePrePostRaster(DataSetBase,DataSetStims,i);
    maximize(gcf);
    set(gcf,'color','w');
    eval(['export_fig ' 'PrePostRaster' num2str(i) '.png;']);
%     eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'PrePostRaster' num2str(i) '.png'');']);
%     close all;
end