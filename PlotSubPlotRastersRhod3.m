subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.001], [0.001 0.001], [0.001 0.001]);

for i=1:3
subplot(1,3,i); eval([' imshow(imread(''PrePostRasterRhod3' num2str(i) '.png''),[]);']);
end
set(gcf,'Renderer','zbuffer') ;
figure;
for i=1:13
subplot(3,5,i); eval([' imshow(imread(''PrePostRasterTrim' num2str(i) '.png''),[]);']);
end
set(gcf,'Renderer','zbuffer') ;
