function BurstData = GenerateBurstData(DataSetBase,DataSetStims,MeaMap);
% Function which takes burst information and creates a propagation map and
% then searches for clusters using a genetic algorithm and kmeans.
%% Initialize variables
% subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
% culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
% cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
%     [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
%     [culTypes{3} '(1)'] [culTypes{3} '(2)']...
%     [culTypes{4} '(1)'] [culTypes{4} '(2)'] [culTypes{4} '(3)'] [culTypes{4} '(4)']};
bursts=[];
prepost=[];
nsbsb=[];
cultId=[];
bw=[];
numspikes=[];
%------------Choose Cultures to Analyze-----------%
% Outliers=8;
% Outliers = 1:2;
% Outliers = [7,8,11,12,13];
% Outliers = 1:13;
% Outliers([7,8,11,12,13])=[];
Outliers = 1:size(DataSetBase,1);
%% Calculate burst propagation maps from t,ic of bursts
for i=1:size(Outliers,2)
    k=Outliers(i);
    m=CalcBurstPropogation(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,zeros(1,size(m,3))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,3))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,3)).*k];
    bw = [bw,DataSetBase{k}.Trim.be-DataSetBase{k}.Trim.bs];
    numspikes = cat(1,numspikes,CountSpikes(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be));
    if ~isempty(DataSetBase{k}.sbs)
        for kk=1:numel(DataSetBase{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk));
            m1 = CalcBurstPropogation(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1,MeaMap);
            bursts  =  cat(3,bursts,m1);
            prepost = [prepost,zeros(1,size(m1,3))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,3))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,3)).*k];
            bw = [bw,be1-bs1];
            numspikes = cat(1,numspikes,CountSpikes(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1));
        end
    end
end

for i=1:size(Outliers,2)
    k=Outliers(i);
    m = CalcBurstPropogation(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,ones(1,size(m,3))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,3))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,3)).*k];
    bw = [bw,DataSetStims{k}.Trim.be-DataSetStims{k}.Trim.bs];
    numspikes = cat(1,numspikes,CountSpikes(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be));
    if ~isempty(DataSetStims{k}.sbs)
        for kk=1:numel(DataSetStims{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk));
            m1 = CalcBurstPropogation(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1,MeaMap);
            bursts  =  cat(3,bursts,m1);
            prepost = [prepost,ones(1,size(m1,3))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,3))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,3)).*k];
            bw = [bw,be1-bs1];
            numspikes = cat(1,numspikes,CountSpikes(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1));
        end
    end
end


BurstData.bursts = bursts;
BurstData.bw = bw;
BurstData.numspikes = numspikes;
BurstData.prepost = prepost;
BurstData.nsbsb = nsbsb;
BurstData.cultId = cultId;

end
% 
% spikesPre=[];
% spikesPost=[];
% for i=1:size(Outliers,2)
%     k=Outliers(i);
%      prepost=BurstData.prepost(BurstData.cultId==k); 
%      numspikes=BurstData.numspikes(BurstData.cultId==k,:);
%      spikesPre = [spikesPre;nansum(numspikes(prepost==0,:),2)];
%      spikesPost =[spikesPost;nansum(numspikes(prepost==1,:),2)];
% end