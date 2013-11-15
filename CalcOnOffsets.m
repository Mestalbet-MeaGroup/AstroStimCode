function [bs,be]=CalcOnOffsets(trace)
%
bs=[]; be=[];
trace=trace';
trace = smooth(trace,15);
sv_trace=filtfilt(savgol(100,1,0),1,trace);
tr=trace-sv_trace;
% tr1=tr;
thr = quantile(tr,10);
thr=thr(9)*1.1;
tr(tr<thr)=0;
thr = quantile(tr,10);
thr = thr(find(thr>0,1,'First'));
tr(tr<thr)=0;
[~,locs] = findpeaks(tr,'MINPEAKHEIGHT',thr,'MINPEAKDISTANCE',45);

% thr2 = quantile(pks,10);
% locs(pks<thr2(2))=[];
for i=1:size(locs,1)-1
    
    bs(i)  = RollDownBack(tr,locs(i));
%     be(i)  = RollDownFront(trace,locs(i));
    betry = find(trace(locs(i):end)==0,1,'First')+locs(i);
    if isempty(betry)
        be(i)  = RollDownFront(trace,locs(i));
    else
        be(i)=betry;
    end
    
end

    function loc = RollDownBack(trace,loc)
        
        if (loc>1)
            if (trace(loc)>trace(loc-1))
                loc = RollDownBack(trace,loc-1);
            end
        else
            return;
        end
        
    end
    function loc = RollDownFront(trace,loc)
        
        if (loc<length(trace)-1)
            if (trace(loc)>trace(loc+1))
                loc = RollDownFront(trace,loc+1);
            end
        else
            return;
        end
        
    end
end