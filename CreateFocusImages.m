function CreateFocusImages()
fileList = getAllFiles(uigetdir);
start = regexp(fileList{1},'m0');
stop = regexp(fileList{1},'_ORG');
vec = cellfun(@(x) str2num(x(start+1:stop-1)),fileList);
for i=1:max(vec)
    for j=2
        counter=1;
        for ii=1:length(fileList)
            a=fileList{ii};
            upto = regexp(fileList{i},'\');
            %             if i<10
            %                 teststr = ['c',num2str(j),'m00',num2str(i)];
            %             else
            if i<10 %i<100
                teststr = ['c',num2str(j),'m0',num2str(i)];
            else
                teststr = ['c',num2str(j),'m',num2str(i)];
            end
            %             end
            
            if regexp(a,teststr)>0
                m{counter}=fileList{ii};
                temp = gradient(double(imread(m{counter})));
                for k=1:100, s(k) = max(temp(randperm(numel(temp),100))); end
                g(counter)= mean(s);
                counter=counter+1;
            end
        end
        cult = regexp(a,'CS');
        cult=a(cult(1):cult(1)+2);
        newdir = [a(1:upto(end-1)),'\',cult,'_EFVfull_c',num2str(j),'\'];
        if i==1
            mkdir(newdir);
        end
        %         test1 = adapthisteq(uint16(savitzkyGolay2D_rle_coupling(692,520,double(fstack(m,'fsize',18)),9,9,2))); %Extended focus
        %         test2 = imread(m{g==max(g)}); %Best z-slice
        %         g1 = gradient(double(test1));
        %         g2 = gradient(double(test2));
        %         for k=1:100, s1(k) = max(test1(randperm(numel(test1),100))); end
        %         for k=1:100, s2(k) = max(test2(randperm(numel(test2),100))); end
        %         if mean(s1)>mean(s2)
        %             imwrite(fstack(m,'fsize',18),[newdir,'CS3_c1_m',num2str(i),'.png']);
        %         else
        %             imwrite(imread(m{g==max(g)}),[newdir,'CS4_ch_m',num2str(i),'.png']);
        %             test1 = adapthisteq(uint16(savitzkyGolay2D_rle_coupling(692,520,double(fstack(m,'fsize',18)),9,9,2)));
        test1 = visibresto(fstack(m,'fsize',18),11,0.5,-1);
%         test1 = fstack(m,'fsize',18);
        imwrite(test1,[newdir,'CS4_ch_m',num2str(i),'.png']);
        %         end
    end
end
end

% dir1 = fullfile('F:\ICC\FixedImaging\CS3_SeperateChannelsFull\CS3_EFVfull_c1');
% dir2 = fullfile('F:\ICC\FixedImaging\CS3_SeperateChannelsFull\CS3_EFVfull_c3');
% set1 = imageSet(dir1);
% set2 = imageSet(dir2);
%
% for i=1:set1.Count
% imwrite(imfuse(read(set1,i),read(set2,i),'falsecolor','Scaling','independent','ColorChannels',[1 2 0]),['F:\ICC\test\mergedtest',num2str(i),'.png']);
% end