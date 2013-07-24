function h = PlotBurstInitiationCM(t,ic,centeredchannel);
% Function which plots the center of masses of the burst initiations for a given t and index
% channel.

load('MeaMapPlot.mat', 'MeaMap');
[bs,be,SpikeOrder]=CalcBurstsSamora(t,ic);
% close all;
% scale = numel(gfr)/max(t);

for i=1:size(SpikeOrder,1)
    mat = zeros(16,16);
    for ii=1:15
        mat(find(MeaMap == SpikeOrder(i,ii)))=1;
    end
    test = regionprops(mat,'Centroid');
    Xcm(i) = test.Centroid(1);
    Ycm(i) = test.Centroid(2);
end

[~,clusterInds,~] = clusterData([Xcm;Ycm]',0.8);
colors = jet(max(clusterInds));

if ~isempty(centeredchannel)
    [Xcenter,Ycenter] = find(MeaMap == centeredchannel);
end
%% Plot Burst Initiation Center of Mass
% figure;
hold on;
for i = 1:size(SpikeOrder,1)
    plot(Xcm(i),Ycm(i),'.','Color',colors(clusterInds(i),:),'MarkerSize',15);
end
if ~isempty(centeredchannel)
    patch([Xcenter-1, Xcenter+1,Xcenter+1,Xcenter-1 ],[Ycenter-1, Ycenter-1,Ycenter+1,Ycenter+1],'k','FaceAlpha',0.2);
end
xlim([0 17]);
ylim([0 17]);
hold off;
grid on;
h = get(gcf, 'CurrentAxes') ;
end