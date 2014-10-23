function AlignTwoColorImages(path1,path2,thresh);
% Align images
%'E:\AstroStimArticleDataSet\Control\ICC\FixedImaging\ICC_alighnTest.tif'
%'E:\AstroStimArticleDataSet\Control\ICC\LiveImaging\CS1_pGFAP_Mcherry_LiveMosaic_Merged.png'
icc = imread(path1);
live = imread(path2);

original=icc(:,:,1);
distorted = live(:,:,1);
if thresh==1
    original = otsu(original,45);
    original = max(original(:))-original;
    original(original<15)=0;
    original = uint8(original);
    distorted = otsu(distorted,45);
    distorted = max(distorted(:))-distorted;
    distorted(distorted<15)=0;
    distorted = uint8(distorted);
end
o = registration.optimizer.OnePlusOneEvolutionary;
m = registration.metric.MattesMutualInformation();
m.NumberOfHistogramBins = 500;
o.InitialRadius = 0.003;
o.Epsilon = 1.5e-6;
o.GrowthFactor = 1.01;
o.MaximumIterations = 300;
tform = imregtform(original,distorted,'affine',o,m);
iccM = imwarp(icc,tform,'OutputView',imref2d(size(original)));

imwrite(imfuse(iccM(:,:,2),live(:,:,2),'falsecolor','Scaling','joint','ColorChannels',[1 2 0]),[path1(1:end-4),'_merged',path1(end-3:end)]);
imwrite(imfuse(iccM(:,:,1),live(:,:,1),'falsecolor','Scaling','joint','ColorChannels',[1 2 0]),[path1(1:end-4),'_merged2',path1(end-3:end)]);

end