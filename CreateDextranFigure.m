subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.01 0.01]);
DataSet=CreateDextranDataSet();
tittext = {'470 nm Stimulation', 'Next Day Baseline/Dark','Baseline/Dark + Dextran','470nm Stim + Dextran','Next Day, post wash, Baseline','470 nm Stimulation'};
for i=1:6
    
    if i==1
        subplot(2,6,i)
        start = min(DataSet{i}.Trim.t)+10*60*12000;
        stop = min(DataSet{i}.Trim.t)+20*60*12000;
        PlotRasterNoah(DataSet{i}.Trim.t,DataSet{i}.Trim.ic,start,stop)
        title(tittext{i})
        subplot(2,6,i+6)
        plot(DataSet{i}.Trim.time(find(DataSet{i}.Trim.time>start/12000,1,'First')-1:find(DataSet{i}.Trim.time>stop/12000,1,'First'))-DataSet{i}.Trim.time(find(DataSet{i}.Trim.time>start/12000,1,'First')-1),...
            DataSet{i}.Trim.gfr(find(DataSet{i}.Trim.time>start/12000,1,'First')-1:find(DataSet{i}.Trim.time>stop/12000,1,'First')));
        axis('tight');
    else
        subplot(2,6,i)
        start = min(DataSet{i}.Trim.t);
        stop = min(DataSet{i}.Trim.t)+10*60*12000;
        PlotRasterNoah(DataSet{i}.Trim.t,DataSet{i}.Trim.ic,start,stop);
        title(tittext{i})
        subplot(2,6,i+6)
        plot(DataSet{i}.Trim.time(find(DataSet{i}.Trim.time>start/12000,1,'First')-1:find(DataSet{i}.Trim.time>stop/12000,1,'First'))-DataSet{i}.Trim.time(find(DataSet{i}.Trim.time>start/12000,1,'First')-1),...
            DataSet{i}.Trim.gfr(find(DataSet{i}.Trim.time>start/12000,1,'First')-1:find(DataSet{i}.Trim.time>stop/12000,1,'First')));
        axis('tight');
    end
end

figure;
temp=0;
hold all;
for i=1:6
    time = DataSet{i}.Trim.time+temp+100;
    temp=max(time);
    gfr = DataSet{i}.Trim.gfr;
    plot(time,gfr,'.-');
end

