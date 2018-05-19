
clear;
clc;
close all;
Image=imread('mosaicB.bmp');
ImgMap=imread('mapB.bmp');
[rows cols]=size(Image);
Num_scale=5;
Num_orien=8;

E0=gaborconvolve(Image,Num_scale,Num_orien,3,2,0.65,1.5); %Gabor convolve the image
for k=1:Num_scale
    for l=1:Num_orien
        New{k,l}=abs(E0{k,l}); %Extract absolute values
    end
end

E01=New(:)';


      


for i=1:size(Image,1)
    for j=1:size(Image,2)
        for l=1:size(E01,2)
            Res{i,j}(1,l)=E01{1,l}(i,j);
        end
    end
end
h1=1;
for i=1:256
    for j=1:256
        Feature_vector(h1,:)=Res{i,j};
        h1=h1+1;
    end
end

num_of_means=3;

for i=1:num_of_means
    color_vals=[1,170,85,255];
end

% for i=1:num_of_means %color for Image A
%     color_vals=[255,85,170,0];
% end

% for i=1:num_of_means %color for Image B
%     color_vals=[255,170,0];
% end


for i=1:size(Feature_vector,2) %Normalize each feature vector and create texture library.
    Max_Var(i)=max(Feature_vector(:,i));
    Min_Var(i)=min(Feature_vector(:,i));
    Normalized_FV(:,i)=(Feature_vector(:,i)-Min_Var(i))/(Max_Var(i)-Min_Var(i));
end
% 


% for i=1:num_of_means %random mean initialization
%     num(i)=randi(size(Normalized_FV,1));
%     mean(i,:)=Feature_vector(num(i),:);
%     
% end


% mean(1,:)=Feature_vector(11656,:); %best results for Image A
% mean(2,:)=Feature_vector(17656,:);
% mean(3,:)=Feature_vector(35464,:);
% mean(4,:)=Feature_vector(62800,:);



mean(1,:)=Feature_vector(42451,:); %best results for Image B
mean(2,:)=Feature_vector(29552,:);
mean(3,:)=Feature_vector(35849,:);
vid= VideoWriter('kmeans_vid2.mp4');
vid.FrameRate = 5;
open(vid);     
new_mean=mean;

max_iterations=5;

for i=1:max_iterations
[image,mean_table,clusters,percent,temp]=kmeans2(new_mean,Feature_vector,color_vals,num_of_means,i,ImgMap,vid);
% fig(i),imshow(image);
if mean_table==new_mean
    break
else
    new_mean=mean_table;
end
Per_KM(i)=percent;
dist(i)=sum(sum(temp));



i
end
close(vid);
figure, plot(Per_KM);
xlabel('iteration');
ylabel('Percent Accuracy');
figure, plot(dist);
xlabel('iteration');
ylabel('Objective Function');