function [bs,be]=CalcOnOffsets(trace)
% Function which finds the base around peaks in a 1D trace. 

%----Smooth Trace----%
bs=[]; be=[];
trace=trace';
trace = smooth(trace,15);

%----Create Non-Stationary Threshold----%
sv_trace=filtfilt(savgol(100,1,0),1,trace);
tr=trace-sv_trace;

%----Find Peaks of Activity----%
thr = quantile(tr,10);
thr=thr(9)*1.1;
tr(tr<thr)=0;
thr = quantile(tr,10);
thr = thr(find(thr>0,1,'First'));
tr(tr<thr)=0;
[~,locs] = findpeaks(tr,'MINPEAKHEIGHT',thr,'MINPEAKDISTANCE',45); %Only takes the largest peak in the viscinity. Avoids splitting one burst into two because of interal dynamics. 

%---Find Burst Starts and Ends by Rolling Back/Forward from Peaks---%
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

%---Recursive Roll down hill Functions---% 
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