
% [DataSetStims,DataSetBase]=SepStimFromBase(DataSet);
for i=1:size(DataSetBase,1)
    CreatePrePostRaster(DataSetBase,DataSetStims,i);
    maximize(gcf);
    set(gcf,'color','w');
    eval(['export_fig ' 'PrePostRasterRhod3' num2str(i) '.png;']);
%     eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'PrePostRaster' num2str(i) '.png'');']);
    close all;
end

for i=1:size(DataSetBase,1)
    CreatePrePostRasterTrim(DataSetBase,DataSetStims,i);
    maximize(gcf);
    set(gcf,'color','w');
    eval(['export_fig ' 'PrePostRasterTrim' num2str(i) '.png;']);
%     eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'PrePostRaster' num2str(i) '.png'');']);
    close all;
end

for i=1:size(DataSetBase,1)
    figure;
    CreatePrePostRasterTrimHA(DataSetBase,DataSetStims,i);
    maximize(gcf);
    set(gcf,'color','none');
    eval(['export_fig ' 'PrePostRasterTrimHA' num2str(i) '.png;']);
%     eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'PrePostRaster' num2str(i) '.png'');']);
    close all;
end