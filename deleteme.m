dbsPre=[];
dbsPost=[];
gPre =[];
gPost = [];
for k=1:13
    temp = diff(sort([DataSetBase{k}.bs,DataSetBase{k}.sb_bs]))./12000;
    dbsPre=[temp,dbsPre];
    gPre = [gPre,ones(size(temp))*k];
    temp = diff(sort([DataSetStims{k}.bs,DataSetStims{k}.sb_bs]))./12000;
    dbsPost=[temp,dbsPost];
    gPost = [gPost,ones(size(temp))*k];
end

k=7;PlotRasterWithBursts(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,sort([DataSetStims{k}.Trim.bs,DataSetStims{k}.sb_bs]),sort([DataSetStims{k}.Trim.be,DataSetStims{k}.sb_be]));

k=7;PlotRasterWithBursts(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,DataSetStims{k}.sb_bs,DataSetStims{k}.sb_be)

 [bs1,be1] = FindBurstsWithinSBs(DataSetBase{k}.Trim.t,DataSetBase{k}.Trim.ic,min(DataSetBase{k}.Trim.t),max(DataSetBase{k}.Trim.t),k,kk,'base',sum(k==dpass));
 
 channelB= ConvertIC2Samora(DataSetStims{k}.Trim.ic);
 timeB = round(DataSetStims{k}.Trim.t)./12000;
 [binB,rateB] = EstimateGlobalRate(channelB,timeB,0.05);

 
 PlotRasterWithBursts(DataSetStims{k}.Trim.t,DataSetStims{k}.Trim.ic,bs2)
 
 
Gx = [-1 1];
Gy = Gx';
[~,ia,ib]=unique(channelB,'stable');
% mSpkChan=max(diff(find(diff([1;ib]))));
I = sparse(max(ib),max(timeB));
for i=1:max(ib)
    I(i,timeB(ib==i))=1;
end
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');
edgeFIS = newfis('edgeDetection');
edgeFIS = addvar(edgeFIS,'input','Ix',[-1 1]);
edgeFIS = addvar(edgeFIS,'input','Iy',[-1 1]);
sx = 0.1; sy = 0.1;
edgeFIS = addmf(edgeFIS,'input',1,'zero','gaussmf',[sx 0]);
edgeFIS = addmf(edgeFIS,'input',2,'zero','gaussmf',[sy 0]);
edgeFIS = addvar(edgeFIS,'output','Iout',[0 1]);
wa = 0.1; wb = 1; wc = 1;
ba = 0; bb = 0; bc = .7;
edgeFIS = addmf(edgeFIS,'output',1,'white','trimf',[wa wb wc]);
edgeFIS = addmf(edgeFIS,'output',1,'black','trimf',[ba bb bc]);
r1 = 'If Ix is zero and Iy is zero then Iout is white';
r2 = 'If Ix is not zero or Iy is not zero then Iout is black';
r = char(r1,r2);
edgeFIS = parsrule(edgeFIS,r);
Ieval = zeros(size(I));% Preallocate the output matrix
for ii = 1:size(I,1)
    Ieval(ii,:) = evalfis([(Ix(ii,:));(Iy(ii,:));]',edgeFIS);
end