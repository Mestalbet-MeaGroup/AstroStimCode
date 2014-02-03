function PlotSpikesAstroTraceMovie(recording,channel,fr,ic,traces)
% Function which plots the calcium imaging movie and the electrode data on
% the same 2D MEA surface. The color of the dots represent the firing rate.

%% Load 2D MEA Surface
% profile -memory on;
image = [];
load('MeaMapPlot.mat');

%% Create Color Scale for Firing Rate
color = cbrewer('seq','YlOrRd',max(fr(:))+1);

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
% fileList = getAllFiles('D:\Users\zeiss\Pictures\deleteme\4392_GFAP_gcAMP6_Mcherry_470nm_ch215\');
fileList = getAllFiles('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Hippo Files\GFAP-GcAMP6\Tiffs\4392_gfap_gcamp6_mcherry_470nm_ch215\');

%% Combine Axes
pos = [5 35 1912 1086];

% Plot MEA Mosaic
h1=figure('Visible','on','Position',pos);
imshow(MeaImage,gray(256));
hMEA = imgca(h1);
set(hMEA,'YDir','normal');
axis('tight');
axis('off');
apos = get(hMEA,'position');
freezeColors(hMEA);
hold(hMEA,'on');
xsize = size(MeaImage,1);
ysize = size(MeaImage,2);

% Plot Scatter Plot of Activity Frame
% c1 = squeeze(ActivityMat(:,:,1));
c1=nan(16,16);
centeredon = find(MeaMap==channel);
c1(centeredon)=1000;
scatter(xpos,ypos,100,c1(:),'fill','parent',hMEA);% Xpos and Ypos order are not correct. Must recreate vectors. 
colormap(color);
hScat=gca;
freezeColors(hScat);
axis('off');
uistack(hMEA,'up');
hold off;

%Xpos and Ypos order are not correct. Must recreate vectors. 

% Plot Ca Trace Frame
xsize = size(MeaImage,1);
ysize = size(MeaImage,2);
xposPer=xpos./xsize;
yposPer=ypos./ysize;
CaFrame = imread(fileList{1});
CaFrame=imresize(CaFrame',0.62);
[hCa ~] = axesRelative(hMEA, ...
    'Units','normalized', 'Position',...
    [xposPer(centeredon)-0.5*size(CaFrame,1)/xsize,yposPer(centeredon)-0.5*size(CaFrame,2)/ysize, size(CaFrame,1)/xsize,size(CaFrame,2)/ysize]);
imagesc(CaFrame);
CaColor = jet(65536);
colormap(CaColor);
set(hCa,'yDir','normal');
axis('tight');
axis('off');
freezeColors(hCa);

% Positions are not correct

hSubs = get(h1,'children');
hSubSub = get(hSubs(2),'children');
set(hSubSub(1),'CDataSource','c1');

MovieName = ['CombinedCaMEA_' num2str(recording) '_ch' num2str(channel)];
mov = VideoWriter(MovieName,'MPEG-4');
% mov.FrameRate=14.235;
mov.FrameRate=1;
open(mov);

numframes = size(ActivityMat,3);
for frame=1:numframes
    
    if frame==30
        set(h1,'visible','off');
    end
        
    CaFrame = imread(fileList{frame})';
    c1 = squeeze(ActivityMat(:,:,frame));
    c1=c1(:);
    refreshdata(hSubSub(1),'caller');
    colormap(color); freezeColors(hSubSub(1));
    
    set(get(hSubs(1),'children'),'CData',CaFrame); 
    colormap(CaColor); 
    freezeColors(hSubs(1));
    
    title(hMEA,['Frame ',num2str(frame)]);
    drawnow;
        
    frm = hardcopy(gcf, '-dzbuffer', '-r0');
    writeVideo(mov,im2frame(frm));
    

end
close(mov);

end