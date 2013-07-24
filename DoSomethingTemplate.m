counter1=1;
counter2=counter1;
counter3=counter1;
for i=1:size(DataSet,1)
    if DataSet{i}.base == 1
        % do something
        counter1 = counter1+1;
    else if DataSet{i}.stim == 1
            % do something
            counter2 = counter2+1;
        else
            % do something
            counter3 = counter3+1;
        end
    end
end