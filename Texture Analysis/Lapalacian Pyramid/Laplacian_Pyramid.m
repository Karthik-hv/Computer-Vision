
function FV=Laplacian_Pyramid(Ti,G_Layer,sigma,G_kernal) 
Image=Ti;
N=G_Layer;
    for i = 1:N
        [len,bth] = size(Image); %find the Gaussian pyramid
        G(i) = {Image};
        [Image]=Mygauss1(Image,G_kernal,sigma);
%         G(i) = {Image};
        downsize = imresize(Image, 0.5, 'bilinear'); 
%         upsize = imresize(downsize, 2, 'bilinear');
%         upsize = Image - upsize;
%         %upsize = inputImage - imfilter(upsize,gaussianKernel);
%         L(i) = {upsize};
        Image = downsize;
    end

    
for i=N:-1:1
        if(i==N) %find the laplacian pyramid
            L{i}=cell2mat(G(i));
        else 
            Temp=cell2mat(G(i+1));
            upsize=imresize(Temp, 2, 'bilinear');
            L{i}=double(cell2mat(G(i)))-upsize;
         
        end
end

for i=N:-1:1
    Temp=cell2mat(L(i)); %find the statistics of the image
    [Mean,Var,Std_dev,Skew,Kur]=MyStatistics(Temp);
    Fe(i,1)=Mean;
    Fe(i,2)=Var;
    Fe(i,3)=Std_dev;
    Fe(i,4)=Skew;
    Fe(i,5)=Kur;
end

FV=Fe(:)';
end