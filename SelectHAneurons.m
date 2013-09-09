function [tHA2,icHA2]=SelectHAneurons(t,ic,window,res,bs,be);

wins=1:(window*12):max(t);
conversionTable(1,:) = ic(1,:);
conversionTable(2,:) = 1:length(ic(1,:));

for i=1:(length(wins)-1)
    [tNew,icNew]=RemoveSections(t,ic,0,wins(i));
    [tNew,icNew]=RemoveSections(tNew,icNew,wins(i+1),max(tNew));
    if size(tNew)>res*10
        [Firings]=FindNeuronFrequency(tNew,icNew,res,1); %gives Firings in 1/ms
        Firings=Firings'*1000*60; %normalise to firings per minute
        
        Smean(i,conversionTable(2,ismember(conversionTable(1,:),icNew(1,:))))=mean(Firings);
        Sstd(i,conversionTable(2,ismember(conversionTable(1,:),icNew(1,:))))=std(Firings);
    else
        Smean(i,:)=0;
        Sstd(i,:)=0;
    end
end
temp = Smean;
temp(temp>0)=1;
NumActPeriods=sum(temp,1);
[sorted,ix]=sort(NumActPeriods);
[xData, yData] = prepareCurveData( [], sorted );
% Set up fittype and options.
ft = fittype( 'poly7' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf Inf Inf Inf Inf Inf];
% Fit model to data.
try
    [fitresult, gof] = fit( xData, yData, ft, opts );
catch
    HAelec = FindHAelectrodes(t,ic,bs,be);
    ix=ismember(ic(1,:),HAelec);
    ix = find(ix>0);
    tHA=[];
    icHA=[];
    for i=1:numel(ix)
        t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
        tHA =  [tHA,t1];
        icHA(1,i) = ic(1,ix(i));
        icHA(2,i)=1;
        icHA(3,i)=numel(tHA)-numel(t1)+1;
        icHA(4,i)=numel(tHA);
    end
    tHA2=tHA;
    icHA2=icHA;
    return;
end

coeffvals = coeffvalues(fitresult);
syms x;
f(x) = coeffvals(1)*x^7 + coeffvals(2)*x^6 + coeffvals(3)*x^5 + coeffvals(4)*x^4 + coeffvals(5)*x^3 + coeffvals(6)*x^2 + coeffvals(7)*x + coeffvals(8);
f2 = diff(f);
f2 = diff(f);
inflec_pt = solve(f2);
thresh = max(real(double(inflec_pt)));
ix=ix(ceil(thresh):end);
tHA=[];
for i=1:numel(ix)
    t1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
    tHA =  [tHA,t1];
    icHA(1,i) = ic(1,ix(i));
    icHA(2,i)=1;
    icHA(3,i)=numel(tHA)-numel(t1)+1;
    icHA(4,i)=numel(tHA);
end

if isempty(tHA)
    tHA2=nan;
    icHA2=nan;
else
    HAelec = FindHAelectrodesNoThresh(tHA,icHA,bs,be);
    ix=ismember(icHA(1,:),HAelec);
    ix = find(ix>0);
    tHA2=[]; icHA2=[];
    for i=1:numel(ix)
        t1=sort(tHA(icHA(3,ix(i)):icHA(4,ix(i))));
        tHA2 =  [tHA2,t1];
        icHA2(1,i) = icHA(1,ix(i));
        icHA2(2,i)=1;
        icHA2(3,i)=numel(tHA2)-numel(t1)+1;
        icHA2(4,i)=numel(tHA2);
    end
end
end
