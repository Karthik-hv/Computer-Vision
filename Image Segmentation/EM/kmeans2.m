

% for i=1:size(Image,1)
%     for j=1:size(Image,2)
%         temp1=sqrt((Means(i,j)-Mean1).^2);
% %         temp1=abs((Means(i,j)-Mean1));
%         temp2=sqrt((Means(i,j)-Mean2).^2);
% %         temp2=abs((Means(i,j)-Mean2));
%         temp3=sqrt((Means(i,j)-Mean3).^2);
% %         temp3=abs((Means(i,j)-Mean3));
%         temp4=sqrt((Means(i,j)-Mean4).^2);
% %         temp4=abs((Means(i,j)-Mean4));
% for i=1:size(Normalized_FV,1)
%     for j=1:num_of_means
%         temp(j,1)=sum(abs(Normalized_FV(i,:) - mean(j,:)));
%     end
%     [val,index]=min(temp);
%     Cluster_index(i,1)=index;
% end
function [k_meansint,updated_mean,Clusters,Per,temp]=kmeans2(mean,Normalized_FV,color_vals,num_of_means,iter,ImgMap);
Image=imread('mosaicA.bmp');
Clustered_image = zeros(size(Image,1),size(Image,2));
for i=1:num_of_means %objective function of the kmeans
    for j=1:size(Normalized_FV,1)
        temp(i,j)=sum((abs(Normalized_FV(j,:) - mean(i,:))).^2);
        [val,index]=min(temp(:,j));
        Cluster_index(1,j)=index;
    end 
end
% 
% [val,index]=min(temp(:,1));
for i=1:num_of_means %find the index of which cluster the data point belongs to
    for j=1:size(Normalized_FV,1)
        Cluster_data{i,1}=find(Cluster_index==i);
        point=find(Cluster_index==i);
        for k=1:length(point)
            Clustered_image(point(k))=color_vals(i); %construct the image of the formed cluster
        end
    end
end

for i=1:size(Cluster_data,1) %find the feature vectors of the points stored in the clusters
    for j=1:size(Cluster_data{i,1},2)
        Clusters{i,1}(j,:)=Normalized_FV(Cluster_data{i,1}(1,j),:);
    end
end
% 
% for i=1:num_of_means
%     for j=1:size(Normalized_FV,1)
%          
%     end
% end


for i=1:num_of_means %find the updated mean
    for j=1:size(Clusters{i,1},2)
        updated_mean(i,j)=(sum(Clusters{i,1}(:,j))/size(Clusters{i,1},1));
    end
end
k_meansint = zeros(size(Image));
for i=1:size(Image,1)
    for j=1:size(Image,2)
        for k=1:size(Clustered_image,1)
            Kmeans_Image(k)=Clustered_image(k);
        end
    end
end
k_meansint=uint8(Clustered_image);
Per=accuracy(ImgMap,k_meansint,iter); %find percentage accuracy


% figure(1),imshow(k_meansint);
figure(2),imshow(k_meansint');

% saveas(figure(2),sprintf('kmeans.png'));%store each frame as this filename
%  
% New = imread('kmeans.png');
% 
% Fr = im2frame(New);%convert the image to a frame
%   
% writeVideo(vid,Fr);%write the frame on to the image file
iter;

end

        

