function CalcPlotLogHistBW(bwpre,bwpost)

bins=logspace(1, round(log10(max([bwpre,bwpost])))+1,30);
for i=1:length(bins)-1
 prebwHist(i)=size(bwpre(bwpre>=bins(i)&bwpre<=bins(i+1)),2);
 postbwHist(i)=size(bwpost(bwpost>=bins(i)&bwpost<=bins(i+1)),2);
end
a=diff(bins);
% prebwHist=prebwHist./a;
% postbwHist=postbwHist./a;

loglog(bins(2:end),prebwHist+eps,'-.k','MarkerSize',12);
hold on
loglog(bins(2:end),postbwHist+eps,'-.r','MarkerSize',12);
hold off
title('Burst Widths');
end