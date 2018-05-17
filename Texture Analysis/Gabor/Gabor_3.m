
for i=1:Texture_num
    for j=1:100
%         temp=Imgs{i,j};
             W0=gaborconvolve(Imgs{i,j},Num_scale,Num_orien,3,2,0.6,1.5); %Gabor filtering each block of the image.
             for k=1:Num_scale
                for l=1:Num_orien
                    New1{k,l}=abs(W0{k,l});
                end
             end
             W01=New1(:)';
            Lib1(i,:)=W01;
            Tex{i,j}=Lib1(i,:); %storing each MxN channels in each cell 
    end
end
