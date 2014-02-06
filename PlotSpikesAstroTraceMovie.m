function PlotSpikesAstroTraceMovie(recording,channel,fr,ic,mask,trace,time,gfr)
% Function which plots the calcium imaging movie and the electrode data on
% the same 2D MEA surface. The color of the dots represent the firing rate.

%% Load 2D MEA Surface
% profile -memory on;
image = [];
load('MeaMapPlot.mat');
% trace = inpaint_nans(trace,4)+abs(min(trace(:)));
%% Create Color Scale for Firing Rate
color = cbrewer('seq','YlOrRd',max(fr(:)));
% color = [[0,0,0];color];
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
% fileList = getAllFiles('E:\CalciumImagingArticleDataSet\GcAMP6 Data\Hippo Files\GFAP-GcAMP6\Tiffs\4392_gfap_gcamp6_mcherry_470nm_ch215\');

%% Combine Axes
pos = [5 35 1912 1086];

% Plot MEA Mosaic
h1=figure('Visible','on','Position',pos);

imshow(MeaImage,gray(256));
% imshow(imread('MeaMosaicJustElectrodes.tif'),gray(2));
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
c1(centeredon)=30;
scatter(xpos,ypos,100,c1(:),'fill','parent',hMEA);% Xpos and Ypos order are not correct. Must recreate vectors. 
colormap(color); set(gca,'clim',[0,63]);
hScat=gca;
freezeColors(hScat);
axis('off');
uistack(hMEA,'up');
hold off;

% Plot Ca Trace Frame
xsize = size(MeaImage,1);
ysize = size(MeaImage,2);
xposPer=xpos./xsize;
yposPer=ypos./ysize;
% CaFrame = imread(fileList{floor(end/2)});
CaFrame = GranulateCaFrame(mask,trace,1);
CaFrame=imresize(CaFrame,0.62);
[hCa ~] = axesRelative(hMEA, ...
    'Units','normalized', 'Position',...
    [xposPer(centeredon)-0.5*size(CaFrame,1)/xsize,yposPer(centeredon)-0.5*size(CaFrame,2)/ysize, size(CaFrame,1)/xsize,size(CaFrame,2)/ysize]);
imagesc(CaFrame);
CaColor = flipud(cbrewer('div','RdGy',16));
CaColor(1:3,:)=repmat(CaColor(1,:),3,1);
colormap(CaColor);
set(hCa,'yDir','normal');
axis('tight');
axis('off');
freezeColors(hCa);

hSubs = get(h1,'children');
hSubSub = get(hSubs(2),'children');
set(hSubSub(1),'CDataSource','c1');

[hTraces ~] = axesRelative(hMEA, ...
    'Units','normalized', 'Position',...
    [0/xsize,-120/ysize, xsize/xsize,200/ysize]);
[hFR ~] = axesRelative(hMEA, ...
    'Units','normalized', 'Position',...
    [0/xsize,(ysize-100)/ysize, xsize/xsize,200/ysize]);

x=300;
frame = 1;
astro = 7;
xvals = time(frame:x+frame);
yTr = trace(frame:x+frame,astro)+eps;
yFr = gfr(frame:x+frame)+eps;
hTr = plot(hTraces,xvals, yTr);
hFr = plot(hFR,xvals, yFr);
set(hTraces,'xlim',[xvals(1),xvals(end)]);
set(hFR,'XTickLabel',[],'xlim',[xvals(1),xvals(end)],'ylim',[min(yFr),15]);

set(hTr,'xdatasource','xvals','ydatasource','yTr');
set(hFr,'xdatasource','xvals','ydatasource','yFr');

MovieName = ['CombinedCaMEA_' num2str(recording) '_ch' num2str(channel)];

numframes = size(ActivityMat,3);
upto = floor(linspace(1,numframes,16));

mov = VideoWriter(MovieName,'Motion JPEG AVI');
% mov.FrameRate=14.235;
mov.FrameRate=1;
open(mov);

numframes = size(ActivityMat,3);
for frame=12280:numframes-x
    
%     if frame==30
%         set(h1,'visible','off');
%     end
%     
    c1 = squeeze(ActivityMat(:,:,frame));
    c1=c1(:);
    refreshdata(hSubSub(1),'caller');
    colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
    
    CaFrame = GranulateCaFrame(mask,trace,frame);
%     CaFrame = imread(fileList{frame})';
%     CaFrame = double((CaFrame).*uint16(~mask'));
%     CaFrame(CaFrame==0)=nan;
%     CaFrame = blockproc(CaFrame,[floor(692/4) floor(520/4)],fun);
    CaFrame = imresize(CaFrame,0.62);
    set(get(hCa,'children'),'CData',CaFrame);
    colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
    
    xvals = time(frame:x+frame);
    yTr = trace(frame:x+frame,astro)+eps;
    yFr = gfr(frame:x+frame)+eps;
    set(hTraces,'xlim',[xvals(1),xvals(end)],'ylim',[min(trace(:,astro)),max(trace(:,astro))]);
    set(hFR,'xlim',[xvals(1),xvals(end)],'ylim',[min(yFr),15]);
    refreshdata(hFr,'caller');
    refreshdata(hTr,'caller');
%     title(hMEA,['Frame ',num2str(frame)]);
    drawnow;
        
    frm = hardcopy(gcf, '-dzbuffer', '-r0');
    writeVideo(mov,im2frame(frm));
    

end
close(mov);

% Attempt to parralelize but figure production doesn't work in parallel. 
% spmd (8)
%     switch labindex
%         case 1
%             mov1 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov1.FrameRate=1;
%             open(mov1);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov1,im2frame(frm));
%                 
%             end
%             close(mov1);
%         case 2
%             mov2 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov2.FrameRate=1;
%             open(mov2);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov2,im2frame(frm));
%                 
%             end
%             close(mov2);
%         case 3
%             mov3 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov3.FrameRate=1;
%             open(mov3);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov3,im2frame(frm));
%                 
%             end
%             close(mov3);
%         case 4
%             mov4 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov4.FrameRate=1;
%             open(mov4);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov4,im2frame(frm));
%                 
%             end
%             close(mov4);
%         case 5
%             mov5 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov5.FrameRate=1;
%             open(mov5);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov5,im2frame(frm));
%                 
%             end
%             close(mov5);
%         case 6
%             mov6 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov6.FrameRate=1;
%             open(mov6);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov6,im2frame(frm));
%                 
%             end
%             close(mov6);
%         case 7
%             mov7 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov7.FrameRate=1;
%             open(mov7);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov7,im2frame(frm));
%                 
%             end
%             close(mov7);
%         case 8
%             mov8 = VideoWriter([MovieName num2str(labindex)],'Motion JPEG AVI');
%             mov8.FrameRate=1;
%             open(mov8);
%             numframes = size(ActivityMat,3);
%             for frame=upto(labindex):upto(labindex+1)
%                 
%                 c1 = squeeze(ActivityMat(:,:,frame));
%                 c1=c1(:);
%                 refreshdata(hSubSub(1),'caller');
%                 colormap(color);  set(gca,'clim',[0,63]); freezeColors(hSubSub(1));
%                 
%                 CaFrame = GranulateCaFrame(mask,trace,frame);
%                 CaFrame = imresize(CaFrame,0.62);
%                 set(get(hCa,'children'),'CData',CaFrame);
%                 colormap(CaColor); set(hCa,'clim',[nanmean(trace(:)),max(trace(:))]); freezeColors(get(hCa,'children'));
%                 
%                 title(hMEA,['Frame ',num2str(frame)]);
%                 drawnow;
%                 
%                 frm = hardcopy(gcf, '-dzbuffer', '-r0');
%                 writeVideo(mov8,im2frame(frm));
%                 
%             end
%             close(mov8);
%     end
% end
end