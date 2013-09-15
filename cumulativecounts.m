function  [a,b] = cumulativecounts(x)

x = round(x*100);
minvalue = min(x);
maxvalue = max(x);
bins = minvalue:1:maxvalue;
values = zeros(size(bins));

for i=1:length(bins)
   q1=find(bins(i)==x);
   values(i)=length(q1);
end


bins = bins(values>0);
b = values(values>0);
values = values(values>0);
b(length(values)) = values(length(values));
for i=length(values)-1:-1:1
   b(i) = b(i+1) + values(i);
end

a = bins./100;