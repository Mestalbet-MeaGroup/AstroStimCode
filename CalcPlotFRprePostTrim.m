% Calculates and plots the firing rates of all the cultures prior and
% following optogenetic stimulation of astrocytes
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.05 0.05], [0.05 0.05]);
for i=1:size(DataSetStims,1)
    %% Load Select Culture
    tpre=DataSetBase{i}.Trim.t; %pre
    icpre=DataSetBase{i}.Trim.ic; %pre
    tpost=DataSetStims{i}.Trim.t; %post
    icpost=DataSetStims{i}.Trim.ic; %post
    %% Calculate Firing Rate
%     [~,pre]=FindNeuronFrequency(tpre,icpre,500,1);
%     [~,post]=FindNeuronFrequency(tpost,icpost,500,1);
    interval = 500; %ms
    recend = max(tpre)./12; %30*60*1000; %(30 minutes/recording * 60 sec/min *1000 ms/sec)
    pre = (histc(sort(tpre)./12,0:interval:recend)./1000)./(size(icpre,2));
    recend = max(tpost)./12; %30*60*1000; %(30 minutes/recording * 60 sec/min *1000 ms/sec)
    post = (histc(sort(tpost)./12,0:interval:recend)./1000)./(size(icpost,2));
    %% Setup window
    startpre=1;
    stoppre=length(pre);
    startpost=stoppre+1;
    stoppost=startpost+length(post)-1;
    
    %% Normalize Firing Rates (standard error)
    y=pre(startpre:stoppre);
    pres=y.*1000;
    posts=post.*1000;
%     pres=abs((y-mean(y))./std(y));
%     pres = (y-min(y)) / (max(y) - min(y));
%     pres=(pres-mean(pres))+0.5;
%     posts=(post-mean(y))./std(post);
%     posts = (post-min(post)) / (max(post) - min(post));
    
    %% Remove Outliers
    %
    
    %% Calculate Index
    postIndex=(startpost:stoppost).*(max(tpre)+max(tpost))/12000/60/length(post);
    preIndex=(startpre:stoppre).*max(tpre)/12000/60/length(pre);
    preIndex=preIndex-postIndex(1);
    preIndex=preIndex+min(abs(preIndex));
    postIndex=postIndex-postIndex(1);
    
    %% Calculate Mean and Standard Deviation of Firing Rates
%     meanlinepres=ones(length(preIndex),1).*mean(pres);
%     stdlow_linepres=ones(length(preIndex),1).*(mean(pres)-std(pres));
%     stdhigh_linepres=ones(length(preIndex),1).*(mean(pres)+std(pres));
%     meanlineposts=ones(length(postIndex),1).*mean(posts);
%     stdlow_lineposts=ones(length(postIndex),1).*(mean(posts)-std(posts));
%     stdhigh_lineposts=ones(length(postIndex),1).*(mean(posts)+std(posts));
    
    
    %% Plot Firing Rate and Mean/STD lines
    subplot(5,3,i)
    hold on;
    plot(preIndex,pres,'-b');
    plot(postIndex,posts,'-r');
    if i==7
        %         ylabel('Spike Rate [Z-score]','FontSize',18);
        ylabel('Spike Rate [Spikes per neuron per second]','FontSize',18);
        
    end
    if max(abs(preIndex))>=max(postIndex)
        xlim([-max(postIndex) max(postIndex)]);
    else
        xlim([-1*max(abs(preIndex)) max(abs(preIndex))]);
    end
    %     plot(preIndex,meanlinepres,'-b','LineWidth',3);
%     plot(preIndex,stdlow_linepres,'--b','LineWidth',2);
%     plot(preIndex,stdhigh_linepres,'--b','LineWidth',2);
%     ha = patch([preIndex fliplr(preIndex)], [stdlow_linepres',fliplr(stdhigh_linepres')],'b');
    %     plot(postIndex,meanlineposts,'-r','LineWidth',3);
%     plot(postIndex,stdlow_lineposts,'--r','LineWidth',2);
%     plot(postIndex,stdhigh_lineposts,'--r','LineWidth',2);
%     hb = patch([postIndex fliplr(postIndex)], [stdlow_lineposts',fliplr(stdhigh_lineposts')],'r');
%     set(ha,'FaceAlpha',0.2);
%     set(hb,'FaceAlpha',0.2);
    %     ylim([-max([stdhigh_lineposts;stdhigh_linepres])*1.5,max([stdhigh_lineposts;stdhigh_linepres])*1.5]);
    %     ylim([-max([pres,posts])*1.01,max([pres,posts])*1.01]);
    [~, ymax]=CalcLimitsWithoutOutliers(pres,posts);
%     ylim([ymin*0.9,ymax*1.1]);
    ylim([-1, 25]);
    ratio(i)  = (numel(tpost)/(max(tpost)-min(tpost))) /(numel(tpre)/(max(tpre)-min(tpre)));
    %     xlabel(['Ratio of Spikes: Post/Pre = ' num2str(ratio)],'FontSize',16);
    hold off
    %     eval(['print(f,' '''-r600''' ',' '''-deps'',''' cultures{i,1} '.eps'');']);
end

subplot(5,3,i+1:15)
bar(ratio);
lenLine = 0:1:14;
line(lenLine,ones(length(lenLine)),'LineStyle','-.','Color','r');
ylabel('Post/Pre number of spikes','FontSize',16);
xlabel('Cultures','FontSize',16);
set(gca,'FontSize',16);
maximize(gcf);
set(gcf,'color','w');
% export_fig 'FiringRateAllOpto.png';

% print(gcf, '-r600', '-dpng', 'FiringRateAllOpto.png');

