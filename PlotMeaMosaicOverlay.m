function PlotMeaMosaicOverlay(centeredChannel);
%Plots the mosaic image for the first subplot of figure 1. Saves an overlay
%of the MEA mosaic with a tRFP stain located at centeredChannel
load('MeaMapPlot.mat');
image = imread('4269_AAV_OptoA1_p2a_tRFP_550nm2_falseColor_blueBackround.png','PNG');
load('4269_AAV_OptoA1_p2a_tRFP_550nm2_falseColor_blueBackround_LUT.mat');
image = padarray(image,[15 15],130);
%% Create MeaImage
numcol = 1;
test = colormap([lut./255;gray(256)]);
CaImage = zeros(size(MeaImage,1),size(MeaImage,2));
loc = find(MeaMap==centeredChannel);
image2 = imresize(image,0.6175);
offsetx = min(xpos);
offsety = min(ypos);
CaImage(floor(xpos(loc)-size(image2,1)/2-offsetx/2):floor(xpos(loc)+size(image2,1)/2-1-offsetx/2),floor(ypos(loc)-size(image2,2)/2+offsety/2):floor(ypos(loc)+size(image2,2)/2-1+offsety/2))=image2;
CaImage(CaImage<20)=0;

patch = size(CaImage,1)-size(CaImage,2);
if patch~=0
    MeaImage =  padarray(MeaImage,[patch/2 patch/2],min(MeaImage(:)));
end
RGB = ind2rgb(MeaImage,test(numcol*16*16+1:end,:));
RGB2 = ind2rgb(CaImage,test(1:numcol*16*16,:));
imshow(RGB,[]);
set(gca,'ydir','normal');
hold on; h = imshow(RGB2);
set(h, 'AlphaData', CaImage);
axis('off');
print('-depsc2','-r300','Mosaic.eps');

% export_fig MergeCaMEA.png -native
% close all;
% image = imread('MergeCaMEA.png');
% image = imresize(image,[size(MeaImage,1) size(MeaImage,2)]);
end