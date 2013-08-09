function ic = ConvertSamora2IC(vec);
% Function to convert Samora's format into t,ic format. Essentially
% replaces vec (matrix of size (1,numel(t)) with ic where for each spike
% time recorded in t, the appropriate channel ( ic(1,x) ) where this spike was recorded
% is placed in vec
% by: Noah Levine-Small, last modified: 23/10/12
ic(1,:) = unique(vec,'stable');
for i=1:size(ic,2)
    ic(2,i) = 1;
    ic(3,i)=find(vec==ic(1,i),1,'First');
    ic(4,i)=find(vec==ic(1,i),1,'Last');
end

end