function SpikeOrder = FindSpikeOrders(t,ic,bs,be);
Nneurons=size(ic,2);
Nbursts=numel(bs);
SpikeOrder=zeros(Nneurons,Nbursts);

for j=1:Nbursts
  for i=1:Nneurons
   tNeuron=t(ic(3,i):ic(4,i));  
   a=sort(tNeuron(tNeuron>=bs(j) & tNeuron<=be(j)));   
    if ~isempty(a)
     SpkInBursts(i,j,i)=a(1);
    else
     SpkInBursts(i,j,i)=nan;
    end
  end
end

for i=1:Nbursts
a=diag(squeeze(SpkInBursts(:,i,:)));    
[b perm]=sort(a);
SpikeOrder(:,i)=ic(1,perm);
end
end