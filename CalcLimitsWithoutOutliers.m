function [ymin, ymax]=CalcLimitsWithoutOutliers(pres,posts)

stats = regstats(pres,1:length(pres),'linear');
potential_outlier = stats.cookd > 3/length(pres);
pres(potential_outlier)=mean(pres);
stats = regstats(posts,1:length(posts),'linear');
potential_outlier = stats.cookd > 3/length(posts);
posts(potential_outlier)=mean(posts);
ymax = max([pres,posts]);
ymin = -ymax;
end