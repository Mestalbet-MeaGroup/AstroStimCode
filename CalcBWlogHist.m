testPre=[];
testPost=[];
for i=1:13
    testPre = [testPre,bwsPre{i}];
    testPost = [testPost,bwsPost{i}];
end
PreBWhist=[];
PostBWhist=[];
bins=logspace(3,7,10);
% testPre=testPre./12000;
% testPost=testPost./12000;
for i=1:length(bins)-1
    PreBWhist(i)=size(testPre(testPre>=bins(i)&testPre<=bins(i+1)),2);
    PostBWhist(i)=size(testPost(testPost>=bins(i)&testPost<=bins(i+1)),2);
end
a=diff(bins);
PreBWhist=PreBWhist./a;
PostBWhist=PostBWhist./a;

loglog(bins(2:end),PreBWhist,'.-k','MarkerSize',12);
hold on
loglog(bins(2:end),PostBWhist,'.-r','MarkerSize',12);
hold off
title('Burst Durations');
