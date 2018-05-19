function Per=accuracy(Truth,Result,Num);

[X Y]=size(Truth);

Z=zeros(256,256);

for i=1:X
    for j=1:Y
        p=Truth(i,j)+1;
        q=Result(i,j);
        Z(p,q)=Z(p,q)+1;
    end
end

T=sum(max(Z));

Per=T/X/Y;