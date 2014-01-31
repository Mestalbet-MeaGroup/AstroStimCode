function mov = PlotSpikesAstroTraceMovie(recording,channel,fr,ic,traces)
% Function which plots the calcium imaging movie and the electrode data on
% the same 2D MEA surface. The color of the dots represent the firing rate.

%% Load 2D MEA Surface
% profile -memory on;
image = [];
load('MeaMapPlot.mat');

%% Create Color Scale for Firing Rate
color = cbrewer('seq','YlOrRd',max(fr(:))+1);
colorscale = 0:max(fr(:));

%% Re-arrange firing rate along 2D
elecs  = ic(1,:);
for i=1:numel(MeaMap)
    elecmap = ismember(ic(1,:),MeaMap(i));
    if sum(elecmap)<1
        ActivityMat(i,1:size(fr,1))=zeros(1,size(fr,1));
    else
        ActivityMat(i,1:size(fr,1))=fr(:,elecmap);
    end
end
ActivityMat = reshape(ActivityMat,16,16,size(ActivityMat,2));
ActivityMat (find(ActivityMat==0))=nan;



%% Get Files for Calcium Movie
str = [num2str(recording) ' '  num2str(channel)];
% fileList = getAllFiles(uigetdir('C:\',str));
fileList = getAllFiles('D:\Users\zeiss\Pictures\deleteme\4392_GFAP_gcAMP6_Mcherry_470nm_ch215\');
% fileList = getAllFiles('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Hippo Files\GFAP-GcAMP6\Tiffs\4392_gfap_gcamp6_mcherry_470nm_ch215\');

%% Combine Axes
pos = [5 35 1912 1086];
apos = [0.0875 0.0652681 0.824786 0.899767];
h1=figure('Visible','off','Position',pos);
imshow(MeaImage,gray(256));
set(gca,'YDir','normal');
hMEA = imgca(h1);
freezeColors(hMEA);

h2 = figure('Visible','off');
CaFrame = imread(fileList{1});
imagesc(CaFrame);
set(gca,'yDir','normal');
axis('tight');
axis('off');
hCa = imgca(h2);
freezeColors(hCa);


c1 = squeeze(ActivityMat(:,:,1));
h4 = figure('Visible', 'off','Position',pos);
h = scatter(xpos,ypos,100,c1(:),'fill');
hScat=gca;
set(hScat,'Position',apos);
xlim([0 3087]);
ylim([0 3087]);
% axis('off');
axis('manual');
colormap(color);
freezeColors(hScat);

h3 = figure('Visible', 'on','Position',pos);
% maximize(h3);
copyobj(hCa,h3);
copyobj(hMEA,h3);
copyobj(hScat,h3);

hSubs = get(h3, 'children');
uistack(hSubs(2),'top');
uistack(hSubs(3),'top');
uistack(hSubs(1),'top');
set(hSubs(1),'Position',apos);
set(hSubs(2),'Position',apos,'PlotBoxAspectRatio',[3088,3088,1]);
set(hSubs(3),'Position',[(xpos(MeaMap(:)==channel)-1.89)./max(xpos),(ypos(find(MeaMap(:)==channel)))./max(ypos),(size(CaFrame,2)./size(MeaImage,2))/2,(size(CaFrame,1)./size(MeaImage,1))/2],'PlotBoxAspectRatio',[692,520,1]);
scat=get(h,'children');
set(scat,'CData',c1);

mov = VideoWriter('test.avi','Uncompressed AVI');
mov.FrameRate=14.235;
open(mov);
% wb = waitbarwithtime(0,'Creating Movie File...');
numframes = size(ActivityMat,3);

for frame=1:numframes
    
    CaFrame = imread(fileList{frame});
    c1 = squeeze(ActivityMat(:,:,frame));
    
    scatter(xpos,ypos,100,c1(:),'fill','parent',hSubs(1)); axis('off')
    set(get(hSubs(3),'children'),'CData',CaFrame);
    title(hSubs(2),['Frame ',num2str(frame)]);
    refreshdata;
    drawnow;
        
    frm = hardcopy(gcf, '-dzbuffer', '-r0');
    writeVideo(mov,im2frame(frm));
    
%     waitbarwithtime(frame/numframes,wb);
end
close(mov);

end