counter1=1;
counter2=1;
for i=1:size(DataSet,1)
    
    if DataSet{i}.base==1
%         psB = diff(PS{i},1,3);
        DataSetBase{counter1}=DataSet{i};
%         for ii=1:size(psB,3)
%             psB1 = psB(:,:,ii);
%             psB1(isnan(psB1))=0;
%             psBase(counter1,ii)=mean(psB1(:));
%         end
        counter1=counter1+1;
    end
    
    if DataSet{i}.stim==1
%         psS = diff(PS{i},1,3);
        DataSetStim{counter2}=DataSet{i};
%         for ii=1:size(psS,3)
%             psS1 = psS(:,:,ii);
%             psS1(isnan(psS1))=0;
%             psStim(counter2,ii)=mean(psS1(:));
%         end
        counter2=counter2+1;
    end
end

for i=1:size(DataSetBase,2)
    cultNumB(i) = str2num(DataSetBase{i}.Record(1:4));
end

for i=1:size(DataSetStim,2)
    cultNumS(i) = str2num(DataSetStim{i}.Record(1:4));
end

[C,ia,ib] = union(cultNumB,cultNumS);