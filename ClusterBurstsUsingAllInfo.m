%% Create 4D Matrix for each culture with the following dimensions:
% Q*R (electrodes, 16x16)
% S FR (time in seconds)
% T burst number
function [m,sbVSnsb,preVSpost,corr1]=ClusterBurstsUsingAllInfo(DataSetBase,DataSetStims,MeaMap);
for k=1:size(DataSetBase,1)
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
    mPre = CalcBurstCubes(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,bs,be,MeaMap,[]);
    
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
    mPost = CalcBurstCubes(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,bs,be,MeaMap,size(mPre,3));
    bs=[]; be=[]; bs1=[]; be1=[];
    %% Calculate correlation along T dimension
    % combs = allcomb(1:size(mPre,4),1:size(mPost,4));
    % mPost=padarray(mPost,[0 0 size(mPre,3)-size(mPost,3) 0],'post');
    m=cat(4,mPre,mPost);
    sbVSnsb{k} = [sbVSnsbPre;sbVSnsbPost];
    preVSpost{k}=[zeros(size(mPre,4),1);ones(size(mPost,4),1)];
    clear DataSetBase; clear DataSetStims; clear mPre; clear mPost; clear sbVSnsbPre; clear sbVSnsbPost;
    combs = VChooseK(1:size(m,4),2);
    x = combs(:,1);
    y = combs(:,2);
    corr = zeros(numel(preVSpost),numel(preVSpost));
    h = waitbarwithtime(0,'Calculating...');
    for i=1:size(combs,1)
        mat1 = squeeze(m(:,:,:,x(i)));
        mat2 = squeeze(m(:,:,:,y(i)));
        corr(x(i),y(i)) = corr3(mat1,mat2);
        waitbarwithtime(i/size(combs,1),h);
    end
    corr1{k} = corr + corr'+eye(size(corr)).*max(corr(:));
    % test=pdist(corr1);
    % tree=linkage(test,'average');
    % ClusterIDs  = cluster(tree,'MaxClust',3,'Criterion','distance');
    
    %% Cluster euclidean distances
end
end