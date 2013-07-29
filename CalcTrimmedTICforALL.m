for i=1:13
    [DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic,DataSetBase{i}.Trim.bs,DataSetBase{i}.Trim.be,DataSetBase{i}.Trim.bw] = SortChannelsByFR(DataSetBase{i}.t,DataSetBase{i}.ic,DataSetBase{i}.bs,DataSetBase{i}.be,DataSetBase{i}.bw);
    [DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic,DataSetStims{i}.Trim.bs,DataSetStims{i}.Trim.be,DataSetStims{i}.Trim.bw] = SortChannelsByFR(DataSetStims{i}.t,DataSetStims{i}.ic,DataSetStims{i}.bs,DataSetStims{i}.be,DataSetStims{i}.bw);
end

