function [rankb,ranks,h,meanB,meanS,groupExpb,groupExps] = CalcRankinBurstsStimSit(DataSetBase,DataSetStims)
% Function which calculates the ranks order of channels in a burst (the
% order which they fire)

load('MeaMapPlot.mat', 'MeaMap');

StimSite(1) =nan;
StimSite(2) =nan;
StimSite(3) =13;
StimSite(4) =94;
StimSite(5) =150;
StimSite(6) =95;
StimSite(7) =138;
StimSite(8) =228;
StimSite(9) =nan;
StimSite(10) =nan;
StimSite(11) =nan;
StimSite(12) =49;
StimSite(13) =nan;
rankb=[];
ranks=[];
groupExpb=[];
groupExps=[];
vec =find(~isnan(StimSite));

for i=1:numel(vec)
    tb = DataSetBase{vec(i)}.Trim.t;
    icb = DataSetBase{vec(i)}.Trim.ic;
    bsb = DataSetBase{vec(i)}.Trim.bs;
    beb = DataSetBase{vec(i)}.Trim.be;
    ts = DataSetStims{vec(i)}.Trim.t;
    ics = DataSetStims{vec(i)}.Trim.ic;
    bss = DataSetStims{vec(i)}.Trim.bs;
    bes = DataSetStims{vec(i)}.Trim.be;
    
    sobase=FindSpikeOrders(tb,icb,bsb,beb);
    sostim=FindSpikeOrders(ts,ics,bss,bes);
    
    [x,y]=FindNeighboringElectrodes(MeaMap,StimSite,vec(i));
    setSite = unique(MeaMap(x,y));
    
    for j=1:size(sobase,2);
        temp = find(ismember(sobase(:,j),setSite))./numel(sobase(:,j));
        rankb = [rankb;temp];
        groupExpb = [groupExpb;ones(size(temp)).*i];
    end
    for j=1:size(sostim,2);
        temp=find(ismember(sostim(:,j),setSite))./numel(sostim(:,j));
        ranks = [ranks;temp];
        groupExps = [groupExps;ones(size(temp)).*i];
    end
    
end
% rb = nan(max([numel(rankb),numel(ranks)]),1);
% rs = nan(max([numel(rankb),numel(ranks)]),1);
% rb(1:length(rankb))=rankb;
% rs(1:length(ranks))=ranks;
% 
% rankb=rb;
% ranks=rs;

[meanB,~] = bootstrp(1000,@mean,rankb(~isnan(rankb)));
[meanS,~] = bootstrp(1000,@mean,ranks(~isnan(ranks)));
meanB=mean(meanB);
meanS=mean(meanS);
[h,p,ci,stats] =ttest2(rankb(~isnan(rankb)),ranks(~isnan(ranks)),'Alpha',0.01);
%  hold on;
%  plot(sort(rankb),'.b');
%  plot(sort(ranks),'.r');
end