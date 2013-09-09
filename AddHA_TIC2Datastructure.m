fclose('all');clear all; close all;clc;
load('DataSetOpto_Trim3_reordered.mat')
h = waitbarwithtime(0,'Please Wait...');
for i=1:size(DataSetBase,1)
    [DataSetBase{i}.Trim.tHA,DataSetBase{i}.Trim.icHA]=SelectHAneurons(DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic,3000,50,DataSetBase{i}.Trim.bs,DataSetBase{i}.Trim.be);
    [DataSetStims{i}.Trim.tHA,DataSetStims{i}.Trim.icHA]=SelectHAneurons(DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic,3000,50,DataSetStims{i}.Trim.bs,DataSetStims{i}.Trim.be);
    waitbarwithtime(i/size(DataSetBase,1),h);
end


fclose('all');clear all; close all;clc;
load('DataSetOpto_Trim3_reordered.mat')
h = waitbarwithtime(0,'Please Wait...');
for i=1:size(DataSetBase,1)
    [DataSetBase{i}.Trim.tHA,DataSetBase{i}.Trim.icHA]=CalcFracSpikesInBursts(DataSetBase{i}.Trim.t,DataSetBase{i}.Trim.ic,DataSetBase{i}.Trim.bs,DataSetBase{i}.Trim.be);
    [DataSetStims{i}.Trim.tHA,DataSetStims{i}.Trim.icHA]=CalcFracSpikesInBursts(DataSetStims{i}.Trim.t,DataSetStims{i}.Trim.ic,DataSetStims{i}.Trim.bs,DataSetStims{i}.Trim.be);
    waitbarwithtime(i/size(DataSetBase,1),h);
end