
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
for i=1:size(DataSetStims,1)
   figure;
    [SumFirings,Firings] = CreatePeriSBhist(DataSetStims{i}.Trim.t,DataSetStims{i}.sbs,DataSetStims{i}.sbe);
    title(['Culture ' num2str(i)]);
end