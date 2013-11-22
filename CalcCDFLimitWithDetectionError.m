function [x,y,y1,xs,ys,y1s]=CalcCDFLimitWithDetectionError(BurstData,type);
regCDFx=[];
regCDFy=[];
sbCDFx=[];
sbCDFy=[];

for k=1:2
    for i=1:3
        for j=1:3
            switch type
                case 'bw'
                    regbw  = BurstData{i,j,k}.bw(BurstData{i,j,k}.nsbsb==0); % Outside of SBs
                    sbbw  = BurstData{i,j,k}.bw(BurstData{i,j,k}.nsbsb==1); % Inside of SBs
                    [a,b,~,~]=CalcCdf(regbw'./1200); % Convert to ms
                    [c,d,~,~]=CalcCdf(sbbw'./1200);
                case 'numspikes'
                    regbw  = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==0); % Outside of SBs
                    sbbw  = BurstData{i,j,k}.numspikes(BurstData{i,j,k}.nsbsb==1); % Inside of SBs
                    [a,b,~,~]=CalcCdf(regbw'); % Convert to ms
                    [c,d,~,~]=CalcCdf(sbbw');
                case 'fr'
                    regbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==0))./BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==0))'; % Outside of SBs
                    sbbw  = BurstData{i,j,k}.numspikes((BurstData{i,j,k}.nsbsb==1))./BurstData{i,j,k}.bw((BurstData{i,j,k}.nsbsb==1))';  % Inside of SBs
                    [a,b,~,~]=CalcCdf(regbw'.*12000); % Convert to ms
                    [c,d,~,~]=CalcCdf(sbbw'.*12000);
                case 'recruitment'
                    regbw  = BurstData{i,j,k}.spikesPcntMax((BurstData{i,j,k}.nsbsb==0)); % Outside of SBs
                    sbbw  = BurstData{i,j,k}.spikesPcntMax((BurstData{i,j,k}.nsbsb==1)); % Inside of SBs
                    [a,b,~,~]=CalcCdf(regbw'.*100);
                    [c,d,~,~]=CalcCdf(sbbw'.*100);
            end
            regCDFx = [regCDFx,a];
            regCDFy = [regCDFy,b];
            sbCDFx = [sbCDFx,c];
            sbCDFy = [sbCDFy,d];
        end
    end
end
[regCDFx,perm]=sort(regCDFx);
regCDFy=regCDFy(perm);
fun = @(block_struct)  max(block_struct.data);
fun1 = @(block_struct)  min(block_struct.data);
y = blockproc(regCDFy,[1 100],fun);
x = blockproc(regCDFx,[1 100],fun1);
y1 = blockproc(regCDFy,[1 100],fun1);
x1 = blockproc(regCDFx,[1 100],fun);

[sbCDFx,perm]=sort(sbCDFx);
sbCDFy=sbCDFy(perm);

ys = blockproc(sbCDFy,[1 100],fun);
xs = blockproc(sbCDFx,[1 100],fun1);
y1s = blockproc(sbCDFy,[1 100],fun1);
x1s = blockproc(sbCDFx,[1 100],fun);
end
