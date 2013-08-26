%% Create file list

fileList = getAllFiles(uigetdir); % select directory with Mat files containing t,ic, time, data variables
baselines=[];
stims=[];
for i=1:size(fileList,1)
    pos=findstr(fileList{i},'\');
    pos=pos(end);
    k = findstr(fileList{i}(pos:end), 'baseline');
    kk = findstr(fileList{i}(pos:end), 'Rhod3');
    
    if (~isempty(k))&&(isempty(kk))
        baselines = [baselines;i];
    end
    if ~isempty(kk)&&isempty(k)
        stims=[stims;i];
    end
    
end

DataSet = cell(length(fileList),1); %take off comment

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
end
clear_all_but('DataSet');
