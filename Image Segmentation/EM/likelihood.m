function [EM_Clustered_image,updated_mean,updated_prob,updated_covar,l_sum]=likelihood(EM_Mean,Feature_vector,covar_mat,num_of_means,prior_prob,color_vals);

for i=1:num_of_means
    temp_inv=inv(covar_mat{i,1});
    covar_inv{i,1}=temp_inv;
end

for i=1:num_of_means %E step
    for j=1:size(Feature_vector,1)   
            temp1=Feature_vector(j,:) - EM_Mean(i,:);
            val=(-0.5)*temp1*covar_inv{i,1}*temp1';
            ex=exp(val);
            len=length(temp1);
            den=((2*pi)^(len/2))*(det(covar_mat{i,1})^(0.5));
            temp3=ex/den;
            fin_val=(prior_prob(i))*temp3;
            one_val=0;
            for q=1:num_of_means
                temp11=Feature_vector(j,:) - EM_Mean(q,:);
                val1=(-0.5)*temp11*covar_inv{q,1}*temp11';
                ex1=exp(val1);
                len1=length(temp11);
                den1=((2*pi)^(len1/2))*(det(covar_mat{q,1})^(0.5));
                temp31=ex1/den1;
                fin_val1=(prior_prob(q))*temp31;
                one_val=one_val+fin_val1; %find the denominator of the likelihood function
            end
            final(j,i)=fin_val/one_val; %posterior probability of all samples
    end
    
end

l_sum=0;
for i=1:size(Feature_vector,1)
    n_sum=0;
  
    for j=1:num_of_means
        temp=prior_prob(j);
        temp1=final(i,j);
        prod=temp*temp1;
        n_sum=n_sum+prod;
    end
 n_sum=log(n_sum);
l_sum=l_sum+n_sum; %log of likelihood function to plot the graph
end
        

for i=1:num_of_means
    for j=1:size(final,1)
        [val,index]=max(final(j,:));
        Max_Index(j,1)=index; %find the index of cluster which has max posterior probability
    end
end

for i=1:num_of_means %find the index of which cluster the data point belongs to
    for j=1:size(final,1)
        EM_Cluster_data{i,1}=find(Max_Index==i); %stores how many points belong to each cluster
        EM_point=find(Max_Index==i);
        for k=1:length(EM_point) %find all points belonging 
            EM_Clustered_image(EM_point(k),1)=color_vals(i); %construct the image of the formed cluster
        end
    end
end


for i=1:size(final,2) %updated probability
    sum=0;
    for j=1:size(final,1)
        temp=final(j,i);
        sum=sum+temp;
    end
    den_mat(1,i)=sum;
    updated_prob(1,i)=sum/size(final,1);
end

for i=1:size(final,2) %updated mean
    psum=0;
    for j=1:size(final,1)
        temp=final(j,i);
        temp1=Feature_vector(j,:);
        prod=temp*temp1;
        psum=psum+prod;
    end
    updated_mean(i,:)=psum/den_mat(1,i);
end

for i=1:size(final,2) %updated covariance matrix
    gsum=0;
    for j=1:size(final,1)
        temp=final(j,i);
        temp1=(Feature_vector(j,:)-EM_Mean(i,:));
        prod=temp1'*temp1;
        prod1=temp*prod;
        gsum=gsum+prod1;
    end
    temp2=gsum/den_mat(1,i);
    updated_covar{i,1}=temp2;
end
end