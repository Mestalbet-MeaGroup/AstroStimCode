function row2 = CropReOrderBurstTypeClusters(row);

numClusts = size(row,1);
if numClusts>6
    for i=1:numClusts
        fracPre(i) = sum(row(i,:)==1);
        fracPost(i) =sum(row(i,:)==2);
    end
    PreClusts = find(fracPre==0,1,'First');
    
    [~,ixPre]=sort(fracPre,'descend');
    [~,ixPost]=sort(fracPost,'descend');
    
    row2(1:3,:)=row(ixPre(1:3),:);
    row2(4:6,:)=row(ixPost(1:3),:);
else
    row2=row;
end
end