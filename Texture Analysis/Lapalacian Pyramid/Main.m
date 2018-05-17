clear;
clc;
tic
Gau_Kernal=5;
Gau_sigma=0.38;
Gau_Layer=4;
Texture_num=59;

S=64;

Ti=cell(Texture_num,1);
for i=1:Texture_num
    N=num2str(i);
    Ti{i}=imread(['D',N,'.bmp']);
    Fi(i,:)=Laplacian_Pyramid(Ti{i},Gau_Layer,Gau_sigma,Gau_Kernal); %find feature vector of each image
end

Num_of_elements=size(Fi,2);

for i=1:Num_of_elements %Normalize each feature vector and create texture library.
    Max_Var(i)=max(Fi(:,i));
    Min_Var(i)=min(Fi(:,i));
    Ni(:,i)=(Fi(:,i)-Min_Var(i))/(Max_Var(i)-Min_Var(i));
end

RowBsize = 64; % Rows in block.
ColBsize = 64; % Columns in block.
Count=0;
for i=1:Texture_num %Divide each image as 64x64 image and store all 100 blocks
    N=num2str(i);
    Image=imread(['D',N,'.bmp']);
    [rows columns] = size(Image);
    Count = Count+1;
    Count1=1;
    for row = 1 : RowBsize : rows
        for col = 1 : ColBsize : columns
            row1 = row;
            row2 = row1 + RowBsize - 1;
            col1 = col;
            col2 = col1 + ColBsize - 1;
            % Extract out the block into a single subimage.
            Img = Image(row1:row2, col1:col2);
            %Storing the extracted image inside a cell array
            Imgs{Count,Count1}=(Img);
            Count1 = Count1 + 1;
             end
        
    end
end
% 

% temp=Imgs{1,12};
for i=1:Texture_num
    for j=1:100
%         temp=Imgs{i,j};
        F{i,j}=Laplacian_Pyramid(Imgs{i,j},Gau_Layer,Gau_sigma,Gau_Kernal);%find feature vector of each 64x64 image
    end
%         K{i,j}=F;
end

for i=1:Texture_num %Normalize each feature vector 
    for j=1:100
        temp=F{i,j};
        for k=1:Num_of_elements
            M(:,k)=(temp(:,k)-Min_Var(k))/(Max_Var(k)-Min_Var(k));
        end
        Nor{i,j}=M;
    end
end
for i=1:Texture_num %Find minimum distance and find the image the texture belongs to
    pcc=0;
    for j=1:100
        M=Nor{i,j};
        for k=1:size(Ni,1)

         K(k,1) =sum(abs((Ni(k,:) - M))); %Manhattan distance
%        temp = M - Ni(i,:); 
%       K(i,1) = sqrt(temp * temp');%Euclidean distance
        end
        Vals{i,j}=K;
        [Min,index]=min(K);
        Fin{i,j}=index;
        if (index==i)
            pcc=pcc+1;
        end
    Per(i,1)=pcc;
    end
end

Final_PCC=sum(sum(Per))/59 %Final PCC of all images
% [Min,index]=min(K);

    toc