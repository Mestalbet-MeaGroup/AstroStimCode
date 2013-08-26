test=[];
cultNum=[];
for i=1:13
    test = [test,bwsPres(i,:)];
    cultNum = [cultNum,ones(1,length(bwsPres(i,:))).*i];
end
Treatment=ones(size(test));
for i=1:13
    test = [test,bwsPosts(i,:)];
    cultNum = [cultNum,ones(1,length(bwsPosts(i,:))).*i];
end
Treatment(end+1:length(test))=2;

[p,table,stats,terms] = anovan(test',{cultNum' Treatment'},'model','full', 'varnames',{'Culture';'Stimulation'},'alpha',0.01);
% [p,table,stats,terms] = anovan(test,{cultNum' Treatment'},'model','full', 'varnames',{'Culture';'Stimulation'});