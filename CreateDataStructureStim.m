%% Create file list

fileList = getAllFiles(uigetdir); % select directory with Mat files containing t,ic, time, data variables
counter=1;
counter2=counter;
counter3=counter;
for i=1:size(fileList,1)
    k = findstr(fileList{i}, 'baseline');
    k1 = findstr(fileList{i}, 'baseline1');
    kk = findstr(fileList{i}, 'post');
    kk1 = findstr(fileList{i}, 'Post');
    
    if (~isempty(k)||~isempty(k1))&&( isempty(kk)||isempty(kk1) )
        baselines(counter) = i;
        counter=counter+1;
    else if ~(~isempty(kk)||~isempty(kk1))
            stims(counter3)=i;
            counter3=counter3+1;
        end
    end
    
%     if ~isempty(kk)||~isempty(kk1)
%         posts(counter2)=i;
%         counter2=counter2+1;
%     end
end
% end

% fileListStims=fileList(stims);
% fileListPosts=fileList(posts);
% fileListBases=fileList(baselines);
% vec = [1:length(fileListStims), 1:length(fileListPosts),1:length(fileListBases)];

% stimIndex = []; %Place in fileList past which data is for stimulation period
% postIndex = []; %Place in fileList past which data is for post- stimulation period
DataSet = cell(length(fileList),1); %take off comment

% if ~exist('DataSet.mat', 'file')  % Checks to make sure an old file is not overwritten without being backed up.
%     save('DataSet.mat','DataSet');
% else
%     java.io.File('DataSet.mat').renameTo(java.io.File('DataSetOld.mat'));
%     save('DataSet','DataSet');
% end

for ii=1:size(fileList,1)
    %% Load Data
    
    if ~isempty(find(ii==baselines, 1))
        DataSet{ii}.base = 1;
    else
        DataSet{ii}.base = 0;
    end
    
    if ~isempty(find(ii==stims, 1))
        DataSet{ii}.stim = 1;
    else
        DataSet{ii}.stim = 0;
    end
    
%     if ~isempty(find(ii==posts, 1))
%         DataSet{ii}.post = 1;
%     else
%         DataSet{ii}.post = 0;
%     end
    
    load(fileList{ii});
    k = findstr(fileList{ii}, '\');
    k=k(end)+1;
    eval(['DataSet{' num2str(ii) '}.Record=fileList{' num2str(ii) '}(k:end-4)']);
    DataSet{ii}.t            = t; % Spike times arranged by channel
    DataSet{ii}.ic           = ic; % Index in t of channel start times
    DataSet{ii}.time         = min(t)/12000:0.04:max(t)/12000; % Calculates time vector at 25hz sampling
    display('Completed Loading Data...');
    %% Calculates Firing Rate for each electrode
    display('Calculating firing rates...');
    for i=1:size(ic,2)
        t1=sort(t(ic(3,i):ic(4,i)))./12;
        %         DataSet{ii}.FR(:,i)  = histc(t1,DataSet{ii}.time*1000);   % Calculate the firing rate for each electrode
        DataSet{ii}.FR(:,i)  =  histc(t1,0:120:max(t));
    end
    DataSet{ii}.GFR          = mean(DataSet{ii}.FR,2); % Mean firing rate
    
    [DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw,DataSet{ii}.sbs,DataSet{ii}.sbe,DataSet{ii}.sbw]=UnsupervisedBurstDetection2(DataSet{ii}.t,DataSet{ii}.ic);
    %% All Calculations From Manual Trace Extraction
    %     display('Calculating correlation between neurons...');
    %     DataSet{ii}.cc              = CalculateN2Ncc(DataSet{ii}.t,DataSet{ii}.ic); % Neuron to neuron cross-correlation
    %     [~,DataSet{ii}.ccOrder,~]   = DendrogramOrderMatrix2(DataSet{ii}.n2n.cc ); % Dendogram order of matrix
    %     clear_all_but('DataSet','fileList','ii');
    %     save('DataSet','DataSet','-append');
end
clear_all_but('DataSet');
save('DataSetStim.mat','DataSet');
