function [cmap,Z1] = MeaColorMap()

[X,Y] = meshgrid(1:1:16);
val=linspace(1,255,4);
Z =[ones(8,8)*val(1),ones(8,8)*val(2);ones(8,8)*val(3),ones(8,8)*val(4)];
Z1 =  filtfilt(MakeGaussian(0,2,3),1,Z);
Z1 =  filtfilt(MakeGaussian(0,2,3),1,Z1');
numVals = numel(unique(Z1(:)));
pcolor(X,Y,Z1); %shading interp;
% cmap = colormap(jet(255));
cmap = colormap(cbrewer('div', 'Spectral', numVals));
set(gcf,'ColorMap',cmap);
%% Colormap II
% Z =  [...
%     1,     2,     3,     4,     5,     6,     7,     8;...
%     2,     2,     3,     4,     5,     6,     7,     8;...
%     3,     3,     3,     4,     5,     6,     7,     8;...
%     4,     4,     4,     4,     5,     6,     7,     8;...
%     5,     5,     5,     5,     5,     6,     7,     8;...
%     6,     6,     6,     6,     6,     6,     7,     8;...
%     7,     7,     7,     7,     7,     7,     7,     8;...
%     8,     8,     8,     8,     8,     8,     8,     8;];
% [X,Y] = meshgrid(1:1:16);
% % Z=flipud(Z);
% Z1 = [[rot90(Z,-2);rot90(Z,-1)+8],[rot90(Z)+2*8;Z+3*8]];
% cmap = [(cbrewer('seq', 'Purples', 8));cbrewer('seq', 'Greens', 8);cbrewer('seq', 'Reds', 8);cbrewer('seq', 'Blues', 8)];
% pcolor(X,Y,Z1);
% set(gcf,'ColorMap',cmap);

%% Colormap III

end