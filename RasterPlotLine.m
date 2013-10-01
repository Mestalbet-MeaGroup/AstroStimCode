function RasterPlotLine(t,ic,winStart,winEnd)
% Does not work

numC= size(ic,2);
t=floor(t);


m=nan(max(t),numC);

starts = ic(3,:);
stops = ic(4,:);
for i=1:numC
    locs = t(starts(i):stops(i));
    m(locs,i)=ic(1,i);
end

numspikes = (endframe-startframe)*2+1;
time1(1:2:numspikes)=1:numspikes;
time1(2:2:numspikes+1)=1:numspikes;

spks(1:2:numspikes,:)=m(1:numspikes,:)-0.5;
spks(2:2:numspikes+1,:)=m(1:numspikes,:)+0.5;
clear m;
plot(time1,spks,'k');
xlim([winStart;winEnd]);
end