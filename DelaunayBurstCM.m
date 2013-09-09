function [dists,Mean_dists,Max_dists,Min_dists]=DelaunayBurstCM(x,y)
% Calculates the distances between burst starts based on the Delaunay triangulation
% method. Ignores edge soma by discarding the soma within 5% of total
% dimensions from the edge. 
for i=1:length(x)
    dists=[];
    Max_dists=[];
    Min_dists=[];
    Mean_dists=[];
    pcnt=0.0;
%     x=data{i,1}(:,1);
%     y=data{i,1}(:,2);
    DT = DelaunayTri(x,y);
    xv=[min(x)+pcnt*max(x);min(x)+pcnt*max(x);max(x)-pcnt*max(x);max(x)-pcnt*max(x)]; % Create inner block of soma's. 
    yv=[min(y)+pcnt*max(y);max(y)-pcnt*max(y);max(y)-pcnt*max(y);min(y)+pcnt*max(y)];
    IN = inpolygon(x,y,xv,yv);
    
    for j=1:size(DT,1)
        if IN(DT(j,1))&&IN(DT(j,2))&&IN(DT(j,3))
            A(:,1)= [x(DT(j,1));y(DT(j,1))];
            A(:,2)= [x(DT(j,2));y(DT(j,2))];
            A(:,3)= [x(DT(j,3));y(DT(j,3))];
            dists=[dists; pdist(A')];
            Mean_dists=[Mean_dists; mean(pdist(A'))];
            Max_dists=[Max_dists; max(pdist(A'))];
            Min_dists=[Min_dists; min(pdist(A'))];
        end
    end
%     dists1{i}=reshape(dists,size(dists,1)*size(dists,2),1);
%     Max_dists1{i}=reshape(Max_dists,size(Max_dists,1)*size(Max_dists,2),1);
%     Min_dists1{i}=reshape(Min_dists,size(Min_dists,1)*size(Min_dists,2),1);
%     Mean_dists1{i}=reshape(Mean_dists,size(Mean_dists,1)*size(Mean_dists,2),1);
%     save(['distances_' data{i,2} '_' num2str(i) '.mat'],'dists');
end
%Number of Pixels in 200um = 307.5790

end