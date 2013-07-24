function [DataSetStims,DataSetBase]=SepStimFromBase(DataSet);
counter=1;
for i=1:size(DataSet,1)
    if DataSet{i}.stim==1
        stimInd(counter)=i;
        counter=counter+1;
    end
end
DataSetStims = DataSet(stimInd);
% PSstims = PS(stimInd);
counter=1;
for i=1:size(DataSet,1)
    if DataSet{i}.base==1
        stimBase(counter)=i;
        counter=counter+1;
    end
end
DataSetBase = DataSet(stimBase);
% PSbase = PS(stimBase);

% There are 5 out of the 20 experiments that don't superburst. Of those,
% some don't look healthy (i=8,12,13,14,15,16,19). 

% There are 5 out of the 14 experiments that superburst in the bas4eline (i=5,7,9,13,14)
end