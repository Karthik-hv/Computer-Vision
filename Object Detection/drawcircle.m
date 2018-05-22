function Io=drawcircle(Ii,Uxy,K)

[X Y]=size(Ii);
[Z1 Z2]=size(Uxy);

for i=1:X
    for j=1:Y
        ma=0;
        for k=1:K
            cx=Uxy(2*k-1);
            cy=Uxy(2*k);
            te=(i-cx)*(i-cx)+(j-cy)*(j-cy);
            tr=abs(te-100);
            if tr<10
                ma=1;
                break;
            end
        end
        if ma==1
            Io(i,j)=1;
        else
            Io(i,j)=Ii(i,j);
        end
    end
end

