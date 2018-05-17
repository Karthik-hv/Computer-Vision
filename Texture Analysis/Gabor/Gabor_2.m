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





% %         K{i,j}=F;
%     end
% end