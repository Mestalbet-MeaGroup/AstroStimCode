function BurstData=TestErrorForBurstCDF(DataSetBase,DataSetStims);

bursts=[];
prepost=[];
nsbsb=[];
cultId=[];
bw=[];
numspikes=[];
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
            prepost = [prepost,zeros(1,numel(DataSetBase{k}.Trim.bs))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,zeros(1,numel(DataSetBase{k}.Trim.bs))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,numel(DataSetBase{k}.Trim.bs)).*k];
            bw = [bw,DataSetBase{k}.Trim.be-DataSetBase{k}.Trim.bs];
            numspikes = cat(1,numspikes,CountSpikes(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be));
            spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannel(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be));
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
                    prepost = [prepost,zeros(1,numel(bs1))]; % 0 = pre, 1 = post
                    nsbsb   = [nsbsb,ones(1,numel(bs1))]; % 0 = not within superburst, 1 = within superburst
                    cultId  = [cultId,ones(1,numel(bs1)).*k];
                    bw = [bw,be1-bs1];
                    numspikes = cat(1,numspikes,CountSpikes(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1));
                    spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannel(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1));
                end
            end
        end
        
        for i=1:size(Outliers,2)
            k=Outliers(i);
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
            prepost = [prepost,ones(1,numel(DataSetStims{k}.Trim.bs))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,zeros(1,numel(DataSetStims{k}.Trim.bs))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,numel(DataSetStims{k}.Trim.bs)).*k];
            bw = [bw,DataSetStims{k}.Trim.be-DataSetStims{k}.Trim.bs];
            numspikes = cat(1,numspikes,CountSpikes(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be));
            spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannel(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be));
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
                    prepost = [prepost,ones(1,numel(bs1))]; % 0 = pre, 1 = post
                    nsbsb   = [nsbsb,ones(1,numel(bs1))]; % 0 = not within superburst, 1 = within superburst
                    cultId  = [cultId,ones(1,numel(bs1)).*k];
                    bw = [bw,be1-bs1];
                    numspikes = cat(1,numspikes,CountSpikes(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1));
                    spikesPcntMax = cat(1,spikesPcntMax,CountSpikesPerChannel(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1));
                end
            end
        end
        
        BurstData{j,jj}.bw = bw;
        BurstData{j,jj}.numspikes = numspikes;
        BurstData{j,jj}.spikesPcntMax = spikesPcntMax;
        BurstData{j,jj}.prepost = prepost;
        BurstData{j,jj}.nsbsb = nsbsb;
        BurstData{j,jj}.cultId = cultId;
        
    end
    waitbarwithtime(j/numel(perErr),h);
end
save('BurstData_errTestingStarts.mat', 'BurstData');
% save('BurstData_errTestingEnds.mat', 'BurstData');
close(gcf);
%% Plot Results
% %-----Plot Burst Durations------%
% figure;hold on;
% for i=1:3
%     for j=1:3
%         regbw  = BurstData{i,j}.bw(BurstData{i,j}.nsbsb==0); % Outside of SBs
%         sbbw  = BurstData{i,j}.bw(BurstData{i,j}.nsbsb==1); % Inside of SBs
%         [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'./1200); % Convert to ms
%         [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'./1200);
%         %----Baseline----%
%         plot(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
%         %----Stimulation----%
%         plot(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     end
% end
% title('Durations');
% hold off;
% %-----Plot Number of Spikes per Channel-------%
% figure;hold on;
% for i=1:3
%     for j=1:3
%         regfr  = BurstData{i,j}.numspikes(BurstData{i,j}.nsbsb==0); %Outside of SBs
%         sbfr   = BurstData{i,j}.numspikes(BurstData{i,j}.nsbsb==1); %Inside of SBs
%         [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr'); % Convert to ms
%         [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr');
%         %----Baseline----%
%         plot(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
%         %----Stimulation----%
%         plot(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     end
% end
% title('Number of Spikes Per Channel');
% hold off;
% axis('tight');
% 
% %-----Plot Firing Rate------%
% figure;hold on;
% for i=1:3
%     for j=1:3
%         regfr  = BurstData{i,j}.numspikes(BurstData{i,j}.nsbsb==0)./(BurstData{i,j}.bw(BurstData{i,j}.nsbsb==0))'; %Outside of SBs
%         sbfr   = BurstData{i,j}.numspikes(BurstData{i,j}.nsbsb==1)./(BurstData{i,j}.bw(BurstData{i,j}.nsbsb==1))'; %Inside of SBs
%         [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr'.*12000); % Convert to ms
%         [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr'.*12000);
%         %----Baseline----%
%         plot(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
%         %----Stimulation----%
%         plot(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     end
% end
% title('Firing Rate');
% hold off;
% axis('tight');
% %-----Plot Recruitment------%
% figure;hold on;
% for i=1:3
%     for j=1:3
%         regpcnt  = BurstData{i,j}.spikesPcntMax(BurstData{i,j}.nsbsb==0); % Outside of SBs
%         sbpcnt  = BurstData{i,j}.spikesPcntMax(BurstData{i,j}.nsbsb==1); % Inside of SBs
%         [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regpcnt'); % Convert to ms
%         [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbpcnt');
%         %----Baseline----%
%         plot(regCDFx,regCDFy,'ok','MarkerSize',2,'MarkerFaceColor','b','MarkerEdgeColor','b');
%         %----Stimulation----%
%         plot(sbCDFx,sbCDFy,'ok','MarkerSize',2,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     end
% end
% title('Recruitment');
% hold off;
% axis('tight');
% 
end