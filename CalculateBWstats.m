for k =0:14690:14690
for j=0:12
    for i=1:1130
        g1{k+1130*j+i} = num2str(j+1);
    end
end
end

for j=0:12
    for i=1:1130
        g2{1130*j+i} = 'Pre';
    end
end

for j=0:12
    for i=1:1130
        g2{14690+1130*j+i} = 'Post';
    end
end

B=[];
for i=1:13
    B = [B,bwsPres(i,:)];
end

C=[];
for i=1:13
    C = [C,bwsPosts(i,:)];
end