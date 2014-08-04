fclose('all');clear all; close all;clc;
load('CaSignalPSTH_norm.mat')
for j=1:size(vars,1)
    time = eval(vars{j,1});
    fs = 1/mean(diff(time));
    data1 = misdata(iddata(eval(vars{j,2}),[],1/fs));
    traces=data1.y';
    traces=traces(:,1:end-5);
    time=time(1:end-5)-time(1);
    [dfTraces,dfTime]  = CalcDf_f_PSTH(traces,fs,time);
    for i=1:size(dfTraces,1)
        trace=zscore(dfTraces(i,:))';
        [sdtr,wtr]=pwelch(trace);
        score(i) = trapz(sdtr(1:find(wtr>0.1,1,'First')))/trapz(sdtr(find(wtr>0.9,1,'First'):end));
    end
    clusts = kmeans(score',2);
    if mean(score(clusts==1))>mean(score(clusts==2))
        choose=1;
    else
        choose=2;
    end
%     if j<2
        PSTH_DataSet{j}.traces = traces(clusts==choose,:);
%     else
%         PSTH_DataSet{j}.traces = dfTraces(clusts==choose,:);
%     end
    PSTH_DataSet{j}.time = time;
    clear score;
end
counter=1;
for j=1:size(PSTH_DataSet,2)
    for i=1:size(PSTH_DataSet{j}.traces,1)
        traces_interp(counter,:)=interp1(PSTH_DataSet{j}.time,PSTH_DataSet{j}.traces(i,:),PSTH_DataSet{3}.time,'spline');
        numTraces(counter)=j;
        counter=counter+1;
    end
end
time = PSTH_DataSet{3}.time;
% figure;
% hold on;
% colors = lines(max(numTraces));
% for i=1:size(traces_interp,1)
%     plot(time,zscore(traces_interp(i,:)),'color',colors(numTraces(i),:));
% end
traces_interp(:,1:50)=repmat(traces_interp(:,51),1,50);
for i=1:size(traces_interp,1)
    tri(i,:)=zscore(traces_interp(i,:));
end
imagesc(tri);


hold on;
plot(time_4502-time_4502(1),zscore(var(traces_4502,[],2)./mean(traces_4502,2)))
plot(time_4505-time_4505(1),zscore(var(traces_4505,[],2)./mean(traces_4505,2)))

plot(time_4527R1-time_4527R1(1),zscore(var(traces_4527R1,[],2)./mean(traces_4527R1,2)))
plot(time_4527R2-time_4527R2(1),zscore(var(traces_4527R2,[],2)./mean(traces_4527R2,2)))
plot(time_4527R3-time_4527R3(1),zscore(var(traces_4527R3,[],2)./mean(traces_4527R3,2)))
xlim([0,60])

