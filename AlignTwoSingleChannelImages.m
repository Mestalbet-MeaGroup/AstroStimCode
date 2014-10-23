function AlignTwoSingleChannelImages(path1,path2,thresh);
% Align images
%'E:\AstroStimArticleDataSet\Control\ICC\FixedImaging\ICC_alighnTest.tif'
%'E:\AstroStimArticleDataSet\Control\ICC\LiveImaging\CS1_pGFAP_Mcherry_LiveMosaic_Merged.png'
icc = imread(path1);
live = imread(path2);

original=icc(:,:,1);
distorted = live(:,:,1);
if thresh==1
    original = otsu(original,45);
%     original = max(original(:))-original;
    original(original<25)=0;
    original = uint8(original);
    distorted = otsu(distorted,45);
%     distorted = max(distorted(:))-distorted;
    distorted(distorted<25)=0;
    distorted = uint8(distorted);
end
o = registration.optimizer.OnePlusOneEvolutionary;
m = registration.metric.MattesMutualInformation();
m.NumberOfHistogramBins = 500;
o.InitialRadius = 0.001;
o.Epsilon = 1.5e-6;
o.GrowthFactor = 1.01;
o.MaximumIterations = 300;
tform = imregtform(original,distorted,'affine',o,m);
iccM = imwarp(icc(:,:,1),tform,'OutputView',imref2d(size(original)));
% p0='F:\ICC\CutOutForFigure\Stack0000.tif';
% p1='F:\ICC\CutOutForFigure\Stack0001.tif';
% ip0=imread(p0);
% ip1=imread(p1);
% ip0 = imwarp(ip0(:,:,1),tform,'OutputView',imref2d(size(original)));
% ip1 = imwarp(ip1(:,:,1),tform,'OutputView',imref2d(size(original)));
% imwrite(ip0,'F:\ICC\CutOutForFigure\map2.tif');
% imwrite(ip1,'F:\ICC\CutOutForFigure\aGFAP.tif');
% imwrite(live(:,:,1),'F:\ICC\CutOutForFigure\Mcherry.tif');
% imwrite(iccM,'F:\ICC\CutOutForFigure\aGS.tif');

% imwrite(imfuse(iccM(:,:,1),live(:,:,1),'falsecolor','Scaling','independent','ColorChannels',[1 2 0]),['testMerge.png']);
figure, imshowpair(iccM(:,:,1),live(:,:,1));
% originalM = imwarp(original,tform,'OutputView',imref2d(size(original)));
% d2 = originalM+distorted;
% o2=imread('F:\ICC\Mosaic By Channel\CS4_Mosaic_Live_pGFAPmcherry.png');
% tform = imregtform(o2,d2,'affine',o,m);
% o2M = imwarp(o2,tform,'OutputView',imref2d(size(original)));
% figure, imshowpair(o2M,d2)
% imwrite(imfuse(o2M,d2,'falsecolor','Scaling','independent','ColorChannels',[1 2 0]),['testMerge.png']);
% c = normxcorr2(o2M,d2);
% c1 = normxcorr2(originalM,distorted);
end