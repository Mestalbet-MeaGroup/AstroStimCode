function PlotCDFwithDetectionErrorWithPatch()
load('CDF_error_testing_burstdata.mat');

%% Plot Results
%-----Plot Burst Durations------%
figure('renderer','opengl');hold on;

i=1;j=1;k=1;
regbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==0)); % Outside of SBs
sbbw  = BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==1)); % Inside of SBs
[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'./1200); % Convert to ms
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'./1200);
%------Baseline-----%
plot(regCDFx,regCDFy,'.b','MarkerSize',4);
line(limRegX,limRegY,'color','b');
%----Stimulation----%
plot(sbCDFx,sbCDFy,'.r','MarkerSize',4);
line(limSBX,limSBY,'color','r');

xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)/5]);
ylim([0 max(regCDFy)]);
xlabel('duration [ms]');
ylabel('probability');
[x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData,'bw');
jbfill(x,y1,y,'b','none',[],0.5);
jbfill(xs,y1s,ys,'r','none',[],0.5);
set(gca,'xscale','log'); hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFburstdurations.eps');
close all;


%-----Plot Number of Spikes per Channel-------%
figure('renderer','opengl');hold on;

i=1;j=1;k=1;
regbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==0)); % Outside of SBs
sbbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==1)); % Inside of SBs
[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'); 
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw');
%------Baseline-----%
plot(regCDFx,regCDFy,'.b','MarkerSize',4);
line(limRegX,limRegY,'color','b');
%----Stimulation----%
plot(sbCDFx,sbCDFy,'.r','MarkerSize',4);
line(limSBX,limSBY,'color','r');

xlimtest = [max(sbCDFx),max(regCDFx)];
xlim([0 min(xlimtest)/5]);
ylim([0 max(regCDFy)]);
xlabel('spikes per channel');
ylabel('probability');
[x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData,'numspikes');
jbfill(x,y1,y,'b','none',[],0.5);
jbfill(xs,y1s,ys,'r','none',[],0.5);
set(gca,'xscale','log'); hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFspikecount.eps');
close all;


%-----Plot Firing Rate------%

figure('renderer','opengl');hold on;

i=1;j=1;k=1;
regbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==0))./BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==0))'; % Outside of SBs
sbbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==1))./BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==1))';  % Inside of SBs
[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'.*12000); % Convert to Hz
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'.*12000);
%------Baseline-----%
plot(regCDFx,regCDFy,'.b','MarkerSize',4);
line(limRegX,limRegY,'color','b');
%----Stimulation----%
plot(sbCDFx,sbCDFy,'.r','MarkerSize',4);
line(limSBX,limSBY,'color','r');
xlabel('firing rate per channel [Hz]');
ylabel('probability');
axis('tight');
[x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData,'fr');
jbfill(x,y1,y,'b','none',[],0.5);
jbfill(xs,y1s,ys,'r','none',[],0.5);
set(gca,'xscale','log'); hold off;
%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFfiringrates.eps');
close all;

%-----Plot Recruitment------%
figure('renderer','opengl');hold on;

i=1;j=1;k=1;
regbw  = BurstData{i,j,k}.spikesPcntMax((BurstData{i,j,k}.nsbsb==0)); % Outside of SBs
sbbw  = BurstData{i,j,k}.spikesPcntMax((BurstData{i,j,k}.nsbsb==1)); % Inside of SBs

[regCDFx,regCDFy,limRegX,limRegY]=CalcCdf(regbw'.*100); 
[sbCDFx,sbCDFy,limSBX,limSBY]=CalcCdf(sbbw'.*100);
%------Baseline-----%
plot(regCDFx,regCDFy,'.b','MarkerSize',4);
line(limRegX,limRegY,'color','b');
%----Stimulation----%
plot(sbCDFx,sbCDFy,'.r','MarkerSize',4);
line(limSBX,limSBY,'color','r');

axis('tight');
xlabel('recruitment [%]');
ylabel('probability');
[x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData,'recruitment');
jbfill(x,y1,y,'b','none',[],0.5);
jbfill(xs,y1s,ys,'r','none',[],0.5);
hold off;

%-----Save and Close------%
set(gcf,'color','none');
maximize(gcf);
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gca,'PlotBoxAspectRatio',[1 1 1]);
export_fig('Fig6_CDFprecentageburstparticipation.eps');
% print('-depsc2','-r300','Fig6_CDFprecentageburstparticipation.eps');
close all;

end
