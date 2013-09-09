function [Smean,Sstd]=PieceWiseActivity(t,ic,window,res);

wins=1:(window*12):max(t);
conversionTable(1,:) = ic(1,:);
conversionTable(2,:) = 1:length(ic(1,:));

parfor i=1:(length(wins)-1)
    [tNew,icNew]=RemoveSections(t,ic,0,wins(i));
    [tNew,icNew]=RemoveSections(tNew,icNew,wins(i+1),max(tNew));
    if ~isempty(tNew)
        [Firings]=FindNeuronFrequency(tNew,icNew,res,1); %gives Firinings in 1/ms
        Firings=Firings'*1000*60; %normalizez to firings per minute
        
        Smean(i,conversionTable(2,ismember(conversionTable(1,:),icNew(1,:))))=mean(Firings);
        Sstd(i,conversionTable(2,ismember(conversionTable(1,:),icNew(1,:))))=std(Firings);
    else
        Smean(i,:)=zeros(1,size(ic,2));
        Sstd(i,:)=zeros(1,size(ic,2));
    end
end
temp = Smean;
temp(temp>0)=1;
NumActPeriods=sum(temp,1);
end

syms x;
a =       18.04  ;
b =    0.005373  ;
c =   1.557e-06  ;
d =     0.07752  ;
f(x) = a*exp(b*x) + c*exp(d*x);
f2 = diff(f);
f2 = diff(f);
inflec_pt = solve(f2);
double(inflec_pt)

syms x;
p1 =   6.753e-13;
p2 =   -4.79e-10;
p3 =    1.34e-07;
p4 =  -1.859e-05;
p5 =     0.00129;
p6 =    -0.03718;
p7 =       0.413;
p8 =       8.848;
f(x) = p1*x^7 + p2*x^6 + p3*x^5 + p4*x^4 + p5*x^3 + p6*x^2 + p7*x + p8;
f2 = diff(f);
f2 = diff(f);
inflec_pt = solve(f2);
double(inflec_pt)