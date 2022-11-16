clc
close all
clear all
 
f1 = imread(<File Location>);
I = rgb2gray(f1);
D = im2double(I);
[m,n]=size(I);

%% Histogram
H = zeros(1,256);
for i=1:1:m
    for j=1:1:n
        H(I(i,j)+1)= H(I(i,j)+1)+1;
    end
end

% To Display Histogram
figure
plot(H/(m*n));
grid on;
ylabel('Number of pixel');
xlabel('Gray Level');
title('Histogram of Image');

%% Thresholding
T = zeros(size(f1));
for i=1:m
    for j=1:n
        if(I(i,j)<250)
            T(i,j)=1;
        else
            T(i,j)=0;
        end
    end
end
     
%% Canny Edge detect
mag=zeros(size(I));
[mag,th] = edge(T,'Canny') ;
figure;
subplot 131;
imshow(I);
title('Orignal Image');

subplot 132;
imshow(T);
title('Thresholded Image');

subplot 133;
imshow(mag);
title("Canny Edge");

%% Hough Transform
a=0;
b=0;
r1=10;                      
r2=60;                      
acc(1:m+2*r2,1:n+2*r2,1:r2)=0;           
                            
 for rad=r1:r2                        %varying radius
    for x=1:m                %angle step increase toh threshold dec
        for y=1:n
            for teta=1*pi/180:pi/180:360*pi/180
                if(mag(x,y)~=0)
                 a=x-rad*cos(teta);             %1-rad to m+rad
                 b=y-rad*sin(teta);
                 acc(ceil(a+rad),ceil(b+rad),rad)=acc(ceil(a+rad),ceil(b+rad),rad)+1;
                 a=0;
                 b=0;
                end
            end
        end
    end
 end

display(max(max(acc)));

ac(1:m,1:n)=0; 
hg1=I;
count2=0;
sumijk=0;
sumij=0;
imsumijk=0;
for k=r1:r2
   for i=1:m
       for j=1:n
            if(acc(i,j,k)>204)                 %199
                count2=count2+1;                 %187
                ac(i,j)=ac(i,j)+1;             %214
            else
                    acc(i,j,k)=0;
            end
        end
   end
end

hg2=f1;
BW=imregionalmax(acc);
for i=1:m
    for j=1:n
        for k=r1:r2
            if(BW(i,j,k)==1)
                imsumijk=imsumijk+1;
                 hg2=insertText(hg2,[j-k i-k],imsumijk,'AnchorPoint','Center','FontSize',10,'BoxOpacity',0.4);
                 hg2=insertText(hg2,[j-k i-k+10],pi*(k^2),'AnchorPoint','Center','FontSize',7,'BoxOpacity',0.8);
                 c1(imsumijk,:)={[j-k i-k],k};
            end
        end
    end
end

c2=cell2mat(c1(:,1));
c3=cell2mat(c1(:,2));
area=zeros(imsumijk,1);

for i=1:imsumijk
   for x=1:m
     for y=1:n
        if((x-c2(i,2))^2+(y-c2(i,1))^2<=(c3(i)^2))
         area(i,1)=area(i,1)+1;
        end
     end
   end
end
figure;
imshow(hg2);
title('imHough Transform');
