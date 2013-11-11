function [bs,be]=CalcOnOffsets(trace)
%
bs=[]; be=[];
trace=trace';
locs = peakfinder(trace);

for i=1:size(locs,1)-1
    
    bs(i)  = RollDownBack(trace,locs(i));
    be(i)  = RollDownFront(trace,locs(i));
    
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