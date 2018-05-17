

for i=1:Texture_num
    for j=1:100
        h=1;
        m=1;
        for k=1:size(E01,2)  
            Temp=(Tex{i,j}{h,k});
            [Mean,Var,Std_dev,Skew,Kur]=MyStatistics(Temp); %Get the statistics for the feature vector and store only required parameters
%             Fea(1,m)=Mean;
%             m=m+1;
            Fea(1,m)=Var;
            m=m+1;
            Fea(1,m)=Std_dev;
            m=m+1;
%             Fea(1,m)=Skew;
%             m=m+1;
%             Fea(1,m)=Kur;
%             m=m+1;
        end
        for l=1:size(Fe,2)  
            M(:,l)=(Fea(:,l)-Min_Var(l))/(Max_Var(l)-Min_Var(l)); %normalize the vector
        end
        for n=1:size(Nor,1)
             Diff(n,1)=sum(abs((Nor(n,:) - M))); %Manhattan distance
        end
        [Min,index]=min(Diff);
        Final{i,j}=index; %Store the index to which image belongs to
    end
end

for i=1:size(Final,1)
    pcc=0;
    for j=1:size(Final,2)
        ind=Final{i,j};
        if (ind==i)
            pcc=pcc+1;
        end
    end
    Fin_Per(i,1)=pcc; %Find the PCC of each image
end

 Final_PCC=sum(sum(Fin_Per))/59 %Overall PCC of all the images