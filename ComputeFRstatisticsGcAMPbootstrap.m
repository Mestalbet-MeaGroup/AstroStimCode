function [valsGcamp,valsBase]=ComputeFRstatisticsGcAMPbootstrap(DataSet)

% Computes if there is a difference between control and experiment in FR nested
% pre/post and different cultures.

recordingTime = 30*60*1000; %30min
res=50;
fr=[];
valsGcamp=[];
valsBase=[];
g1=[];
g2=[];
g3=[];
for j=1:size(DataSet,1)
    tGcamp = DataSet{j}.tGcamp;
    icGcamp = DataSet{j}.icGcamp;
    tBase = DataSet{j}.tBase;
    icBase = DataSet{j}.icBase;
    
    for i=1:size(icGcamp,2)
        if size(icGcamp{i},2)>5
            tempval=histc(sort(tGcamp{i}),0:res*12:recordingTime)./res;
            %             [tempVal,~] = bootstrp(1000,@mean,fr1');
            %             tempval=fr1(randi(length(fr1),1,1000))';
            tempval=tempval';
            valsGcamp = [valsGcamp;tempval];
            if mod(j,2)>0
                g1=[g1;ones(length(tempval),1)];
            end
            if mod(j,2)==0
                g1=[g1;ones(length(tempval),1).*2];
            end
            %             g1=[g1;ones(length(tempval),1).*i];
            g2=[g2;ones(length(tempval),1)];
            if j==1||j==2
                g3=[g3;ones(length(tempval),1)];
            end
            if j==3||j==4
                g3=[g3;ones(length(tempval),1)*2];
            end
            if j==5||j==6
                g3=[g3;ones(length(tempval),1)*3];
            end
            if j==7||j==8
                g3=[g3;ones(length(tempval),1)*4];
            end
            
            
        end
    end
    
    
    for i=1:size(icBase,2)
        if size(icBase{i},2)>5
            tempval=histc(sort(tBase{i}),0:res*12:recordingTime)./res;
            tempval=tempval';
            %             [tempVal,~] = bootstrp(1000,@mean,fr1');
            %             tempval=fr1(randi(length(fr1),1,1000))';
            valsBase = [valsBase;tempval];
            g2=[g2;ones(length(tempval),1).*2];
            %             g1=[g1;ones(length(tempval),1).*(i+size(icGcamp,2))];
            if mod(j,2)>0
                g1=[g1;ones(length(tempval),1)];
            end
            if mod(j,2)==0
                g1=[g1;ones(length(tempval),1).*2];
            end
            if j==1||j==2
                g3=[g3;ones(length(tempval),1)];
            end
            if j==3||j==4
                g3=[g3;ones(length(tempval),1)*2];
            end
            if j==5||j==6
                g3=[g3;ones(length(tempval),1)*3];
            end
            if j==7||j==8
                g3=[g3;ones(length(tempval),1)*4];
            end
        end
    end
    %     temp1 = ones(size(valsGcamp));
    %     temp2= ones(size(valsBase))*2;
    %     g2 = [g2;temp1;temp2];
end
vals = [valsGcamp;valsBase];
[p,table,stats,terms] = anovan(vals,{g1 g2 g3},'model','full','varnames',{'Recording';'GcAMP';'Culture'});

% 
% recordingTime = 30*60*1000; %30min
% res=50;
% fr=[];
% valsGcamp=[];
% valsBase=[];
% 
% for j=1:size(DataSet,1)
%     tGcamp = DataSet{j}.tGcamp;
%     icGcamp = DataSet{j}.icGcamp;
%     tBase = DataSet{j}.tBase;
%     icBase = DataSet{j}.icBase;
%     for i=1:size(icGcamp,2)
%         if size(icGcamp{i},2)>5
%             fr1=histc(sort(tGcamp{i}),0:res*12:recordingTime)./res;
%             %             [tempVal,~] = bootstrp(1000,@mean,fr1');
%             tempval=fr1(randi(length(fr1),1,1000));
%             valsGcamp = [valsGcamp,tempval];
%         end
%     end
%     
%     for i=1:size(icBase,2)
%         if size(icBase{i},2)>5
%             fr1=histc(sort(tBase{i}),0:res*12:recordingTime)./res;
%             %             [tempVal,~] = bootstrp(1000,@mean,fr1');
%             tempval=fr1(randi(length(fr1),1,1000));
%             valsBase = [valsBase,tempval];
%         end
%         
%     end
% end
% 
end