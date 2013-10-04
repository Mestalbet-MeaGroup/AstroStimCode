%% Create 4D Matrix for each culture with the following dimensions:
% Q*R (electrodes, 16x16)
% S FR (time in seconds)
% T burst number
function [mPre,mPost,sbVSnsbPre,sbVSnsbPost]=ClusterBurstsUsingAllInfo(DataSetBase,DataSetStims,MeaMap);
for k=1%:size(DataSetBase,1)
    bs = DataSetBase{k}.Trim.bs;
    be = DataSetBase{k}.Trim.be;
    sbVSnsbPre=zeros(length(bs),1);
    if ~isempty(DataSetBase{k}.sbs)
        for kk=1:numel(DataSetBase{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk));
            bs=[bs;bs1];
            be=[be;be1];
            sbVSnsbPre = [sbVSnsbPre;ones(length(bs1),1)];
        end
        
    end
    mPre = CalcBurstCubes(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,bs,be,MeaMap);
    
    bs=[]; be=[]; bs1=[]; be1=[];
    bs = DataSetStims{k}.Trim.bs;
    be = DataSetStims{k}.Trim.be;
    sbVSnsbPost =zeros(length(bs),1);
    if ~isempty(DataSetStims{k}.sbs)
        for kk=1:numel(DataSetStims{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk));
            bs=[bs,bs1];
            be=[be,be1];
            sbVSnsbPost = [sbVSnsbPost;ones(length(bs1),1)];
        end
    end
    mPost = CalcBurstCubes(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,bs,be,MeaMap);
end

%% Calculate correlation along T dimension
combs = allcomb(1:size(mPre,4),1:size(mPost,4));
pre = combs(:,1);
post = combs(:,2);
corr = zeros(max(pre),max(post));
clear DataSetBase; clear DataSetStims;
h = waitbarwithtime(0,'Calculating...');
for i=1:size(combs,1)
mat1 = squeeze(mPre(:,:,:,pre(i)));
mat2 = squeeze(mPost(:,:,:,post(i)));
corr(pre(i),post(i)) = corr3(mat1,mat2);
waitbarwithtime(i/size(combs,1),h);
end


%% Cluster euclidean distances
end