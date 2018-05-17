
function [Gauss]=Mygauss1(Image,KernalSize,sig) %Find the gaussian Kernal and smoothen the image.
siz=ceil((KernalSize-1)/2);
[x,y]=meshgrid(-siz:siz,-siz:siz);
Exp_1=-(x.^2+y.^2)/(2*sig*sig);
A1=exp(Exp_1)/(2*pi*sig*sig);
% K2=A1./sum(A1(:));
Gauss=conv2(Image,A1,'same');
end