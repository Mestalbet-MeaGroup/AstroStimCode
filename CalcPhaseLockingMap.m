function  CalcPhaseLockingMap(t,ic,MeaMap)


% This function plots the correlation \ PS matrix on the physical structure

%------------------- Inputs -----------------------------------------------
% PhysMat is a map of the electrodes in the recording apperatus (the
% physical location of the recorded neurons. PhysMat(i,j) holds the neuron
% number in the Correlation Matrix (1..N) or 0 if there is no valid neuron
% in this place.


% "CorrMat" - Is the N by N correlation matrix. I assume all data is valid (this code performs no checks on data validity).

% "th" - is the threshold for linking points in the affinity space. Two
% channels whose correlation is higher then the threshold would be linked by a line.
% The color of the line and its thickness would be according to the correlation value.
CorrMat=Zphase_synchronization(t./1200,ic,min(t)./1200,(max(t)-min(t))./1200);
% vals = triu(CorrMat,1);
% vals(vals==0)=nan;
% th = nanmean(vals(:))+7*sqrt(nanvar(vals(:)));



[PhysRow,PhysCol,NeuronNum] = find(MeaMap);
[NeuronNum, X] = sort(NeuronNum);
PhysRow = PhysRow(X) ;
PhysCol = PhysCol(X) ;

% cmap = colormap('jet');
% rCorrMat = triu(CorrMat,1);
% rCorrMat(rCorrMat<th)=nan;
% if sum(~isnan(rCorrMat(:)))<10
    rCorrMat = triu(CorrMat,1);
    vals = triu(CorrMat,1);
    vals(isnan(vals))=0;
    th=sort(unique(vals(:)),'descend');
    th=th(11);
    rCorrMat(rCorrMat<th)=nan;
% end

numColors = unique(rCorrMat(:));
numColors(isnan(numColors))=[];
numColors=numel(numColors);
if numel(numColors)>5
    rCorrMat = otsu(rCorrMat,numColors);
else
    rCorrMat = otsu(rCorrMat,10);
end

cmap = colormap(fliplr(cbrewer('seq','PuBuGn',numColors)));
rCorrMat=rCorrMat+rCorrMat';
N = length(CorrMat);
% Plot the location of each neuron in the real space
figure
spy(MeaMap,'o',10) ;
hold on;

%Plot the lines connecting the channels (above the threshold)
for i=1:N
    for j=1:i-1
        if (abs(CorrMat(i,j))>=th)
            %                         display(rCorrMat(i,j)+1);
            line([PhysCol(i),PhysCol(j)],[PhysRow(i),PhysRow(j)],'color',cmap(rCorrMat(i,j),:),'linewidth',4*CorrMat(i,j));
            hold on ;
        end
    end
end
grid on
colormap(cmap);
colorbar;
%add electrode numbers
for i=1:16
    for j=1:16
        str=num2str(MeaMap(i,j));
        text(j-0.4,i-0.3,['\color{black} \fontsize{8}' str],'FontWeight','bold');
    end
end
end