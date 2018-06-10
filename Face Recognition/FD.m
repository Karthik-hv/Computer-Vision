clear;
clc;
close all;
for i=1:12
    for j=0:4
        file=sprintf('%s',int2str(i),'/',int2str(i),'_',int2str(j),'.bmp');
        face=imread(file);
        for k=1:90  
            x=(k-1)*60+1;	
            y=k*60;
            A((i-1)*5+1+j,x:y)=double(face(k,:));	% reshape the image into a vector
        end
    end
end

Mean_face=sum(A)/60; %taking mean of all the images

t=cov(A); %find the covariance matrix of 60 image matrix

[EVec Eval]=eigs(t); %to check how many eigenvalues to use

[V,D]=eig(t); %find all eigenvalues and eigenvectors for the covariance matrix.

% check for an eigenface 
% L=EVec(:,3);
% Res=reshape(L,60,90);
% 
% imshow(Res',[]);

Diag=diag(D); %form a matrix of all the eigen values

num_of_evs=25;

den=sum(Diag);
for i=1:num_of_evs
    nummat=sum(Diag(end-i:end));
    ratio(1,i)=nummat/den;
end

figure(1),plot(ratio); %graph of top eigenvalues considered

val1=0;
num=1;
for k=1:12
    for j=size(V,2):-1:(size(V,2)-(num_of_evs-1))
        sum1=0;
        for i=val1+1:val1+5
            mat1=A(i,:)-Mean_face;
            mat2=V(:,j);
            sum1=sum1+(mat1*mat2);
        end 
        alpha1(k,num)=sum1/5;
        num=num+1;
    end
    val1=i;
    num=1;
end


%reconstruction for any random image out of the 60 images.
num1=1;
for j=size(V,2):-1:(size(V,2)-(num_of_evs-1))
    mat11=A(58,:)-Mean_face;
    mat12=V(:,j);
    beta(1,num1)=(mat11*mat12);
    num1=num1+1;
end

j=0;
sum1=0;
for i=1:num_of_evs
    new_val=beta(1,i);
    new_mat=V(:,end-j);
    sum1=sum1+(new_val*new_mat);
    j=j+1;
    new_img=sum1'+Mean_face;
    Error(1,i)=sum(abs((new_img(1,:) - A(58,:))));
end

new_img=sum1'+Mean_face;

Res1=reshape(new_img,60,90);

figure(2),imshow(Res1',[]);
figure(3),plot(Error)
%end of reconstruction of any random image

%reconstruction for a non-face image.
image1=imread('Castle.jpg'); %consider a pic of castle
image1=rgb2gray(image1);
image1=imresize(image1,[90,60]); 
image1=double(image1(:)');

num1=1;
for j=size(V,2):-1:(size(V,2)-(num_of_evs-1))
    new_mat11=image1-Mean_face;
    new_mat12=V(:,j);
    beta1(1,num1)=(new_mat11*new_mat12);
    num1=num1+1;
end

j=0;
sum1=0;
for i=1:num_of_evs
    new_val1=beta1(1,i);
    new_mat1=V(:,end-j);
    sum1=sum1+(new_val1*new_mat1);
    j=j+1;
    new_img1=sum1'+Mean_face;
    Error1(1,i)=sum(abs((new_img1(1,:) - image1))); %the error values of reconstruction
end


Res11=reshape(new_img1,60,90);

figure(4),imshow(Res11',[]);
figure(5),plot(Error1)
%end of reconstruction of a non face image

%reconstruction for a unknown face image.
image2=imread('un_face.jpg'); %a face image which is not in the database
image2=rgb2gray(image2);
image2=imresize(image2,[90,60]);
image2=double(image2(:)');

num2=1;
for j=size(V,2):-1:(size(V,2)-(num_of_evs-1))
    new_mat21=image2-Mean_face;
    new_mat22=V(:,j);
    beta2(1,num2)=(new_mat21*new_mat22);
    num2=num2+1;
end

j=0;
sum2=0;
for i=1:num_of_evs
    new_val2=beta1(1,i);
    new_mat2=V(:,end-j);
    sum2=sum2+(new_val2*new_mat2);
    j=j+1;
    new_img2=sum2'+Mean_face;
    Error2(1,i)=sum(abs((new_img2(1,:) - image2))); %the error values of reconstruction
end


Res12=reshape(new_img2,60,90);

figure(6),imshow(Res12',[]);
figure(7),plot(Error2)
%end of reconstruction of a unknown face image


for i=1:12
    for j=0:4
        file=sprintf('%s',int2str(i),'/',int2str(i),'_',int2str(j+5),'.bmp');
        face=imread(file);
        for k=1:90
            x=(k-1)*60+1;
            y=k*60;
            Test((i-1)*5+1+j,x:y)=double(face(k,:));	% reshape the image into a vector
        end
    end
end


val_1=1;
for i=size(V,2):-1:size(V,2)-(num_of_evs-1)
    V1(:,val_1)=V(:,i);
    val_1=val_1+1;
end


for i = 1 : 60
    for j = 1 : num_of_evs
        w(i,j) = (Test(i,:)-Mean_face) * V1(:,j);  
    end
end

for i = 1 : 60
    for j = 1 :12
        dist_mat(i,j) = sqrt(sum((w(i,:) - alpha1(j,:)).^2)); 
    end
end

for i =1 : 60
[val,index] = sort(dist_mat(i,:));
ind_mat(i,1) = index(1);
ind_mat(i,2) = index(2);
ind_mat(i,3) = index(3);
end

h = 0;
value_1=1;
for i = 1 : 60
   
    if (ind_mat(i,1) == value_1  || ind_mat(i,2) == value_1 || ind_mat(i,3) == value_1 )
        h = h + 1;
    end
    
    if mod(i,5)==0
        value_1=value_1+1;
    end
    
end

recog_per = (h/60)*100


