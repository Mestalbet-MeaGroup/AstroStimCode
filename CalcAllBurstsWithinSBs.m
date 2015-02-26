fclose('all');clear all; close all;clc;
load('DataSetOpto_trim4HA.mat');
trim    = [1:4,12];
whole   = [7,9,10];
special = [5,6,13];
dpass   = [1,4,12,13]; %fed to burst detection with superburst to run a second pass
options.choose = zeros(15,1);
options.choose(trim)=1;
options.choose(special)=2;
for k=1:size(DataSetBase,1)
    DataSetBase{k}.sb_bs=[];
    DataSetBase{k}.sb_be=[];
    DataSetStims{k}.sb_bs=[];
    DataSetStims{k}.sb_be=[];
    if ~isempty(DataSetBase{k}.sbs)
        clear bs1; clear be1;
        for kk=1:numel(DataSetBase{k}.sbs)
            switch options.choose(k)
                case 0
                    [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
                case 1
                    [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
                case 2
                    [bs1,be1] = FindBurstsWithinSBs_special(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
            end
            DataSetBase{k}.sb_bs=[DataSetBase{k}.sb_bs,bs1-DataSetBase{k}.sbs(kk)];
            DataSetBase{k}.sb_be=[DataSetBase{k}.sb_be,be1-DataSetBase{k}.sbs(kk)];
        end
        
    end
    if ~isempty(DataSetStims{k}.sbs)
        clear bs2; clear be2;
        for kk=1:numel(DataSetStims{k}.sbs)
            switch options.choose(k)
                case 0
                    [bs2,be2] = FindBurstsWithinSBs(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
                case 1
                    [bs2,be2] = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
                case 2
                    [bs2,be2] = FindBurstsWithinSBs_special(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
            end
            DataSetStims{k}.sb_bs=[DataSetStims{k}.sb_bs,bs2-DataSetStims{k}.sbs(kk)];
            DataSetStims{k}.sb_be=[DataSetStims{k}.sb_be,be2-DataSetStims{k}.sbs(kk)];
        end
        
    end
end
clear_all_but('DataSetStims','DataSetBase');