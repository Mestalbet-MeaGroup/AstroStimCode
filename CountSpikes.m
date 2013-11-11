function numspikes = CountSpikes(t,ic,bs,be);
% numspikes=nan(numel(bs),256);
% for i=1:numel(bs)
% [t1,ic1]=CutSortChannel(t,ic,bs(i),be(i));
% numspikes(i,1:size(ic1,2)) = (ic1(4,:)-ic1(3,:))/ ((be(i)-bs(i))/12000);
% end
% numspikes=numspikes-1;
for i=1:numel(bs)
[t1,ic1] = CutSortChannel2(t,ic,bs(i),be(i));
fr=histc(sort(t1),min(t1):100:max(t1));
numspikes(i)=max(fr(:))/(100/12000);
end
numspikes=numspikes'./size(ic1,2); % Spikes per channel per second
end