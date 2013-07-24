subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.001], [0.001 0.001], [0.001 0.001]);

for i=1:9
subplot(3,5,i); eval([' imshow(imread(''PrePostRaster0' num2str(i) '.png''),[]);']);
end

for i=10:13
subplot(3,5,i); eval([' imshow(imread(''PrePostRaster' num2str(i) '.png''),[]);']);
end
set(gcf,'Renderer','zbuffer') ;
eval(['print(gcf,' '''-r600''' ',' '''-dpng'','''  'PrePostRaster' '.png'');']);