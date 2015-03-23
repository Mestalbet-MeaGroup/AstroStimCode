function [clusters,pProb] = ClusterBurstsGauss(burst,plotme)
% Function which computes a gaussian mixture model for burst
% classification.
% Inputs:
%   1/ burst: as a MxMxP array where M = the number of electrodes on one axis
%      and P is the number of bursts. In each position (i,j) for a given
%      burst, k, the value should be an integer representing the spike
%      order. Alternate values such as neighborhood average will also work
%      but have not been tested.
%   2/ plotme: expected value is either 1 (make a plot of average
%   propogation of a cluster) or 0 do not. 
% In either case, a plot of 4 statistical measures will be plotted which seeks 
% to determine the most statistically sound number of clusters. 
% Each method can give various results. As such, the AIC and BIC of each
% recommended optimum burst number is calculated and the minimum score is
% used to choose the optimum metric for choosing number of clusters.
% Outputs:
%   1/ clusters: an Px1 array where each burst is assigned to a cluster.
%   Some bursts can have a nan value if the maximum posterior probability
%   of belonging to a particular cluster is less than 80% certian. 
% Written by: Noah Levine-Small,  17/03/15

%---Randomly order the bursts---%
rorder = randperm(size(burst,3));
[~,switchback] = sort(rorder);
%--------%
burst = burst(:,:,rorder);
corrvals = clustbycorr(burst,33,1);
linidx= sub2ind([size(burst,3),size(burst,3)],corrvals(:,1),corrvals(:,2));
c=zeros(size(burst,3)*size(burst,3),1);
c(linidx) = corrvals(:,3);
c1 = reshape(c,[size(burst,3),size(burst,3),1]);
c1 = triu(c1,1)+c1';

%Arrange correlations into burst vectors
c1(logical(eye(size(c1))))=nan;
testclust = zeros(size(c1,1)-1,size(c1,1));
parfor i=1:size(c1,1)
    temp = c1(:,i);
    temp(isnan(temp))=[];
    testclust(:,i)=temp;
end

%%
options = statset('UseParallel',true);
[~,score] = pca(testclust','NumComponents',5); % To save time, use only the first 5 
                                               % principal components of the bursts
%--------Plot Best Results--------%
figure;
subplot(2,2,1);
eva = evalclusters(score,'gmdistribution','CalinskiHarabasz','KList',1:10);
best(1) = eva.OptimalK;
hold on;
plot(eva);
plot(eva.OptimalK,eva.CriterionValues(eva.OptimalK),'*r','MarkerSize',15);
title('CalinskiHarabasz');

subplot(2,2,2);
eva = evalclusters(score,'gmdistribution','DaviesBouldin','KList',1:10);
best(2) = eva.OptimalK;
hold on;
plot(eva);
plot(eva.OptimalK,eva.CriterionValues(eva.OptimalK),'*r','MarkerSize',15);
title('DaviesBouldin');

subplot(2,2,3);
eva = evalclusters(score,'gmdistribution','Gap','KList',1:10);
best(3) = eva.OptimalK;
hold on;
plot(eva);
plot(eva.OptimalK,eva.CriterionValues(eva.OptimalK),'*r','MarkerSize',15);
title('Gap');

subplot(2,2,4);
eva = evalclusters(score,'gmdistribution','silhouette','KList',1:10);
best(4) = eva.OptimalK;
hold on;
plot(eva);
plot(eva.OptimalK,eva.CriterionValues(eva.OptimalK),'*r','MarkerSize',15);
title('silhouette');

%--Best model---%
for i=1:size(best,2)
    gm = fitgmdist(score,best(1,i),'Options',options,'SharedCov',true,'Replicates',5);
    best(2,i)= gm.AIC;
    best(3,i)= gm.BIC;
end
[~,ix]=min(mean([zscore(best(2,:));zscore(best(3,:))],1));
best = best(1,ix); % Takes the optimum value found for each measure and calculates the best
                   % AIC, BIC combination. Thus producing the best model. 
which = {'CalinskiHarabasz','DaviesBouldin','Gap', 'silhouette'};
display(['The ', which{ix}, ' statistic produced the best model according the AIC/BIC metric']);

%---Calculate clusters---%
gm = fitgmdist(score,best,'Options',options,'SharedCov',true,'Replicates',10);
clusters = cluster(gm,score);
P = posterior(gm,score);
[vals(:,1),vals(:,2)]=max(P,[],2);
clusters(find(vals(:,1)<0.80))=nan; % removes bursts that have less than a maximum of 
                                    % 80% posterior probability of being in a particular cluster

pProb = P(switchback); %swtich back to the correct order from the random one                                    
clusters = clusters(switchback); %swtich back to the correct order from the random one
burst = burst(:,:,switchback);
%%
if plotme==1
    load('tempBurstsWithClusters.mat','MeaMap')
    for j=1:size(burst,3)
        b = burst(:,:,j);
        for k=1:max(b(:))
            SpikeOrders(k,j) = MeaMap(find(b==k));
        end
    end
    
    [PropMat,PropMatS]=CalcBurstProp(SpikeOrders,burst,MeaMap);
    PropMatS(PropMatS==0)=nan;
    PropMat(PropMat==0)=nan;
    
    figure;
    uval = unique(clusters,'stable');
    vec = find(~isnan(uval));
    for k=1:numel(vec)
        i=vec(k); 
        cm(:,:,k) = nanmean(PropMat(:,:,clusters == uval(i)),3);
        subplot(floor(sqrt(numel(vec))),ceil(sqrt(numel(vec)))+1,k);
        imagescnan(squeeze(cm(:,:,k)));
        colormap('jet')
        title(num2str(sum(clusters == uval(i))));
    end
end
end

% Plot clusters sequentially
% figure; 
% hold all; 
% numbase = size(base,3);
% numstim = size(stim,3);
% stem(clusters(1:numbase)); 
% stem([1:numstim]+numbase,clusters(numbase+1:size(clusters,1)));