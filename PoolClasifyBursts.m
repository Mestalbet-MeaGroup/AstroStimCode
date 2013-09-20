function BurstData = PoolClasifyBursts(DataSetBase,DataSetStims,MeaMap)

bursts=[];
prepost=[];
nsbsb=[];
cultId=[];

for k=1:size(DataSetBase,1)
    m = CalcBurstSequence(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,zeros(1,size(m,3))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,3))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,3)).*k];
    if ~isempty(DataSetBase{k}.sbs)
        for kk=1:numel(DataSetBase{k}.sbs)
            m1 = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk));
            bursts  =  cat(3,bursts,m1);
            prepost = [prepost,zeros(1,size(m1,3))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,3))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,3)).*k];
        end
    end
end

for k=1:size(DataSetStims,1)
    m = CalcBurstSequence(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.Trim.bs,DataSetStims{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,ones(1,size(m,3))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,3))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,3)).*k];
    if ~isempty(DataSetStims{k}.sbs)
        for kk=1:numel(DataSetStims{k}.sbs)
            m1 = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk));
            bursts  =  cat(3,bursts,m1);
            prepost = [prepost,ones(1,size(m1,3))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,3))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,3)).*k];
        end
    end
end




BurstData.bursts = bursts;
BurstData.prepost = prepost;
BurstData.nsbsb = nsbsb;
BurstData.cultId = cultId;
[BurstData.ClusterIDs,BurstData.CorrMat] = ClusterBursts(bursts);

    function m = CalcBurstSequence(t,ic,bs,be,MeaMap)
        
        Nbursts=numel(bs);
        m = nan(size(MeaMap,1),size(MeaMap,2),Nbursts);
        
        ic = ConvertIC2Samora(ic);
        [t,ix]=sort(t);
        ic=ic(ix);
        
        for j=1:Nbursts
            a=find(t>=bs(j) & t<=be(j));
            ChannelOrder=unique(ic(a),'stable');
            for r=1:size(ChannelOrder,2)
                [x,y]=find(MeaMap==ChannelOrder(r),1,'First');
                if ~isempty(x)
                    m(x,y,j)=r;
                end
            end
        end
    end

    function m = FindBurstsWithinSBs(t,ic,sbs,sbe)
        [t,ic] = CutSortChannel2(t,ic,sbs,sbe);
        fr=histc(sort(t),min(t):100:max(t));
        fr = filtfilt(MakeGaussian(0,3,12),1,fr);
        [bs,be]=initfin( (fr>0)|([0,0,diff(diff(fr))]>0));
        bs=bs.*100;
        be=be.*100;
        for i=1:numel(bs)
            temp=histc(sort(t),[bs(i),be(i)]);
            spikecheck(i) = temp(1) > 100;
        end
        bs = bs(spikecheck);
        be = be(spikecheck);
        m = CalcBurstSequence(t,ic,bs,be,MeaMap);
    end

end