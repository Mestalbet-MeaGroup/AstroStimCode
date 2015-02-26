function DataSet=CreateDextranDataSet();

DataSet{1} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\SingleStim\4741_ch196_chr2_gcamp_SingleStim.mat');
DataSet{2} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\Dextran\4741_Chr2Mcherry_GcamP_postStimyesterday_baseline2.mat');
DataSet{3} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\Dextran\4741_Chr2Mcherry_GcamP_postStimyesterday_baseline2_Dextran.mat');
DataSet{4} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\Dextran\4741_Chr2Mcherry_GcamP_postStimyesterday_baseline2_Dextran_MelStim_ch66.mat');
DataSet{5} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\Dextran\4741_Chr2_Gcamp6_baselineDark.mat');
DataSet{6} = load('C:\Users\Noah\Documents\GitHub\deleteme\control\Dextran\4741_Chr2_Gcamp6_Post1mLMEM_melstim_ch141.mat');
fs=6000;

for ii=1:size(DataSet,2)
    [DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw,DataSet{ii}.sbs,DataSet{ii}.sbe,DataSet{ii}.sbw]=UnsupervisedBurstDetection2(DataSet{ii}.t,DataSet{ii}.ic);
    [~,~,bs,be,~] = SortChannelsByFR2(DataSet{ii}.t,DataSet{ii}.ic,DataSet{ii}.bs,DataSet{ii}.be,DataSet{ii}.bw);
    [DataSet{ii}.Trim.t,DataSet{ii}.Trim.ic] = OnlyNonHA(DataSet{ii}.t,DataSet{ii}.ic,bs,be);
    [DataSet{ii}.Trim.t,DataSet{ii}.Trim.ic] = SortByFR(DataSet{ii}.Trim.t,DataSet{ii}.Trim.ic);
    
    for j=1:size(DataSet{ii}.Trim.ic,2)
        t1=sort(DataSet{ii}.Trim.t(DataSet{ii}.Trim.ic(3,j):DataSet{ii}.Trim.ic(4,j)))./12;
        DataSet{ii}.Trim.fr(:,j)  =  histc(t1,0:fs:max(DataSet{ii}.Trim.t./12));
       
        t1=sort(DataSet{ii}.t(DataSet{ii}.ic(3,j):DataSet{ii}.ic(4,j)))./12;
        DataSet{ii}.fr(:,j)  =  histc(t1,0:fs:max(DataSet{ii}.t./12));
    end
        DataSet{ii}.Trim.gfr  =  mean(DataSet{ii}.Trim.fr,2);
        DataSet{ii}.Trim.time = [0:fs:max(DataSet{ii}.Trim.t./12)]./1000; %sec
        DataSet{ii}.gfr  =  mean(DataSet{ii}.fr,2);
        DataSet{ii}.time = [0:fs:max(DataSet{ii}.t./12)]./1000; %sec
end

% DataSet = CalcTrimTIC(DataSet');

    function [t1,ic1]=SortByFR(t,ic)
        [Firings,~]=FindNeuronFrequency(t,ic,500,1);
        Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
        [~,ix]=sort(Firings,'descend');
        t1=[];
        for i=1:numel(ix)
            tt1=sort(t(ic(3,ix(i)):ic(4,ix(i))));
            t1 =  [t1,tt1];
            ic1(1,i) = ic(1,ix(i));
            ic1(2,i)=1;
            ic1(3,i)=numel(t1)-numel(tt1)+1;
            ic1(4,i)=numel(t1);
        end
        [Firings,~]=FindNeuronFrequency(t1,ic1,500,1);
        Firings = mean(Firings(:,randi(size(Firings,2),100)),2); %Take a mean from a random sample of the firing rates.
        [~,ix]=sort(Firings,'descend');
        ix = ix((Firings<1E-4)|(Firings>0.024));
        ictemp=ic1;
        for i=1:length(ix)
            k=ix(i);
            [t1,ic1]=removeNeuronsWithoutPrompt(t1,ic1,[ictemp(1,k);1]);
        end
    end
end