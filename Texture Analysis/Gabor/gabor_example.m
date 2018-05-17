%function gf=gabor_feature(im,scale,orientation)

% Usage: EO = gaborconvolve(im,  nscale, norient, minWaveLength, mult, ...
%			    sigmaOnf, dThetaOnSigma)
%
% Arguments:
% The convolutions are done via the FFT.  Many of the parameters relate 
% to the specification of the filters in the frequency plane.  
%
%   Variable       Suggested   Description
%   name           value
%  ----------------------------------------------------------
%    im                        Image to be convolved.
%    nscale          = 4;      Number of wavelet scales.
%    norient         = 6;      Number of filter orientations.
%    minWaveLength   = 3;      Wavelength of smallest scale filter.
%    mult            = 2;      Scaling factor between successive filters.
%    sigmaOnf        = 0.65;   Ratio of the standard deviation of the
%                              Gaussian describing the log Gabor filter's transfer function 
%	                       in the frequency domain to the filter center frequency.
%    dThetaOnSigma   = 1.5;    Ratio of angular interval between filter orientations
%			       and the standard deviation of the angular Gaussian
%			       function used to construct filters in the
%                              freq. plane.
%
% Returns:
%
%   EO a 2D cell array of complex valued convolution results
%
%        EO{s,o} = convolution result for scale s and orientation o.
%        The real part is the result of convolving with the even
%        symmetric filter, the imaginary part is the result from
%        convolution with the odd symmetric filter.
%
%        Hence:
%        abs(EO{s,o}) returns the magnitude of the convolution over the
%                     image at scale s and orientation o.
%        angle(EO{s,o}) returns the phase angles.

clear;
tic
Texture_num=59;

Num_scale=4;
Num_orien=6;

Ti=cell(Texture_num,1);
for i=1:Texture_num
    N=num2str(i);
    Ti{i}=imread(['D',N,'.bmp']);
%     Fi(i,:)=Laplacian_Pyramid(Ti{i},Gau_Layer,Gau_sigma,Gau_Kernal);
    E0=gaborconvolve(Ti{i},Num_scale,Num_orien,3,2,0.6,1.5); %Gabor filtering images
    for j=1:Num_scale
        for k=1:Num_orien
            New{j,k}=abs(E0{j,k});
        end
    end
    
    E01=New(:)';
    Lib(i,:)=E01;
end

[rows,cols]=size(Lib);

for i=1:rows
    h=1;
    for j=1:cols
        temp=Lib{i,j};
        [Mean,Var,Std_dev,Skew,Kur]=MyStatistics(temp); %To obtain feature vectors
%          Fe(i,h)=Mean;
%          h=h+1;
         Fe(i,h)=Var;
         h=h+1;
         Fe(i,h)=Std_dev;
         h=h+1;
%          Fe(i,h)=Skew;
%          h=h+1;
%          Fe(i,h)=Kur;
%          h=h+1;
    end
end
Num_of_elements=size(Fe,2);

for i=1:Num_of_elements %Normalizing feature vectors and creating texture library
    Max_Var(i)=max(Fe(:,i));
    Min_Var(i)=min(Fe(:,i));
    Nor(:,i)=(Fe(:,i)-Min_Var(i))/(Max_Var(i)-Min_Var(i));
end

Gabor_2;
Gabor_3;
Gabor_4;
    
toc

% for i=1:Num_of_elements
%     Max_Var(i)=max(Fi(:,i));
%     Min_Var(i)=min(Fi(:,i));
%     Ni(:,i)=(Fi(:,i)-Min_Var(i))/(Max_Var(i)-Min_Var(i));
% end

% for i=1:Num_scale
%     for j=1:Num_orien
%         ind=(i-1)*Num_orien+j;
%         subplot(4,6,ind);
%         imshow(abs(E0{i,j}),[]);
%     end
% end






