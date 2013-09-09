

for i=1:size(DataSetStims,1)
    figure;
    [SumFirings,Firings] = CreatePeriSBhist(DataSetStims{i}.Trim.t,DataSetStims{i}.sbs,DataSetStims{i}.sbe);
%     title(['Culture ' num2str(i)]);
    set(findall(gcf,'-property','FontSize'),'FontSize',16);
    maximize(gcf);
    set(gcf,'color','none');
%     plot2svg(['PeriSBhist' num2str(i) '.svg'], gcf,'png');
    export_fig(['PeriSBhist' num2str(i) '.pdf']);
    close all;
end
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);

for i=1:size(DataSetStims,1)
    subplot(4,4,i)
    img = imread(['PeriSBhist' num2str(i) '.png']);
    imshow(img,[]);
end