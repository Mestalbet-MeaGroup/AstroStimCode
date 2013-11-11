function [spks,time1] = MakeRaster(t,ic,startframe,endframe)
t=round(t);
numC = size(ic,2);
m=nan(max(t),numC);
starts = ic(3,:);
stops = ic(4,:);
for i=1:numC
    display(stops(i)-starts(i));
    locs = t(starts(i):stops(i));
    m(locs,i)=ic(1,i);
end


numspikes = (endframe-startframe)*2+1;
time1(1:2:numspikes)=startframe:endframe;
time1(2:2:numspikes+1)=startframe:endframe;

spks(1:2:numspikes,:)=m(startframe:endframe,:)-0.5;
spks(2:2:numspikes+1,:)=m(startframe:endframe,:)+0.5;

end