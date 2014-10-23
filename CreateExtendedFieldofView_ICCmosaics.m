fileList = getAllFiles(uigetdir);
start = regexp(fileList{1},'m0');
stop = regexp(fileList{1},'_ORG');
vec = cellfun(@(x) str2num(x(start+1:stop-1)),fileList);
% for i=1:max(vec)
%     counter=1;
%     for ii=1:length(fileList)
%         a=fileList{ii};
%         upto = regexp(fileList{i},'\');
%         if i<10
%             teststr = ['c1m00',num2str(i)];
%         else
%             if i<100
%                 teststr = ['c1m0',num2str(i)];
%             else
%                 teststr = ['c1m',num2str(i)];
%             end
%         end
%         if regexp(a,teststr)>0
%             m{counter}=fileList{ii};
%             counter=counter+1;
%         end
%     end
%     %     imwrite(fstack(m),['F:\ICC_Astros\LiveImaging\CS1_c1_m',num2str(i),'.png']);
%     %     c1{i} = uint16(savitzkyGolay2D_rle_coupling(692,520,double(fstack(m,'fsize',18)),9,9,2));
%     c1{i} = adapthisteq(fstack(m,'fsize',18));
%     counter=1;
%     for ii=1:length(fileList)
%         a=fileList{ii};
%         if i<10
%             teststr = ['c4m00',num2str(i)];
%         else
%             if i<100
%                 teststr = ['c4m0',num2str(i)];
%             else
%                 teststr = ['c4m',num2str(i)];
%             end
%         end
%
%         if regexp(a,teststr)>0
%             m{counter}=fileList{ii};
%             counter=counter+1;
%         end
%     end
%     % imwrite(fstack(m),['F:\ICC_Astros\LiveImaging\CS1_c2_m',num2str(i),'.png']);
%     %     c2{i}=fstack(m,'fsize',18);
%     c2{i} = adapthisteq(uint16(savitzkyGolay2D_rle_coupling(692,520,double(fstack(m,'fsize',18)),9,9,2)));
%     cult = regexp(a,'CS');
%     cult=a(cult(1):cult(1)+2);
%     newdir = [a(1:upto(end-1)),'\',cult,'_MergedImagesFull\'];
%     if i==1
%         mkdir(newdir);
%     end
%     imwrite(imfuse(c1{i},c2{i},'falsecolor','Scaling','independent','ColorChannels',[1 2 0]),[newdir,cult,'_c14_m',num2str(i),'.png']);
% end
% [stat,~]=system(['"c:\Program Files\PanoramaStudio2Pro\PanoramaStudio2Pro.exe" -mm ', strjoin(getAllFiles(newdir))]);

for i=1:max(vec)
    for j=2
        counter=1;
        for ii=1:length(fileList)
            a=fileList{ii};
            upto = regexp(fileList{i},'\');
            if i<10
                teststr = ['c',num2str(j),'m00',num2str(i)];
            else
                if i<100
                    teststr = ['c',num2str(j),'m0',num2str(i)];
                else
                    teststr = ['c',num2str(j),'m',num2str(i)];
                end
            end
            
            if regexp(a,teststr)>0
                m{counter}=fileList{ii};
                counter=counter+1;
            end
        end
        cult = regexp(a,'CS');
        cult=a(cult(1):cult(1)+2);
        newdir = [a(1:upto(end-1)),'\',cult,'_EFVfull_c',num2str(j),'\'];
        if i==1
            mkdir(newdir);
        end
        c1{i}=fstack(m,'fsize',3);
%         imwrite(fstack(m,'fsize',18),[newdir,'CS3_c1_m',num2str(i),'.png']);
    end
end