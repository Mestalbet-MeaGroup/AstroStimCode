base=[];
for i=1:size(DataSetBase,1)
    base = [base,numel(DataSetBase{i}.sbw)/(max(DataSetBase{i}.t)/(12000*60))];
end

stim=[];
for i=1:size(DataSetStims,1)
    stim = [stim,numel(DataSetStims{i}.sbw)/(max(DataSetStims{i}.t)/(12000*60))];
end

bar([base;stim]','Stack');
ylabel('Superburst per minute','FontSize',18)
xlabel('Cultures','FontSize',18);
% legend('Baseline','Stimulation');
set(gca,'FontSize',16);
maximize(gcf);
set(gcf,'color','w');
export_fig 'SuperBurstIncidenceBarChart.png'
% eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'SuperBurstIncidenceBarChart' '.png'');']);