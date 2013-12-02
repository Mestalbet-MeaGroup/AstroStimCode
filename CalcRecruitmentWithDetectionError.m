function recruitment=CalcRecruitmentWithDetectionError(DataSetBase,DataSetStims);

spikesPcntMax=[];
Outliers = 1:size(DataSetBase,1);
%-----------Optimal Settings: Burst Within Superburst Set Selection------------%
trim    = [1:4,12];
whole   = [7,9,10];
special = [5,6,13];
dpass   = [1,4,12,13]; %fed to burst detection with superburst to run a second pass
options.choose = zeros(15,1);
options.choose(trim)=1;
options.choose(special)=2;

%% Calculate burst statistics for error in regular burst start
% perErr=0:0.01:0.5;
% prob=0:0.05:0.3;
perErr=0:0.25:0.5;
prob=0:0.15:0.3;
prob = repmat(prob,numel(perErr),1);
h = waitbarwithtime(0,'Please Wait...');
for j=1:numel(perErr)
    for jj=1:size(prob,2)
        
        for i=1:size(Outliers,2)
            k=Outliers(i);
            %--------------Introduce Error---------------%
            which  = binornd(ones(1,numel(DataSetBase{k}.Trim.bs)),prob(j,jj));
            addOrSub=randi([0 1],numel(DataSetBase{k}.Trim.bs),1);
            addOrSub(addOrSub==0)=-1;
            which = which.*addOrSub';
            change = perErr(j)*(DataSetBase{k}.Trim.be-DataSetBase{k}.Trim.bs).*which;
            %---------To Burst Start-----------%
            DataSetBase{k}.Trim.bs=DataSetBase{k}.Trim.bs+change;
            %---------To Burst End-----------%
            %             DataSetBase{k}.Trim.be=DataSetBase{k}.Trim.be+change;
            %----------End of Error Introduction--------%
            spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannelq(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be));
            if ~isempty(DataSetBase{k}.sbs)
                for kk=1:numel(DataSetBase{k}.sbs)
                    switch options.choose(k)
                        case 0
                            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
                        case 1
                            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
                        case 2
                            [bs1,be1] = FindBurstsWithinSBs_special(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk),k,kk,'base',sum(k==dpass));
                    end
                    which1  = binornd(ones(1,numel(bs1)),prob(j,jj));
                    addOrSub1=randi([0 1],numel(bs1),1);
                    addOrSub1(addOrSub1==0)=-1;
                    which1 = which1.*addOrSub1';
                    change1 = perErr(j)*(be1-bs1).*which1;
                    bs1=bs1+change1;
                    %                     be1=be1+change1;
                    spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannelq(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1));
                end
            end
            
            if ~isempty(DataSetStims{k}.Trim.bs)
                %--------------Introduce Error---------------%
                which  = binornd(ones(1,numel(DataSetStims{k}.Trim.bs)),prob(j,jj));
                addOrSub=randi([0 1],numel(DataSetStims{k}.Trim.bs),1);
                addOrSub(addOrSub==0)=-1;
                which = which.*addOrSub';
                change = perErr(j)*(DataSetStims{k}.Trim.be-DataSetStims{k}.Trim.bs).*which;
                %---------To Burst Start-----------%
                DataSetStims{k}.Trim.bs=DataSetStims{k}.Trim.bs+change;
                %---------To Burst End-----------%
                %                 DataSetStims{k}.Trim.be=DataSetStims{k}.Trim.be+change;
                %----------End of Error Introduction--------%
            end
            spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannelq(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be));
            if ~isempty(DataSetStims{k}.sbs)
                for kk=1:numel(DataSetStims{k}.sbs)
                    switch options.choose(k)
                        case 0
                            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
                        case 1
                            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
                        case 2
                            [bs1,be1] = FindBurstsWithinSBs_special(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk),k,kk,'Stims',sum(k==dpass));
                    end
                    which1  = binornd(ones(1,numel(bs1)),prob(j,jj));
                    addOrSub1=randi([0 1],numel(bs1),1);
                    addOrSub1(addOrSub1==0)=-1;
                    which1 = which1.*addOrSub1';
                    change1 = perErr(j)*(be1-bs1).*which1;
                    bs1=bs1+change1;
                    %                     be1=be1+change1;
                    spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannelq(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1));
                end
            end
        end
        
        recruitment{j,jj} = spikesPcntMax;
        
    end
    waitbarwithtime(j/numel(perErr),h);
end
end
