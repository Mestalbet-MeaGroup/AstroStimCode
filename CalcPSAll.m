%  h = waitbarwithtime(0,'Calculating...');
parfor i=1:size(DataSet,1)
    [PS{i},~,~]=Zgenerate_Rcolomn4(DataSet{i}.t,DataSet{i}.ic,1000,0.015, 0.03);
%     waitbarwithtime(i/size(DataSet,1),h);
end

save('backupPS2.mat','PS');