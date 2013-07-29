% [12:06:46] Mark Shein (University-nano): % [tNew,icNew]=CutSortChannel(t,indexchannel,tStart,tEnd);
% Function purpose : cuts out a peace of a recording between timings tStart
%                    if a neuron does not fire in this piece it is deleted
%
% Function recives :    t [1/12 ms] - firing timings
%                       ic - indexc channel
%                       tStart - starting time 1/12 ms
%                       tEnd - ending time 1/12 ms
%                
% Function give back :  tNew [1/12 ms]- new firing timings
%                       icNew - new indexc channel
%
% To show paster plot use : plotraster(tNew,icNew);
% Last updated : 02/03/09

function [tNew,icNew]=CutSortChannel2(t,ic,tStart,tEnd);

to_delete=[];
icNew=zeros(size(ic));
icNew(1:2,:)=ic(1:2,:);
tNew=[];
for i=1:size(ic,2),
    tChannel=t(ic(3,i):ic(4,i));
    tCut=tChannel(find(tChannel>tStart & tChannel<tEnd));
    if isempty(tCut),
        fprintf('\nNeuron %d %d does not fire during selected interval and therfore was deleted',ic(1:2,i));
        to_delete=[to_delete i];
    else        
        icNew(3,i)=length(tNew)+1;
        tNew=[tNew, tCut];
        icNew(4,i)=length(tNew);
    end
end
icNew(:,to_delete)=[];
fprintf('\nPlease remember that cut segment started at time %d in the whole sort Channel\n',tStart);
tNew=tNew-tStart;