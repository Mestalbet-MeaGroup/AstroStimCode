function ClustMat = CreatePropVecForClustering(bursts,SpikeOrders,MeaMap,CalcType);
% Function which recieves bursts and generates a matrix for SOM clustering

ClustMat = nan(size(SpikeOrders));
for j=1:size(bursts,3)
%     b = bursts(:,:,j);
%     for k=1:max(b(:))
%         SpikeOrders(k,j) = MeaMap(find(b==k));
%     end
    [~,bmat(:,:,j)]=ismember(MeaMap,SpikeOrders(:,j));
end

if strcmp(CalcType,'DistToNext')
    %blah
else
    switch CalcType
        case 'LocalMean'
            fun = @(x) nanmean(x(:));
        case 'LocalVar'
            fun = @(x) nanvar(x(:));
        case 'LocalCV'
            fun = @(x) nanvar(x(:))/nanmean(x(:));
        case 'MaxMin'
            fun = @(x) nanmax(x(:))-nanmin(x(:));
        otherwise
                error('Incorrect Calculation Type Input');
    end
    for i=1:size(bmat,3)
        temp = nlfilter(squeeze(bmat(:,:,i)),[5,5],fun);
        temp(temp==0)=nan;
        elecs = bmat(:,:,i);
        cmat=arrayfun(@(x) temp(elecs==x),1:max(elecs(:)));
        ClustMat(1:numel(cmat),i)=cmat;
    end
    
end


end

