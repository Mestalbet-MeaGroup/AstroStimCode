function h = ChiPrePostBW(bwsPres,bwsPosts,DataSetStims,DataSetBase)
%Function which computes whether the distribution during stimulation fits
%to the distribution of burst widths prior to stimulation.
for i=1:size(bwsPosts,1)
    [h(i),p(i),st] = chi2gof(bwsPosts(i,~isnan(bwsPosts(i,:))),'expected',bwsPres(i,~isnan(bwsPres(i,:))));
end
for i=1:size(DataSetStims,1)
    bwsPost{i} = [DataSetStims{i}.Trim.bw,DataSetStims{i}.sbw];
    %     bwsPost{i}(bwsPost{i}<50*12)=[];
    numPost(i) = numel(bwsPost{i});
    
    bwsPre{i} = [DataSetBase{i}.Trim.bw,DataSetBase{i}.sbw];
    %     bwsPre{i}(bwsPre{i}<50*12)=[];
    numPre(i) = numel(bwsPre{i});
end

maxelements = max([numPost,numPre]);
bwsPres = nan(13,maxelements);
bwsPosts = nan(13,maxelements);

for i=1:size(DataSetStims,1)
    bwsPosts(i,1:numPost(i))=bwsPost{i}./12000;
    bwsPres(i,1:numPre(i))=bwsPre{i}./12000;
end
bins = min(bwsPres(~isnan(bwsPres))):10:max(bwsPosts(~isnan(bwsPosts)));
for i=1:size(bwsPosts,1)
    obsCounts=histc(bwsPosts(i,~isnan(bwsPosts(i,:))),bins);
    expCounts=histc(bwsPres(i,~isnan(bwsPres(i,:))),bins);
    [h(i),p(i),st] = chi2gof(bins,'ctrs',bins,...
        'frequency',obsCounts, ...
        'expected',expCounts,...
        'nparams',0,'emin',1,'alpha',0.01/13);
end

end