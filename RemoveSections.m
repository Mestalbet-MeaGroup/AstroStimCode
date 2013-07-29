function [tNew,icNew]=RemoveSections(t,ic,cutStart,cutEnd);
% Recieves t,indexchannel and removes sections between cutStart and cutEnd
% in units of 1/12ms.
% Revision 1: 25/07/2013
% Written by: Noah Levine-Small

tNew=[];
icNew=[];
counter = 1;
for i=1:size(ic,2),
    t1=sort(t(ic(3,i):ic(4,i)));
    t1(t1>=cutStart & t1<=cutEnd)=[];
    if ~isempty(t1)
        tNew =  [tNew,t1];
        icNew(1,counter) = ic(1,i);
        icNew(2,counter)=1;
        icNew(3,counter)=numel(tNew)-numel(t1)+1;
        icNew(4,counter)=numel(tNew);
        counter = counter+1;
    end
end
end