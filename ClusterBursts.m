function [clusters,performance]=ClusterBursts(input,checkperformance, varargin)
% Solve a Clustering Problem with a Self-Organizing Map
% Input = SpikeOrder
% checkperformance (if ==1, then checks performance for increase number of
% epochs. Otherwise just calculates for 2000 epochs all burst metrics)
% varargin = different burst propagation metrics (same size as spikeorder)
performance = [];
clusters=[];
% input = input';
input(isnan(input))=0;

sizes = 100:500:5000;

%% Create a Self-Organizing Map
% dimension1 = ceil(sqrt(size(input,2)))-1;
% dimension2 = ceil(sqrt(size(input,2)));
dimension1=5;
dimension2=5;
net = selforgmap([dimension1 dimension2],500,3,'randtop','linkdist');
net.performParam.regularization = 0.01;
net.performParam.normalization = 'percent';
net.trainParam.showWindow = false;
net.divideFcn = 'dividerand';
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;



%% Check Performance
for j=1:size(varargin,2)
    
    inputcompare = varargin{j};%';
    inputcompare(isnan(inputcompare))=0;
    
    % Train the Network
    if checkperformance
        for i=1:numel(sizes)
            
            net.trainParam.epochs = sizes(i);
            [net,tr] = train(net,input);
            targets = net(input);
            [net1,tr1] = train(net,inputcompare,targets);
            outputs = net(inputcompare);
            % errors(i) = gsubtract(targets,outputs);
            performance(i,j) = perform(net,targets,outputs);
        end
    else
        if j==1
            net.trainParam.epochs = 5000;
            [net,tr] = train(net,input);
            output = net(input);
            clusters(:,1)=vec2ind(output);
        end
        
        [net,tr] = train(net,inputcompare);
        output = net(inputcompare);
        [clusters(:,j+1),~]=find(output);
        
    end
    
end