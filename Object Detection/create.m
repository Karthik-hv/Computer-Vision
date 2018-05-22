% This program creates an image for test

M=128;  % image size 

K=20;  % number of discs

R2=100; % radius of discs

I=randn(M,M)*0.04+0.5;

for k=1:K
    Cx(k)=round(rand*M);
    Cy(k)=round(rand*M);
end

for k=1:K
    for i=1:M
        for j=1:M
            Tr=(i-Cx(k))*(i-Cx(k))+(j-Cy(k))*(j-Cy(k));
            if Tr<100
                Tv=randn*0.04+0.25;
                if Tv>1
                    Tv=1;
                elseif Tv<0
                    Tv=0;
                end
                I(i,j)=Tv;
            end
        end
    end
end

imshow(I);
imwrite(I,'discs20.bmp'); % file name

        

