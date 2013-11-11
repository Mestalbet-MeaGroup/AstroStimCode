function [CdfX,CdfY,X,Y]=CalcCdf(vec)
% Calculates the cumulative density function 
[CdfY,CdfX,flo,fup] = ecdf(vec,'Function','cdf');
CdfX=CdfX(2:end)';
CdfY=CdfY(2:end)';
flo=flo(2:end)';
fup=fup(2:end)';
% xPred = fitdist(vec, 'lognormal');
% [yPred,YLower,YUpper] = cdf(xPred,CdfX);
X = [CdfX,fliplr(CdfX)]; 
Y = [flo(1:end-1),CdfY(end),CdfY(end), fliplr(fup(1:end-1))];
% hold on;
% loglog(CdfX,CdfY,'ok','MarkerSize',4,'MarkerFaceColor','b','MarkerEdgeColor','b');
% patch(X,Y,'b','FaceAlpha',0.2,'EdgeColor','b');
end