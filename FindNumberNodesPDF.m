function numNodes  = FindNumberNodesPDF(pdf);

% im=otsu(pdf,4);
% CMs = regionprops( im==4 ,'Centroid');
grd = gradient(pdf);
temp = imextendedmax(pdf,max(grd(:))*0.9);
numNodes = bweuler(temp,4);
% temp=(pdf>=0.02);
% numNodes = size(CMs,1);
% numNodes = sum(temp(:));
% numNodes = bweuler(pdf>=(mean(pdf(:))+2*std(pdf(:))),4); 

end
% 
% for i=1:size(pdfpre,2)
%    corr  = corr2(pdfpre{i},pdfpost{i});
%    cor(i) = max(corr(:));
%     numNodesPre(i)  = FindNumberNodesPDF(pdfpre{i});
%     numNodesPost(i)  = FindNumberNodesPDF(pdfpost{i});
%     
% end
% 
% bar([numNodesPre;numNodesPost]');