counter1=1;
counter2=1;
for i=1:size(DataSet,1)
    
    if DataSet{i}.base==1
        for ii=1:size(PS{i},3)
            psB = squeeze(PS{i}(:,:,ii));
            psB(isnan(psB))=0;
            psb=triu(psB,1);
            psb=psb(psb~=0);
            psBase(counter1,ii)=mean(psb);
        end
        counter1=counter1+1;
    end
    if DataSet{i}.stim==1
        for ii=1:size(PS{i},3)
            psS = squeeze(PS{i}(:,:,ii));
            psS(isnan(psS))=0;
            pss=triu(psS,1);
            pss=pss(pss~=0);
            psStim(counter2,ii)=mean(pss);
        end
        counter2=counter2+1;
    end
end

for i=1:size(psBase,1)
    diffB(i) = max(abs(diff(psBase(i,:))));
end

for i=1:size(psStim,1)
    diffS(i) = max(abs(diff(psStim(i,:))));
end


for i=1:size(psBase,1)
figure; plot(1:length(psBase(i,:)),psBase(i,:));
hold on;
plot(length(psBase(i,:))+1:length(psBase(i,:))+length(psStim(i,:)),psStim(i,:),'r');
hold off;
end
