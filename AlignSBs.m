function rFirings = AlignSBs(t,sbs,sbe);
% rFirings = AlignSBs(DataSetStims{i}.Trim.t,DataSetStims{i}.sbs,DataSetStims{i}.sbe);
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
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
    
    
    offset=0;% Y offset (to plot on top)
    rFirings = zeros(size(Firings,1)-dev+100,size(Firings,2));
    temp = Firings(starts(1)-dev+1:end,1);
    rFirings(100:numel(temp)+99,1) = temp;
    for i=2:size(Firings,2)
        %             offset = offset+max(Firings(:,i-1));
        temp  = Firings(starts(i)-dev+1:end,i)+offset;
        rFirings(100:numel(temp)+99,i) = temp;
    end
    hold on;
    alignFR = rFirings(1:5000,:);
    plot(rFirings(:,1),'b');
    
    for i=2:size(alignFR,2)
        [corr,lags]=xcorr(alignFR(:,i),alignFR(:,1)+alignFR(:,end));
        offset = offset+max(rFirings(:,i-1));
        lag = lags(corr==max(corr));
        lag = lag(1);
        if lag>0
            fr2plot = padarray(rFirings(:,i),lag,min(rFirings(:,i)),'post');
        else
            lag=abs(lag);
            fr2plot = padarray(rFirings(:,i),lag,min(rFirings(:,i)),'pre');
        end
        plot(fr2plot+offset,'b');
    end
    set(gca,'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);
    ylim([-1 max(rFirings(:))+offset]);
    
    SumFirings = sum(rFirings,2);
    findstop=diff(SumFirings);
    findstop = abs(findstop); thresh=mean(findstop)+std(findstop); [~,b]=findpeaks(findstop,'MinPeakHeight',thresh);
%     set(gca,'XTick',round(linspace(0,length(SumFirings),6)),'XTickLabel',round((linspace(0,length(SumFirings),6)./12000)),'box','off','TickDir','out');
    stepsize=24000;
    set(gca,'XTick',0:stepsize:length(SumFirings),'XTickLabel',round([0:stepsize:length(SumFirings)]./12000),'box','off','TickDir','out');
    xlim([0,b(end)*1.1]);
    xlabel('time [Sec]');
    set(findall(gcf,'-property','FontSize'),'FontUnits','pixels','FontSize',38);
end