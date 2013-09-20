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

end