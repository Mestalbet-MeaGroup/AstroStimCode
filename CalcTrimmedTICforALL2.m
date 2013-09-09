%% Run Trimming and re-burst detection on trimmed t,ic on full dataset
% fclose('all');clear all; close all;clc;
% load('DataSetOpto.mat', 'DataSetBase', 'DataSetStims')
% DataSetBase{1}.sbs=[];DataSetBase{1}.sbe=[];DataSetBase{1}.sbw=[];
h = waitbarwithtime(0,'Please Wait...');
for i=1:13
    [t,ic,DataSetBase{i}.Trim.bs,DataSetBase{i}.Trim.be,DataSetBase{i}.Trim.bw] = SortChannelsByFR2(DataSetBase{i}.t,DataSetBase{i}.ic,DataSetBase{i}.bs,DataSetBase{i}.be,DataSetBase{i}.bw);
    for j=1:numel(DataSetBase{i}.sbs)
        delete = find( (DataSetBase{i}.Trim.bs>=DataSetBase{i}.sbs(j)) & (DataSetBase{i}.Trim.bs<DataSetBase{i}.sbe(j)) );
        DataSetBase{i}.Trim.bs(delete)=[];
        DataSetBase{i}.Trim.be(delete)=[];
        DataSetBase{i}.Trim.bw(delete)=[];
    end
    [DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic] = OnlyNonHA(t,ic,[DataSetBase{i}.Trim.bs,DataSetBase{i}.sbs],[DataSetBase{i}.Trim.be,DataSetBase{i}.sbe]);

    [t,ic,DataSetStims{i}.Trim.bs,DataSetStims{i}.Trim.be,DataSetStims{i}.Trim.bw] = SortChannelsByFR2(DataSetStims{i}.t,DataSetStims{i}.ic,DataSetStims{i}.bs,DataSetStims{i}.be,DataSetStims{i}.bw);
    for j=1:numel(DataSetStims{i}.sbs)
        delete = find( (DataSetStims{i}.Trim.bs>=DataSetStims{i}.sbs(j)) & (DataSetStims{i}.Trim.bs<DataSetStims{i}.sbe(j)) );
        DataSetStims{i}.Trim.bs(delete)=[];
        DataSetStims{i}.Trim.be(delete)=[];
        DataSetStims{i}.Trim.bw(delete)=[];
    end
    [DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic] = OnlyNonHA(t,ic,[DataSetStims{i}.Trim.bs,DataSetStims{i}.sbs],[DataSetStims{i}.Trim.be,DataSetStims{i}.sbe]);
    waitbarwithtime(i/13,h);
end

%% Burst Detection Verification
i=1;
j=4;
% PlotRasterWithBursts(DataSetBase{j}.Trim.t,DataSetBase{j}.Trim.ic,DataSetBase{j}.Trim.bs,DataSetBase{j}.Trim.be);
PlotRasterWithBursts(DataSetStims{j}.Trim.t,DataSetStims{j}.Trim.ic,DataSetStims{j}.Trim.bs,DataSetStims{j}.Trim.be);
