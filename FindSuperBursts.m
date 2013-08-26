j=11;
[~,fr]=FindNeuronFrequency(DataSetBase{j}.t,DataSetBase{j}.ic,500,1);   
fr= [-1*fr([end:-1:1]),fr,-1*fr];
f = savgol(10,1,0);
fr = filtfilt(f,1,fr);
fr = filtfilt(MakeGaussian(0,50,60),1,fr);
fr=fr(end/3:2*end/3);
[locs, peakMag] = peakfinder(fr);
thresh = 0.5*mean(peakMag);

fr=fr';

% y = medfilt1(diff(fr),5); y = medfilt1(y,3);
y = cummag(diff(fr));
onset = CalcCaOnsets(y);
onsets=[];
for i=1:length(onset)
    if fr(onset(i))<thresh
        onsets=[onsets;onset(i)];
    end
end
% onsets=FindOnsets(locs(i),y(locs(i):end))



plot(fr)
hold on;
plot(peakLoc,peakMag,'.r');
plot(onsets,fr(onsets),'.k');
plot(y);
plot(ones(length(fr),1).*thresh,'-.k');