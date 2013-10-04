function BurstData = CreateBurstDataStructure(DataSetBase,DataSetStims,MeaMap)

bursts=[];
prepost=[];
nsbsb=[];
cultId=[];

for k=1:size(DataSetBase,1)
    m = CalcBurstCubes(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be,MeaMap);
    bursts  =  cat(4,bursts,m);
    prepost = [prepost,zeros(1,size(m,4))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,4))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,4)).*k];
    if ~isempty(DataSetBase{k}.sbs)
        for kk=1:numel(DataSetBase{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk));
            m1 = CalcBurstCubes(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,bs1,be1,MeaMap);
            bursts  =  cat(4,bursts,m1);
            prepost = [prepost,zeros(1,size(m1,4))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,4))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,4)).*k];
        end
    end
end

for k=1:size(DataSetStims,1)
    m = CalcBurstCubes(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,ones(1,size(m,4))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,4))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,4)).*k];
    if ~isempty(DataSetStims{k}.sbs)
        for kk=1:numel(DataSetStims{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk));
            m1 = CalcBurstCubes(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,bs1,be1,MeaMap);
            bursts  =  cat(4,bursts,m1);
            prepost = [prepost,ones(1,size(m1,4))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,4))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,4)).*k];
        end
    end
end


BurstData.bursts = bursts;
BurstData.prepost = prepost;
BurstData.nsbsb = nsbsb;
BurstData.cultId = cultId;
end