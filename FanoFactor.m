counter1=1;
counter2=counter1;
counter3=counter1;
for i=1:size(DataSet,1)
    if DataSet{i}.base == 1
        vec = round(linspace(1,numel(DataSet{i}.GFR),1000));
        ffBase(counter1) = var(DataSet{i}.GFR)/mean(DataSet{i}.GFR);
        counter1 = counter1+1;
    else if DataSet{i}.stim == 1
            vec = round(linspace(1,numel(DataSet{i}.GFR),1000));
            ffSB(counter2) = var(DataSet{i}.GFR)/mean(DataSet{i}.GFR);
            counter2 = counter2+1;
        end
    end
end