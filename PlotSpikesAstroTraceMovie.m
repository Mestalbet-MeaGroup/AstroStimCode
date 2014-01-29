function mov = PlotSpikesAstroTraceMovie(recording,channel,fr,ic,traces)
% Function which plots the calcium imaging movie and the electrode data on
% the same 2D MEA surface. The color of the dots represent the firing rate.

%% Load 2D MEA Surface
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


%% Plot MEA Mosaic
h1=figure('Visible','off');
imshow(MeaImage,gray(256));
set(gca,'YDir','normal');
hMEA = imgca(h1);
freezeColors(hMEA);

%% Get Files for Calcium Movie
str = [num2str(recording) ' '  num2str(channel)];
% fileList = getAllFiles(uigetdir('C:\',str));
fileList = getAllFiles('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Hippo Files\GFAP-GcAMP6\Tiffs\4384_ch242\');
%% Plot first Ca Image Frame
i=1;
CaFrame = imread(fileList{i});
h2 = figure('Visible','off');
imshow(CaFrame,jet(256*256));
hCa = imgca(h2);
freezeColors(hCa);
set(hCa,'position',[xpos(MeaMap(:)==channel)./max(xpos),ypos(MeaMap(:)==channel)./max(ypos),(size(CaFrame,2)./size(MeaImage,2))/2,(size(CaFrame,1)./size(MeaImage,1))/2]);

%% Combine Axes
h3 = figure('Visible', 'Off');
copyobj(hCa,h3);
copyobj(hMEA,h3);
hSubs = get(h3, 'children');
uistack(hSubs(2),'top');
close(h1);close(h2);


%% Generate Movie (of FR and Ca frames)
hold(hSubs(1));
c1 = ActivityMat(:,:,1);
h = scatter(xpos,ypos,100,c1(:),'fill', 'Parent',hSubs(1),'Visible','Off');
colormap(color);
freezeColors(h);
az = 0;
el = 90;
view(az, el);
set(h,'CDataSource','c1');
mov = VideoWriter('test.avi','Uncompressed AVI');
mov.FrameRate=14.235;
open(mov);
% set(gcf,'Visible','off');
for frame=1:size(ActivityMat,3)
    CaFrame = imread(fileList{frame});
    h2 = figure('Visible','off');
    imshow(CaFrame,jet(256));
    hCa = imgca(h2);
    freezeColors(hCa);
    set(hCa,'position',[xpos(MeaMap(:)==channel)./max(xpos),ypos(MeaMap(:)==channel)./max(ypos),(size(CaFrame,2)./size(MeaImage,2))/2,(size(CaFrame,1)./size(MeaImage,1))/2]);
    copyobj(hCa,h3);
    close(h2);
    c1 = squeeze(ActivityMat(:,:,frame));
    c1=c1(:);
    refreshdata(h,'caller'); 
    drawnow;  
    title(hSubs(1),['Frame ',num2str(frame)]);
    frm = hardcopy(gcf, '-dzbuffer', '-r0');
    writeVideo(mov,im2frame(frm));
end
close(mov);

end

