for i=1:size(DataSet,1)
    [DataSet{i}.sbs,DataSet{i}.sbe] = ManualSuperBurstSelection(DataSet{i}.t,DataSet{i}.ic);
end

save('DataSetOpto.mat','DataSet','-v7.3');

