function [BurstData,ClusterIDs] = AnalyzeBurstsInExceptionalCultures(DataSetBase,DataSetStims,MeaMap);
% Function which takes burst information and creates a propagation map and
% then searches for clusters using a genetic algorithm and kmeans.
%% Initialize variables
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
culTypes = {'Melanopsin ','OptoA1-EYFP ','OptoA1-p2a-tRFP ','ChR2 '};
cultLabels = {[culTypes{1} '(1)'] [culTypes{1} '(2)'] [culTypes{1} '(3)'] [culTypes{1} '(4)']...
    [culTypes{2} '(1)'] [culTypes{2} '(2)'] [culTypes{2} '(3)'] ...
    [culTypes{3} '(1)'] [culTypes{3} '(2)']...
    [culTypes{4} '(1)'] [culTypes{4} '(2)'] [culTypes{4} '(3)'] [culTypes{4} '(4)']};

bursts=[];
prepost=[];
nsbsb=[];
cultId=[];
%------------Choose Cultures to Analyze-----------%
% Outliers=8;
% Outliers = 1:2;
Outliers = [7,8,11,12,13];
% Outliers = 1:13;
% Outliers([7,8,11,12,13])=[];
%% Calculate burst propagation maps from t,ic of bursts
for i=1:size(Outliers,2)
    k=Outliers(i);
    m=CalcBurstPropogation(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.Trim.bs,DataSetBase{k}.Trim.be,MeaMap);
    bursts  =  cat(3,bursts,m);
    prepost = [prepost,zeros(1,size(m,3))]; % 0 = pre, 1 = post
    nsbsb   = [nsbsb,zeros(1,size(m,3))]; % 0 = not within superburst, 1 = within superburst
    cultId  = [cultId,ones(1,size(m,3)).*k];
    if ~isempty(DataSetBase{k}.sbs)
        for kk=1:numel(DataSetBase{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.t,DataSetBase{k}.ic,DataSetBase{k}.sbs(kk),DataSetBase{k}.sbe(kk));
            m1 = CalcBurstPropogation(DataSetBase{k}.t,DataSetBase{k}.ic,bs1,be1,MeaMap);
            bursts  =  cat(3,bursts,m1);
            prepost = [prepost,zeros(1,size(m1,3))]; % 0 = pre, 1 = post
            nsbsb   = [nsbsb,ones(1,size(m1,3))]; % 0 = not within superburst, 1 = within superburst
            cultId  = [cultId,ones(1,size(m1,3)).*k];
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
    if ~isempty(DataSetStims{k}.sbs)
        for kk=1:numel(DataSetStims{k}.sbs)
            [bs1,be1] = FindBurstsWithinSBs(DataSetStims{k}.t,DataSetStims{k}.ic,DataSetStims{k}.sbs(kk),DataSetStims{k}.sbe(kk));
            m1 = CalcBurstPropogation(DataSetStims{k}.t,DataSetStims{k}.ic,bs1,be1,MeaMap);
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

clear_all_but('BurstData','MeaMap','Outliers');

%% Test Plots
% for i=1:size(Outliers,2)
%     [BurstVecSB,DistSB] = CalcBurstPropVec(BurstData.bursts(:,:,(BurstData.cultId==Outliers(i))&(BurstData.nsbsb==1)&(BurstData.prepost==1)));
%     [BurstVecNSB,DistNSB] = CalcBurstPropVec(BurstData.bursts(:,:,(BurstData.cultId==Outliers(i))&(BurstData.nsbsb==0)&(BurstData.prepost==1)));
%     subplot(4,4,i);
%     %     if ~isempty(BurstVecNSB)&&~isempty(BurstVecSB)
%     if ~isempty(DistSB)&&~isempty(DistNSB)
%         hold all;
%         %         quiver(BurstVecSB(:,1),BurstVecSB(:,2),BurstVecSB(:,3)-BurstVecSB(:,1),BurstVecSB(:,4)-BurstVecSB(:,2),'r');
%         %         quiver(BurstVecNSB(:,1),BurstVecNSB(:,2),BurstVecNSB(:,3)-BurstVecNSB(:,1),BurstVecNSB(:,4)-BurstVecNSB(:,2),'b');
%         %         scatter(BurstVecSB(:,1),BurstVecSB(:,2),'r');
%         %         scatter(BurstVecNSB(:,1),BurstVecNSB(:,2),'b')
%         %         [n1, x1] = hist(DistSB(:));
%         %         [n2, x2] = hist(DistNSB(:));
%         %         bar(x1,n1,'r');
%         %         bar(x2,n2,'b');
%         triplot(DistSB,BurstVecSB(:,1),BurstVecSB(:,2),'r');
%         triplot(DistNSB,BurstVecNSB(:,1),BurstVecNSB(:,2),'b');
%         hold off;
%     end
%     set(gca,'PlotBoxAspectRatio',[1 1 1]);
%     title(cultLabels{Outliers(i)},'color','k');
% end




%% Calculate Clustering
% Comment out if you want to calculate clusters:
%---------------------------------------------%
% load('ClusterIDs_backup.mat')
%---------------------------------------------%

% Comment out one of the following if Clusters already calculated:
%---------------W\SBs---------------------%
% parfor i=1:size(Outliers,2)
%     ClusterIDs{i} = ClusterBurstsKmeans3(BurstData.bursts(:,:,BurstData.cultId==Outliers(i))); %Allbursts%
% end
% %
% save('ClusterIDs_backupControl.mat','ClusterIDs');
%---------------No_SBs---------------------%
parfor i=1:size(Outliers,2)
    %     display(Outliers(i));
    ClusterIDs{i} = ClusterBurstsKmeans3(BurstData.bursts(:,:,(BurstData.cultId==Outliers(i))&(BurstData.nsbsb==0))); %Just regular bursts
end

% save('ClusterIDs_backup.mat','ClusterIDs');
%---------------------------------------------%

%% Plot Burst Clusters (for each culture)
for k=1:size(Outliers,2)
    f1 = figure('name',['UnMerged Burst Clusters: Culture ' num2str(k)]);
    numtypes=max(ClusterIDs{k});
    for i=1:numtypes
        bursts = BurstData.bursts(:,:,BurstData.cultId==Outliers(k));
        burstType(:,:,i)=nanmean(bursts(:,:,ClusterIDs{k}==i),3);
        subplot(ceil(sqrt(numtypes)),ceil(sqrt(numtypes)),i);
        imagescnan(burstType(:,:,i));
        title([num2str(i) ' - ' num2str(size(bursts(:,:,ClusterIDs{k}==i),3))]);
        set(gca,'XTick',[],'YTick',[],'PlotBoxAspectRatio',[1 1 1]);
    end
    maximize(gcf);
%     export_fig(['UnMergedBurstClusters_Culture' num2str(k) '.png']);
%     close all;
end

%% Plot Burst Types: Pre vs. Post
figure;
%-----------Color Map-------------%
% colors = {'Greys','Purples','Greys','Purples','Purples'};
% cmap=[];
numClusts = cellfun(@max,ClusterIDs);
% for k=1:size(colors,2)
%     cltemp = cbrewer('seq',colors{k},numClusts(k));
%     cmap = [cmap;cltemp(1:numClusts(k),:)];
% end
%-----------Burst Type per Culture-------------%
for i=1:size(Outliers,2)
    subplot(4,3,i);
    prepost=BurstData.prepost((BurstData.cultId==Outliers(i))&(BurstData.nsbsb==0)); %Uncomment if you want to limit to non-SB bursts
    %         prepost=BurstData.prepost(BurstData.cultId==Outliers(i)); %Uncomment if you do not want to limit to non-SB bursts
    clustPre=ClusterIDs{i}(prepost==0);
    clustPost=ClusterIDs{i}(prepost==1);
    numclust = max([clustPre;clustPost]);
    [numPre]=histc(clustPre,1:numclust);
    numPre=numPre./sum(numPre);
    [numPost]=histc(clustPost,1:numclust);
    numPost=numPost./sum(numPost);
    [~,ix] = sort(numPost-numPre);
    row=zeros(max(unique([clustPre;clustPost])),length(clustPre)+length(clustPost));
    for idx=1:numel(unique([clustPre;clustPost]))
        k=ix(idx);
        row(idx,1:length(clustPre)) = (clustPre==k);
        row(idx,length(clustPre)+1:end) = (clustPost==k)*2;
    end
    row(find(row==0))=nan;
    testPre=zeros(1,size(row,2));
    testPost=zeros(1,size(row,2));
    for j=1:size(row,1)
        numPres = sum(row(j,:)==1)/sum(row(:)==1);
        numPosts = sum(row(j,:)==2)/sum(row(:)==2);
        diffs(j,i) = sort(numPosts-numPres);
        testPre = testPre+(row(j,:)==1)*j;
        testPost = testPost+(row(j,:)==2)*j;
    end
    [a,b]=find(row==1);
    numTransPre(i) = sum(diff(testPre)>0)/(max(b)-1);
    numTransPost(i) = sum(diff(testPost)>0)/(abs(size(row,2)-max(b))-1);
    pcolor([row;nan(1,size(row,2))])
%     imagescnan(row);
    %     shading flat;
    set(gca,'ydir','reverse');
    set(gca,'XTick',[],'YTick',[]);
    box on; axis tight;
    title(cultLabels{Outliers(i)},'color','w');
    freezeColors;
    clear row;
end
%-----------Bar Chart of Differences-------------%
subplot(4,3,size(Outliers,2)+2:(4*3));
hold on;
numtypes=0;
% color = [[0.8,0.8,0.8];[0,0,0];[0.8,0.8,0.8];[0,0,0];[0,0,0]]; % For outlier cultures
color=zeros(size(Outliers,2),3)+0.8; % Make bars grey
for j=1:size(Outliers,2)
    numtypes(j+1)=max(ClusterIDs{j});
    bars=bar(sum(numtypes(1:j))+1:sum(numtypes(1:j+1))+1,[diffs(1:numtypes(j+1),j)',nan],'BarWidth',1,'FaceColor',color(j,:));
    ch = get(bars,'Children'); %get children of the bar group
    fvd = get(ch,'Faces'); %get faces data
    xlbls{j}=cultLabels{Outliers(j)};
end
xticks = cumsum(numtypes(1:end-1))+numClusts/2+0.5;
set(gca,'TickDir','out');
set(gca,'XTick',xticks,'XTickLabel',xlbls,'FontSize',8,'XColor',[1 1 1],'YColor',[1 1 1]) %The plus one after numtypes accounts for a space between groups
box off; axis tight; set(gcf,'color','k'); maximize(gcf);
% export_fig('BurstTypeTransitions.png');
% close all;
%---------Transitions over Time---------------%


%---------Transitions Probability Per Culture--------------%
figure;
bar([numTransPre;numTransPost]','grouped');
set(gca,'XTick',1:size(Outliers,2),'XTickLabel',xlbls,'FontSize',16);
ylabel('Transitions Between Burst Types / Total Possible Transitions');
box off; axis tight; set(gcf,'color','none'); maximize(gcf);
% export_fig('BurstTypeTransitionProb.png');

end