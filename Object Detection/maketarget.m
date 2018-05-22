function It=maketarget(T,Ix,Iy,Cxy,K)

[X  Y] =size(Cxy);
[Xt Yt]=size(T);

Tc=(Xt+1)/2;

Ii=zeros(Ix,Iy);

Cxy(1:K*2)=clip(Cxy(1:K*2),1,Ix);

for k=1:K
    tx=Cxy(k*2-1);
    ty=Cxy(k*2);
    Ii(tx,ty)=1;
end

Io=conv2(Ii,T,'same');

It=im2bw(Io,0.5);

