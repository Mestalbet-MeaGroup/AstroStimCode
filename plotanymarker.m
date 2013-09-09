function plotanymarker(x,y,m);


% Use TEXT to plot the character along the data
text(x,y,m);
% 
% % Manually set axis limits, since TEXT does not do this for you
xlim([min(x) max(x)])
ylim([min(y) max(y)])
end