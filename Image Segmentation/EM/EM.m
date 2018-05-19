EM_Mean=new_mean; %best value mean from K-means algorithm.
for i=1:num_of_means %initialize prior probabilities
    prior_prob(i)=size(clusters{i,1},1)/size(Feature_vector,1);
end

for i=1:num_of_means %extract covariance matrix
    gsum=0;
    for j=1:size(clusters{i,1},1)
        temp1=(clusters{i,:}(j,:) - EM_Mean(i,:));
        temp1=temp1';
        temp2=(temp1*temp1');
        gsum=gsum+temp2;
    end
    covar_mat{i,:}=gsum/size(clusters{i,1},1);
end
vid= VideoWriter('EM_vid_2.mp4');
vid.FrameRate = 5;
open(vid);
newEM_mean=EM_Mean;

% [EM_Clustered_image,mean_table,clusters]=kmeans2(newEM_mean,Feature_vector,color_vals,num_of_means,i);
for q=1:5
[EM_Clustered_image,updated_mean,updated_prob,updated_covar,dist]=likelihood(newEM_mean,Feature_vector,covar_mat,num_of_means,prior_prob,color_vals);   

EM_Image=zeros(size(Image,1));
for i=1:size(Image,1)
    for j=1:size(Image,2)
        for k=1:size(EM_Clustered_image,1)
            EM_Image(k)=EM_Clustered_image(k);
        end
    end
end
% figure, imshow(uint8(EM_Image));

EM_Imgint=uint8(EM_Image);
figure(10), imshow(EM_Imgint');
saveas(figure(10),sprintf('kmeans.png'));%store each frame as this filename
 
New = imread('kmeans.png');

Fr = im2frame(New);%convert the image to a frame
  
writeVideo(vid,Fr);%write the frame on to the image file
Per=accuracy(ImgMap,EM_Imgint,q);
Per_EM(q)=Per;
newEM_mean=updated_mean;
covar_mat=updated_covar;
prior_prob=updated_prob;
distance(q)=dist;
q
end
close(vid);
figure, plot(Per_EM); %plot segmentation accuracy graph
xlabel('iteration');
ylabel('Percent Accuracy');

figure, plot(distance); %plot log likelihood graph
xlabel('iteration');
ylabel('Log Likelihood');







        
   





