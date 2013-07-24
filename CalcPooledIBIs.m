IBIb=[];
IBIs=[];
IBIp=[];
for i=1:24
    if DataSet{i}.base==1
        mids= (DataSet{i}.be-DataSet{i}.bs)/2+DataSet{i}.bs;
        IBIb = [IBIb,diff(mids)];
        numFastb(i)=sum(diff(mids)<5*12000)/(max(DataSet{i}.t)-min(DataSet{i}.t));
    end
    
    if DataSet{i}.stim==1
        mids= (DataSet{i}.be-DataSet{i}.bs)/2+DataSet{i}.bs;
        IBIs= [IBIs,diff(mids)];
        numFasts(i)=sum(diff(mids)<5*12000)/(max(DataSet{i}.t)-min(DataSet{i}.t));
    end
    
    if DataSet{i}.post==1
        mids= (DataSet{i}.be-DataSet{i}.bs)/2+DataSet{i}.bs;
        IBIp= [IBIp,diff(mids)];
    end
end
    