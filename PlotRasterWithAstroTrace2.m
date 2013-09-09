function PlotRasterWithAstroTrace2(t,ic,time,traces,startframe,endframe)
%function PlotRasterWithAstroTrace2(t,ic,time,traces,startframe,endframe,tr,time1)

%Create matrix
numC= size(ic,2);
numT = size(traces,2);
t=floor(t);
m=nan(max(t),numC);

scale = round(numC/numT);
i=1;
startT=find(time*12000<startframe,1,'Last');
endT=find(time*12000<endframe,1,'Last');
time = time(startT-100:endT+100);
traces=traces(startT-100:endT+100,:);
traces(:,i) = ( traces(:,i) -min(traces(:,i)) )/ (max(traces(:,i)) - min(traces(:,i)));

traces(:,i) = traces(:,i)*scale;
% tr(:,i) = ( tr(:,i) -min(tr(:,i)) )/ (max(tr(:,i)) - min(tr(:,i)));
% tr(:,i) = tr(:,i).*scale;
for i=2:numT
    traces(:,i) = ( traces(:,i) -min(traces(:,i)) )/ (max(traces(:,i)) - min(traces(:,i)));
    traces(:,i) = traces(:,i).*scale+max(traces(:,i-1));
    
%     tr(:,i) = ( tr(:,i) -min(tr(:,i)) )/ (max(tr(:,i)) - min(tr(:,i)));
%     tr(:,i) = tr(:,i).*scale+max(tr(:,i-1));
end

starts = ic(3,:);
stops = ic(4,:);
for i=1:numC
    locs = t(starts(i):stops(i));
    m(locs,i)=ic(1,i);
end


numspikes = (endframe-startframe)*2+1;
time1(1:2:numspikes)=startframe:endframe;
time1(2:2:numspikes+1)=startframe:endframe;

spks(1:2:numspikes,:)=m(startframe:endframe,:)-0.5;
spks(2:2:numspikes+1,:)=m(startframe:endframe,:)+0.5;
clear m;

hold on;
plot(time1,spks,'k');
% plot(startframe:endframe,m(startframe:endframe,:),'.k');
% for j=1:numC
% % plotanymarker(startframe:endframe,m(startframe:endframe,j),'!');
% end
plot(time*12000,traces,'-b','LineWidth',1);
% plot(time1*12000,tr,'-r');
set(gca,'Xlim',[startframe,endframe],'YLim',[0 numC],'YTickLabel',[],'XTick', linspace(startframe,endframe,10),'XTickLabel',round((linspace(startframe,endframe,10)-startframe)./12000));
for i=1:numT
text(endframe,traces(end,i),['Astrocyte ' num2str(i)]);
end

end