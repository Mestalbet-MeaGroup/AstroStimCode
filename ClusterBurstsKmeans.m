function [X,ID,CID] = ClusterBurstsKmeans(X,ID)
% X = NxP
    [CID,c,ins,outs] = kmeans(X,2);
    X1 = X(CID==1,:);
    ID1 = ID(CID==1);
    X2 = X(CID==2,:);
    ID2 = ID(CID==2);
    if size(X1,1)>1
        [X1,ID1,CID1] = ClusterBurstsKmeans(X1,ID1);
    end
    if size(X2,1)>1
        [X2,ID2,CID2] = ClusterBurstsKmeans(X2,ID2);
    end
    X = [X1;X2];
    ID = [ID1;ID2];
%     CID=[CID1;CID2];
end
