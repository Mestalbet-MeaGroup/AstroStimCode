function PlotCDFwithDetectionError()
load('CDF_error_testing_burstdata.mat');

%% Plot Results
%-----Plot Burst Durations------%
figure('renderer','opengl');hold on;
% for k=1:2
%     for i=1:3
%         for j=1:3
i=1;j=1;k=1;
% for q=1:max(BurstData{i,j,k}.cultId)
% regbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==0)&(BurstData{i,j,k}.cultId==q)); % Outside of SBs
% sbbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==1)&(BurstData{i,j,k}.cultId==q)); % Inside of SBs
regbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==0)); % Outside of SBs
sbbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==1)); % Inside of SBs
% if ~isempty(sbbw)&&(~isempty(regbw))
[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'./1200); % Convert to ms
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'./1200);
% if (i==1)&&(j==1)
%------Baseline-----%
plot(regCDFx,regCDFy,'ok','MarkerSize',1,'MarkerFaceColor','b','MarkerEdgeColor','b');
line(limRegX,limRegY,'color','b');
%----Stimulation----%
plot(sbCDFx,sbCDFy,'ok','MarkerSize',1,'MarkerFaceColor','r','MarkerEdgeColor','r');
line(limSBX,limSBY,'color','r');
% end
% end
xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)/5]);
ylim([0 max(regCDFy)]);
xlabel('duration [ms]');
ylabel('probability');
%             end
%         end
%     end
% end

[x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData);
jbfill(x,y1,y,'b','none',[],0.5);
jbfill(xs,y1s,ys,'r','none',[],0.5);
hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFburstdurations.eps');
close all;


%-----Plot Number of Spikes per Channel-------%
figure;hold on;
for k=1:2
    for i=1:3
        for j=1:3
            regfr  = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==0); %Outside of SBs
            sbfr   = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==1); %Inside of SBs
            [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr'); % Convert to ms
            [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr');
            if (i==1)&&(j==1)
                %----Baseline----%
                plot(regCDFx,regCDFy,'ok','MarkerSize',1,'MarkerFaceColor','b','MarkerEdgeColor','b');
                line(limRegX,limRegY,'color','b');
                %----Stimulation----%
                plot(sbCDFx,sbCDFy,'ok','MarkerSize',1,'MarkerFaceColor','r','MarkerEdgeColor','r');
                line(limSBX,limSBY,'color','r');
                %-------------------%
                xlimtest = [max(sbCDFx),max(regCDFx)];
                xlim([0 min(xlimtest)/3]);
                ylim([0 max(regCDFy)+0.02]);
                xlabel('spikes per channel');
                ylabel('probability');
            else
                circle(regCDFx,regCDFy,[208 205 255]./255);
                circle(sbCDFx,sbCDFy,[249 206 206]./255);
                %                 plot(regCDFx,regCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
                %                 plot(sbCDFx,sbCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
            end
        end
    end
end
hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFspikecount.eps');
close all;


%-----Plot Firing Rate------%

figure; hold on;
for k=1:2
    for i=1:3
        for j=1:3
            regfr  = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==0)./(BurstData{i,j,k}.bw(BurstData{i,j,k}.nsbsb==0))'; %Outside of SBs
            sbfr   = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==1)./(BurstData{i,j,k}.bw(BurstData{i,j,k}.nsbsb==1))'; %Inside of SBs
            [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regfr'.*12000); % Convert to ms
            [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbfr'.*12000);
            if (i==1)&&(j==1)
                %----Baseline----%
                plot(regCDFx,regCDFy,'ok','MarkerSize',1,'MarkerFaceColor','b','MarkerEdgeColor','b');
                line(limRegX,limRegY,'color','b');
                %----Stimulation----%
                plot(sbCDFx,sbCDFy,'ok','MarkerSize',1,'MarkerFaceColor','r','MarkerEdgeColor','r');
                line(limSBX,limSBY,'color','r');
                %-------------------%
                xlimtest = [max(sbCDFx),max(regCDFx)];
                xlim([0 min(xlimtest)]);
                ylim([0 max(regCDFy)+0.02]);
                xlabel('frequency per channel [Hz]');
                ylabel('probability');
            else
                circle(regCDFx,regCDFy,[208 205 255]./255);
                circle(sbCDFx,sbCDFy,[249 206 206]./255);
                %                 plot(regCDFx,regCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
                %                 plot(sbCDFx,sbCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
            end
        end
    end
end
hold off;
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFfiringrates.eps');
close all;

%-----Plot Recruitment------%
figure; hold on;
for k=1:2
    for i=1:3
        for j=1:3
            regpcnt  = BurstData{i,j,k}.spikesPcntMax(BurstData{i,j,k}.nsbsb==0); % Outside of SBs
            sbpcnt  = BurstData{i,j,k}.spikesPcntMax(BurstData{i,j,k}.nsbsb==1); % Inside of SBs
            [regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regpcnt'); % Convert to ms
            [sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbpcnt');
            if (i==1)&&(j==1)
                %----Baseline----%
                plot(regCDFx,regCDFy,'ok','MarkerSize',1,'MarkerFaceColor','b','MarkerEdgeColor','b');
                line(limRegX,limRegY,'color','b');
                %----Stimulation----%
                plot(sbCDFx,sbCDFy,'ok','MarkerSize',1,'MarkerFaceColor','r','MarkerEdgeColor','r');
                line(limSBX,limSBY,'color','r');
                %-------------------%
                xlimtest = [max(sbCDFx),max(regCDFx)];
                xlim([0 min(xlimtest)]);
                ylim([0 max(regCDFy)+0.02]);
                xlabel('recruitment [%]');
                ylabel('probability');
            else
                circle(regCDFx,regCDFy,[208 205 255]./255);
                circle(sbCDFx,sbCDFy,[249 206 206]./255);
                %                 plot(regCDFx,regCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
                %                 plot(sbCDFx,sbCDFy,'o','MarkerSize',2,'MarkerFaceColor','none','MarkerEdgeColor',[0.5 0.5 0.5]);
            end
        end
    end
end
hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFprecentageburstparticipation.eps');
close all;


    function pb = circle(x,y,col)
        t= 0:pi/10:2*pi;
        for q=1:numel(x)
            pb=patch((sin(t)/150+ x(q)),(cos(t)/150+y(q)),col,'edgecolor','none');
            alpha(pb,0.5);
        end
    end

end
