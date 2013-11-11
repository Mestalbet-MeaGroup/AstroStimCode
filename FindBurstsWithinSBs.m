function [bs,be] = FindBurstsWithinSBs(t,ic,sbs,sbe)
[t,ic] = CutSortChannel2(t,ic,sbs,sbe);
fr=histc(sort(t),min(t):100:max(t));
% plot(fr)
% maximize(gcf);
% [x,y]=ginput;
% close;
% bs = x(1:2:end-1);
% be = x(2:2:end);
% 


fr = filtfilt(MakeGaussian(0,3,5),1,fr);
[bs,be]=CalcOnOffsets(fr);
% 
% [bs,be]=initfin( (fr>0)|([0,0,diff(diff(fr))]>0));
bs=bs*100+min(t)+sbs;
be=be*100+min(t)+sbs;
% for i=1:numel(bs)
%     temp=histc(sort(t),[bs(i),be(i)]);
%     spikecheck(i) = temp(1) > 100;
% end
% bs = bs(spikecheck);%+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs
% be = be(spikecheck);%+sbs; %modified for ClusterBurstsUsingAllInfo, originally without +sbs
end
% figure;
% [cmap,Z1]=MeaColorMap;
% set(gca,'PlotBoxAspectRatio',[1 1 1]);
% set(gcf,'color','none');
% maximize(gcf);
% set(findall(gcf,'-property','FontSize'),'FontSize',16);
% figure;
% for i=1:15
%     bursts  = BurstData.bursts(:,:,(BurstData.cultId==i)&(BurstData.nsbsb==1));
%     SpikeOrders=[];
%     for j=1:size(bursts,3)
%         b = bursts(:,:,j);
%         for k=1:max(b(:))
%             SpikeOrders(k,j) = MeaMap(find(b==k));
%         end
%     end
%     if ~isempty(SpikeOrders)
%     s=subplot(4,4,i);
%     f=figure;
%     h=PlotSequentialSpikeOrder(MeaMap,SpikeOrders);
%     set(f,'ColorMap',[[0,0,0];cmap]);
%     copyobj(h,s);
%     close(f);
%     axis tight;
%     end
% end