function Oxy=clip(Ixy,Mmin,Mmax)

[X Y]=size(Ixy);
K=X*Y;

for k=1:K
    if Ixy(k)<Mmin
        Oxy(k)=Mmin;
    elseif Ixy(k)>Mmax
        Oxy(k)=Mmax;
    else
        Oxy(k)=Ixy(k);
    end
end