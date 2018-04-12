clear;
clc;
close all;

%starting a VideoWriter to create an animation
vid= VideoWriter('movie_2.mp4');
vid.FrameRate = 30;
open(vid);%open function is used to start writing into the video file

for i= 0:0.1:5 %looping over the axes to create an animation
    %storing the image coordinates in a vector to plot it every single time
    [Poi_vec(1,1),Poi_vec(1,2)]=coordinates(5-i,5-i,0);
    [Poi_vec(2,1),Poi_vec(2,2)]=coordinates(5+i,5-i,0);
    [Poi_vec(3,1),Poi_vec(3,2)]=coordinates(5-i,5+i,0);
    [Poi_vec(4,1),Poi_vec(4,2)]=coordinates(5+i,5+i,0);
    [Poi_vec(5,1),Poi_vec(5,2)]=coordinates(5-i,5-i,(i*2));
    [Poi_vec(6,1),Poi_vec(6,2)]=coordinates(5+i,5-i,(i*2));
    [Poi_vec(7,1),Poi_vec(7,2)]=coordinates(5-i,5+i,(i*2));
    [Poi_vec(8,1),Poi_vec(8,2)]=coordinates(5+i,5+i,(i*2));
   
     Im=imread('test_image.bmp');
     
    

fig = figure
set(fig,'visible','off') %to not display figure every loop
imshow(Im);

[xx, yy]=size(Poi_vec);
  for j=1:2:xx
      hold on;
      %to join the lines
      plot([Poi_vec(j,1),Poi_vec(j+1,1)],[Poi_vec(j,2),Poi_vec(j+1,2)],'LineWidth',2,'Color','b');
  end
  for j=1:2
      plot([Poi_vec(j,1),Poi_vec(j+2,1)],[Poi_vec(j,2),Poi_vec(j+2,2)],'LineWidth',2,'Color','b');
      plot([Poi_vec(j,1),Poi_vec(j+4,1)],[Poi_vec(j,2),Poi_vec(j+4,2)],'LineWidth',2,'Color','b');
  end
  for j=7:8
     plot([Poi_vec(j,1),Poi_vec(j-2,1)],[Poi_vec(j,2),Poi_vec(j-2,2)],'LineWidth',2,'Color','b');
     plot([Poi_vec(j,1),Poi_vec(j-4,1)],[Poi_vec(j,2),Poi_vec(j-4,2)],'LineWidth',2,'Color','b');
  end
   y=[Im(Poi_vec(1,1)) ; Im(Poi_vec(3,1)) ; Im(Poi_vec(5,1)) ; Im(Poi_vec(7,1))];
     area(y, 'FaceColor','flat')
  
  
  saveas(fig,sprintf('cube1.png'));%store each frame as this filename
  
  New = imread('cube1.png');
  
  Fr = im2frame(New);%convert the image to a frame
  
  writeVideo(vid,Fr);%to write a frame onto the video file
  
 

    
end
close(vid);%stop writing to the video file and close 

function [u,v]= coordinates(x,y,z)
 Image=imread('test_image.bmp');
% figure(1),imshow(Image);
load model.dat;
[wx,wy,wz]=size(model)
for i=1:wx
    M1=model(i,1);
    X(1,i)=M1;
    M2=model(i,2);
    Y(1,i)=M2;
    M3=model(i,3);
    Z(1,i)=M3;
end
load observe.dat
[Ox,Oy]=size(observe)

for i=1:Ox
    M4=observe(i,1);
    Ix(1,i)=M4;
    M5=observe(i,2);
    Iy(1,i)=M5;
end

%calculate the Q matrix
Q(1:2*wx,1:12) = 0;
j=1;
for i=1:2:2*wx
    Q(i,1)=X(j);
    Q(i,2)=Y(j);
    Q(i,3)=Z(j);
    Q(i,4)=1;
    Q(i+1,5)=X(j);
    Q(i+1,6)=Y(j);
    Q(i+1,7)=Z(j);
    Q(i+1,8)=1;
    Q(i,9:12)=Q(i,1:4)*-1*Ix(j);
    Q(i+1,9:12)=Q(i,1:4)*-1*Iy(j);
    j=j+1;
end

[U S V]=svd(Q);

[evalue,index]=min(diag(S(1:12,1:12)));

m=V(1:12,index);

% M_dup=reshape(m,3,4)'

norm_1=norm(m(9:11));

m_1 = m/norm_1;
M(1,1:4)= m_1(1:4);
M(2,1:4)=m_1(5:8);
M(3,1:4) = m_1(9:12);

%calculate the A and b matrix
a1=M(1,1:3)
a2=M(2,1:3)
a3=M(3,1:3)
A1=[a1' a2' a3']
A=A1'
b=M(1:3,4)


%calculating the intrinsic parameters
e=1;
p=e/norm(a3);
u0=p^2*dot(a1,a3');
v0=p^2*dot(a2,a3');
theta= acos(-1*dot(cross(a1,a3),cross(a2,a3))/norm(cross(a1,a3)*norm(cross(a2,a3))));
alpha=p^2*norm(cross(a1,a3))*sin(theta);
beta=p^2*norm(cross(a2,a3))*sin(theta);

%calculating extrinsic parameters

r1= cross(a2,a3)/norm(cross(a2,a3));
r3=p*a3;
r2=cross(r3,r1);

%Rotation matrix R
R(1,1:3)=r1;
R(2,1:3)=r2;
R(3,1:3)=r3;

K = [alpha -1*alpha*cot(theta) u0 ; 0 beta/sin(theta) v0; 0 0 1] % Matrix K
t= p*inv(K) * b; % Matrix t

m1=M(1,1:4);
m2=M(2,1:4);
m3=M(3,1:4);

Wp = [x, y, z, 1]

z1=m3 * Wp';
u=ceil((m1 * Wp')*1/z1);
v=ceil((m2 * Wp')*1/z1);
end



% %find the coordinates of cube
% Poi_vec=[]
% ind=1;
% for i=0:1
%     for j=0:1
%         Wp=[i j 0 1]
%         z1=m3 * Wp';
%         Poi_vec(ind,1)=ceil((m1 * Wp')*1/z1);
%         Poi_vec(ind,2)=ceil((m2 * Wp')*1/z1);
%         ind=ind+1;
%         Wp2=[i j 1 1]
%         z2=m3 * Wp2';
%         Poi_vec(ind,1)=ceil((m1 * Wp2')*1/z2);
%         Poi_vec(ind,2)=ceil((m2 * Wp2')*1/z2);
%         ind=ind+1;
%     end
% end
% % for i=0:1
% %     for j=0:1
% %         Wp=[i j 1 1]
% %         z1=m3 * Wp';
% %         Poi_vec(ind,1)=ceil((m1 * Wp')*1/z1);
% %         Poi_vec(ind,2)=ceil((m2 * Wp')*1/z1);
% %         ind=ind+1;
% %     end
% % end
% 
% [xx, yy]=size(Poi_vec)
% for i=1:xx
%     mx=Poi_vec(i,1)
%     my=Poi_vec(i,2)
%     for j=mx:mx
%         for k=my:my
%             Image(k,j)=0;
%         end
%     end
% end
% Im=imread('test_image.bmp');
%  imshow(Im)
%  for i=1:2:xx
%      hold on;
%      plot([Poi_vec(i,1),Poi_vec(i+1,1)],[Poi_vec(i,2),Poi_vec(i+1,2)],'Color','k');
%  end
%  for i=1:2
%      plot([Poi_vec(i,1),Poi_vec(i+2,1)],[Poi_vec(i,2),Poi_vec(i+2,2)],'Color','k');
%      plot([Poi_vec(i,1),Poi_vec(i+4,1)],[Poi_vec(i,2),Poi_vec(i+4,2)],'Color','k');
%  end
%  for i=7:8
%     plot([Poi_vec(i,1),Poi_vec(i-2,1)],[Poi_vec(i,2),Poi_vec(i-2,2)],'Color','k');
%      plot([Poi_vec(i,1),Poi_vec(i-4,1)],[Poi_vec(i,2),Poi_vec(i-4,2)],'Color','k');
%  end



% plot([Poi_vec(1,1),Poi_vec(3,1)],[Poi_vec(1,2),Poi_vec(3,2)]);
% plot([Poi_vec(1,1),Poi_vec(5,1)],[Poi_vec(1,2),Poi_vec(5,2)]);      
% plot([Poi_vec(7,1),Poi_vec(5,1)],[Poi_vec(7,2),Poi_vec(5,2)]); 
% plot([Poi_vec(7,1),Poi_vec(3,1)],[Poi_vec(7,2),Poi_vec(3,2)]); 
% plot([Poi_vec(2,1),Poi_vec(4,1)],[Poi_vec(2,2),Poi_vec(4,2)]);
% plot([Poi_vec(2,1),Poi_vec(6,1)],[Poi_vec(2,2),Poi_vec(6,2)]);      
% plot([Poi_vec(8,1),Poi_vec(6,1)],[Poi_vec(8,2),Poi_vec(6,2)]); 
% plot([Poi_vec(8,1),Poi_vec(4,1)],[Poi_vec(8,2),Poi_vec(4,2)]); 

