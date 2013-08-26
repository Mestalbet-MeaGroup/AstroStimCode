function [SumFirings,Firings] = CreatePeriSBhist(t,sbs,sbe);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
t=sort(t);
f = savgol(10,1,0);
if numel(sbs)>0
for i=1:numel(sbs)
    
    start = find(t>=(sbs(i)),1,'First');
    if start<=0
        start=1;
    end
    
     stop  = find(t<=sbe(i),1,'Last');
    
    t1 = t(start:stop);
    frB = histc(t1,t(start):5:t(stop));
    frtemp1{i} = frB;
    frtemp{i} = filtfilt(f,1,frB);
    frtemp{i} = filtfilt(MakeGaussian(0,30,120),1,frtemp{i});
end
sz=cellfun(@numel,frtemp);
Firings=zeros(max(sz),numel(sbs));
for i=1:numel(sbs);
    Firings(1:numel(frtemp{i}),i)=frtemp{i};
end

for i=1:size(Firings,2)
    locs=CalcCaOnsets(Firings(:,i));
    starts(i) = locs(2);
end
dev=min(starts);
clear firings;
for i=1:numel(sbs); sz(i) = numel(frtemp1{i});end
Firings=zeros(max(sz),numel(sbs));
for i=1:numel(sbs);
    Firings(1:numel(frtemp1{i}),i)=frtemp1{i};
end

subplot(4,1,1:3);
hold on;
plot(Firings(starts(1)-dev+1:end,1));
offset=0;
for i=2:size(Firings,2)
    offset = offset+max(Firings(:,i-1));
    plot(Firings(starts(i)-dev+1:end,i)+offset);
end
hold off;
set(gca,'FontSize',16);
set(gca,'XTick',[],'XTickLabel',[]);
for i=1:size(Firings,2)
FRtemp{i} = Firings(starts(i)-dev+1:end,i);
end
SumFirings = zeros(max(cellfun(@numel,FRtemp)),1);
for i=1:size(Firings,2)
SumFirings(1:length(FRtemp{i}),i) = FRtemp{i};
end
SumFirings = sum(SumFirings,2);
subplot(4,1,4);
bar(SumFirings);
set(gca,'XTick',linspace(0,length(SumFirings),6),'XTickLabels',round((linspace(0,length(SumFirings),6)./12000)*100)/100,'FontSize',16);
xlabel('Time [Sec]','FontSize',16);

else
    SumFirings=[];
    Firings=[];
    display('No Superbursts');
end
