function lowFR = FindLowFRelectrodes(t,ic,bs,be);
% Finds the maximum consecutive times a channel does not participate in
% network bursts
lowFR=[];
for i=1:size(ic,2)
    t1=sort(t(ic(3,i):ic(4,i)));
    inB=0;
    for j=1:numel(bs)
        inB(j) = sum(t1>bs(j) & t1<be(j));
    end
    [a,b]=initfin([1 inB 1]);
    duration = a(2:end)-b(1:end-1)-1;
    if ~isempty(duration)
        lowFR(i)=max(duration);
    else
        lowFr(i)=0;
    end
    
end
