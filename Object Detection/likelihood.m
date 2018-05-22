function like=likelihood(Im,T,Uxy,K)

[X Y]=size(Im);

It=maketarget(T,X,Y,Uxy,K);

Ie=(Im+It*0.25)-0.5;

e=sum(sum(Ie.*Ie));

like=exp(-0.5*e);
   
        