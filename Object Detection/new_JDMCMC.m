
clc;
clear all;
close all;
rng('shuffle');





lambda = 2;
Max_Steps = 15; %Number of steps
Kmax = 10; %Max number of objects
k = 5;
Burn_in_start = 4;
Burn_in_step_size = 2;


I=double(imread('discs8.bmp'))/255;     % read the test image
Tar=double(imread('target.bmp'))/255;     % read the target image

[X, Y]=size(I);


video=VideoWriter('JDMCMC8.avi');
video.FrameRate=60;
open(video);

Objs = zeros(Max_Steps, 1);
Objs(1) = k;
Oxy = cell(Max_Steps, 1);%Objects position
Oxy{1} = [randi(X, Objs(1) , 1) randi(Y, Objs(1), 1)];%k hypothesized object locations
I0 = drawcircle(I, (Oxy{1})', Objs(1));
figure(1); imshow(I0);
Imframe(1:X,1:Y,1)=I0;
Imframe(1:X,1:Y,2)=I0;
Imframe(1:X,1:Y,3)=I0;
writeVideo(video,I0);
Likelihood_fns = zeros(Max_Steps, 1);
L1_Poiss=poisspdf(Objs(1), lambda);
Likelihood_fns(1) = likelihood(I, Tar, Oxy{1}, Objs(1)) * L1_Poiss; %aposterior for evaluation




for i = 2:Max_Steps
    a = rand(1);
    if a < 0.33 && Objs(i-1) > 1
        Objs(i) = Objs(i-1) - 1;%
        fprintf('jump -1');
        [Oxy{i} oxy_old] = gibbs(I, Tar, Objs(i),video); %Gibbs_sampling
        oxy_old;
        % Accept or reject by Metropolis Sampling
        L_Poiss=poisspdf(Objs(i), lambda);
        Likelihood_fns(i) = likelihood(I, Tar, Oxy{i}, Objs(i)) * L_Poiss;
        oxy_old;
        v0 = min(Likelihood_fns(i)/Likelihood_fns(i-1), 1);%probability of acceptance
        u0 = rand(1);
        if v0 < u0 %reject samples by saving the previous value
            fprintf('--Reject');
            Objs(i) = Objs(i-1);
            Oxy{i} = Oxy{i-1};
            Likelihood_fns(i) = Likelihood_fns(i-1);
        end
    elseif a < 0.66 && Objs(i-1) < Kmax
        
        Objs(i) = Objs(i-1) + 1;
        fprintf('jump +1');
        [Oxy{i} oxy_old] = gibbs(I, Tar, Objs(i),video); %Gibbs_sampling
        oxy_old;
        % Accept or reject by Metropolis Sampling
        L_Poiss=poisspdf(Objs(i), lambda);
        Likelihood_fns(i) = likelihood(I, Tar, Oxy{i}, Objs(i)) * L_Poiss;
        
        v0 = min(Likelihood_fns(i)/Likelihood_fns(i-1), 1);%probability of acceptance
        u0 = rand(1);
        if v0 < u0 %reject samples by saving the previous value
            fprintf('--Reject');
            Objs(i) = Objs(i-1);
            Oxy{i} = Oxy{i-1};
            Likelihood_fns(i) = Likelihood_fns(i-1);
        end
    else
        Objs(i) = Objs(i-1);
        fprintf('no jump');
        [Oxy{i} oxy_old] = gibbs(I, Tar, Objs(i),video); %Gibbs_sampling
        
        % Accept or reject by Metropolis Sampling
        L_Poiss=poisspdf(Objs(i), lambda);
        Likelihood_fns(i) = likelihood(I, Tar, Oxy{i}, Objs(i)) * L_Poiss;
        
        v0 = min(Likelihood_fns(i)/Likelihood_fns(i-1), 1);%probability of acceptance
        u0 = rand(1);
        if v0 < u0 %reject samples by saving the previous value
            fprintf('--Reject');
            Objs(i) = Objs(i-1);
            Oxy{i} = Oxy{i-1};
            Likelihood_fns(i) = Likelihood_fns(i-1);
        end
    end
    
end


% Step 3
% Select samples after M iterations (burn-in);
% Obtain a set of samples with certain step size.

B_Oxy = Oxy(Burn_in_start + 1:Burn_in_step_size:Max_Steps);
B_objs = Objs(Burn_in_start + 1:Burn_in_step_size:Max_Steps);

l=length(B_objs);
final_obj = round(sum(sum(B_objs))/l);

K_B_Oxy = B_Oxy(B_objs == final_obj);
num_samp = length(K_B_Oxy);
Samps = zeros(final_obj, 2, num_samp); 
for i = 1:num_samp
    Samps(:,:,i) = K_B_Oxy{i};
end
Ord_S = reorder(Samps);
final_Oxy = round(mean(Ord_S,3));
reshape(final_Oxy, 2, [])'
%Final result

fin_img = drawcircle(I, final_Oxy, final_obj);
figure(2);imshow(fin_img);
writeVideo(video,fin_img);

close(video);

function [Fxy Oxy_old] = gibbs(Image, target, Objs,video)

num = 100;

Walk = 300;
[X Y] = size(Image);
%1. Initialize {zi: i = 1, ..., M}
temp = zeros(Objs, 2, num);
temp(:,:,1) = [randi(X, Objs, 1) randi(Y, Objs, 1)];%All object position
Oxy_old = temp(:,:,1);
I0 = drawcircle(Image, Oxy_old, Objs);
figure(1); imshow(I0);
writeVideo(video,I0);
L1 = likelihood(Image, target, Oxy_old, Objs);


for k = 2:num
    for q = 1:Objs
        Oxy = Oxy_old(2*q-1:2*q);%init position of ith object
        for j = 1:Walk
            %Sampling ith variable
            Dxy = Oxy + round(randn(1,2)*20);
            Dxy=clip(Dxy,1,X);% make sure the position in the image
            Oxy_new = Oxy_old;
            Oxy_new(2*q-1:2*q) = Dxy;
            L2=likelihood(Image,target,Oxy_new,Objs);% evaluate the likelihood
            v=min(1,L2/L1);                     % compute the acceptance ratio
            u=rand;                             % draw a sample uniformly in [0 1]
            if v>u
                Oxy = Dxy;% accept the move
                Oxy_old = Oxy_new;
                L1 = L2;
                %                 showImg = drawcircle(img, Cur_Oxy, M);
                %                 figure(1); imshow(showImg);
            else
            end
        end
        temp(:,:, k) = Oxy_old;
        I0 = drawcircle(Image, Oxy_old, Objs);
        figure(1); imshow(I0);
        Imframe(1:X,1:Y,1)=I0;
        Imframe(1:X,1:Y,2)=I0;
        Imframe(1:X,1:Y,3)=I0;
%         writeVideo(video,I0);
        
    end
    writeVideo(video,I0);
end


Fxy = Oxy_old;
I0 = drawcircle(Image, Fxy, Objs);
figure(1);imshow(I0);
Imframe(1:X,1:Y,1)=I0;
Imframe(1:X,1:Y,2)=I0;
Imframe(1:X,1:Y,3)=I0;
writeVideo(video,I0);

end

function Ord_Samp = reorder(Samp)
num_samp = size(Samp, 3);%number of samples
Ord_Samp = Samp;
for i = 1:num_samp
    S1 = Samp(:,:,i);
    S1 = reshape(S1, 2, []);
    temp = S1(1, :).^2 + S1(2,:).^2;
    [B IX] = sort(temp,'ascend');
    S1 = S1(:, IX);
    S1 = reshape(S1, [], 2);
    Ord_Samp(:,:,i) = S1;
end
end

