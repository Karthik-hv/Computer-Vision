function Uxy=direct(Im,T,Cxy,K,Sdd)

[X Y]=size(Im);

K2=K*2;
N=100;

eo=likelihood(Im,T,Cxy(1:K2),K);

for k=1:K
    kx=k*2-1;
    ky=k*2;
    t=round((rand(2,N)-0.5)*Sdd);
    for n=1:N
        Txy(1:K2,1)=Cxy(1:K2);
        Txy(kx:ky)=Cxy(kx:ky)+t(1:2,n)';
        Pxy(n,1:K2)=clip(Txy(1:K2),1,X);
        et(n)=likelihood(Im,T,Pxy(n,1:K2),K);
    end
    [emax,en] =max(et);
    if emax>eo
        Uxy(kx:ky)=t(1:2,en);
        Cxy(1:K2)=Pxy(en,1:K2);
        eo=emax;
    else
        Uxy(kx:ky)=0;
    end
end
            