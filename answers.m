clear
clc
%%
img = imread('1111.jpg');
lines = pkline(rgb2gray(img));
linelen = [lines.length];
lines = lines(linelen>100);
field1 = 'point1';
field2 = 'point2';
field3 = 'length';
field4 = 'gradient';
for i = 1:length(lines)
    value1(:,1) = lines(i).point1;
    value2(:,1) = lines(i).point2;
    value3(:,1) = lines(i).length;
    value4(:,1) = (lines(i).point1(2)-lines(i).point2(2))/(lines(i).point1(1)-lines(i).point2(1));
    lines1(i) = struct(field1,value1,field2,value2,field3,value3,field4,value4);
    
end
%%
j=1;
k=1;
for i = 1:length(lines1)
    field1 = 'point1';
    field2 = 'point2';
    value1 = lines1(i).point1;
    value2 = lines1(i).point2;
    if ((floor(abs(lines1(i).gradient)))==0)
        hori(j)=struct(field1,value1,field2,value2);
        j=j+1;
    else
        veri(k)=struct(field1,value1,field2,value2);
        k=k+1;
    end
end
n=1;
for i = 1:length(veri)
    verizonPoint(n,1)=veri(i).point1(1);
    verizonPoint(n,2)=veri(i).point1(2);
    verizonPoint(n,3)=veri(i).point2(1);
    verizonPoint(n,4)=veri(i).point2(2);
    verizonPoint(n,5)=(abs(veri(i).point1(1)+veri(i).point2(1)))/2;
    verizonPoint(n,6)=abs(veri(i).point1(2)+veri(i).point2(2))/2;
    if ((verizonPoint(n,5)>50)&&(verizonPoint(n,5))<400)
        verizonPoint(n,:)=[];
    elseif ((verizonPoint(n,5))<50)
        verizonPoint(n,7)=0;
        n=n+1;
    else
        verizonPoint(n,7)=1;
        n=n+1;
        
    end
end

m=1;
for i = 1:length(hori)
    
    horizonPoint(m,1)=hori(i).point1(1);
    horizonPoint(m,2)=hori(i).point1(2);
    horizonPoint(m,3)=hori(i).point2(1);
    horizonPoint(m,4)=hori(i).point2(2);
    horizonPoint(m,5)=abs(hori(i).point1(1)+hori(i).point2(1))/2;
    horizonPoint(m,6)=abs(hori(i).point1(2)+hori(i).point2(2))/2;
    if ((horizonPoint(m,6)>20)&&(horizonPoint(m,6))<450)
        horizonPoint(m,:)=[];
    elseif (horizonPoint(m,6)<20)
        horizonPoint(m,7)=0;
        m=m+1;
    else
        horizonPoint(m,7)=1;
        m=m+1;
        
    end
end

%%
[topx,topy]=find(horizonPoint(:,7)==0,2);
[bottomx,bottomy]=find(horizonPoint(:,7)==1);
[leftx,lefty]=find(verizonPoint(:,7)==0);
[rightx,righty]=find(verizonPoint(:,7)==1);

top = horizonPoint(topx,:);
bottom = horizonPoint(bottomx,:);
left = verizonPoint(leftx,:);
right = verizonPoint(rightx,:);
for i = 1:4
    field1 = 'point1';
    field2 = 'point2';
    if (i==1)
        p=[min(left(:,5)),max(right(:,5))];
        x=[(top(:,1))',(top(:,3))'];
        y=[(top(:,2))',(top(:,4))'];
        A=polyfit(x,y,1);
        z=polyval(A,p);
        value1 = [p(1),z(1)];
        value2 = [p(2),z(2)];
    end
    
    if (i==2)
        p=[min(left(:,5)),max(right(:,5))];
        x=[(bottom(:,1))',(bottom(:,3))'];
        y=[(bottom(:,2))',(bottom(:,4))'];
        A=polyfit(x,y,1);
        z=polyval(A,p);
        value1 = [p(1),z(1)];
        value2 = [p(2),z(2)];
        
    end
    
    
    if (i==3)
        
        p=[min(top(:,6)),min(bottom(:,6))];
        x=[(left(:,1))',(left(:,3))'];
        y=[(left(:,2))',(left(:,4))'];
        A=polyfit(x,y,1);
        z=polyval(A,p);
        z=(p-A(2))./A(1);
        value1 = [z(1),p(1)];
        value2 = [z(2),p(2)];
    end
    
    
    if (i==4)
        for j = 1:size(right,1)
            right(j,8) = abs(right(j,5)-min(right(:,5)));
        end
        [a,b]=find(right(:,8)<7);
        right=right(a,:);
        p=[min(top(:,6)),min(bottom(:,6))];
        x=[(right(:,1))',(right(:,3))'];
        y=[(right(:,2))',(right(:,4))'];
        A=polyfit(x,y,1);
        z=(p-A(2))./A(1);
        value1 = [z(1),p(1)];
        value2 = [z(2),p(2)];
    end
    
    finalLines(i)=struct(field1,value1,field2,value2)
end
%%
% for i = 1:4
%     field1 = 'point1';
%     field2 = 'point2';
%     if (i==1)
%
%         value1 = [min(left(:,5)),min(top(:,6))];
%         value2 = [max(right(:,5)),min(top(:,6))];
%     end
%
%     if (i==2)
%         value1 = [min(left(:,5)),min(bottom(:,6))];
%         value2 = [max(right(:,5)),min(bottom(:,6))];
%     end
%
%
%     if (i==3)
%
%         value1 = [min(left(:,5)),min(top(:,6))];
%         value2 = [min(left(:,5)),min(bottom(:,6))];
%     end
%
%
%     if (i==4)
%
%         value1 = [min(right(:,5)),min(top(:,6))];
%         value2 = [min(right(:,5)),min(bottom(:,6))];
%     end
%
%     finalLines(i)=struct(field1,value1,field2,value2)
% end
%%
finalLines=finalLines';
disp_lines(img,finalLines);

grayimg=rgb2gray(img);
topmidx=(finalLines(1).point1(1)+finalLines(1).point2(1))/2;
topmidy=(finalLines(1).point1(2)+finalLines(1).point2(2))/2;
bottommidx = (finalLines(2).point1(1)+finalLines(2).point2(1))/2;
bottommidy = (finalLines(2).point1(2)+finalLines(2).point2(2))/2;
leftmidx = (finalLines(3).point1(1)+finalLines(3).point2(1))/2;
leftmidy = (finalLines(3).point1(2)+finalLines(3).point2(2))/2;
rightmidx = (finalLines(4).point1(1)+finalLines(4).point2(1))/2;
rightmidy = (finalLines(4).point1(2)+finalLines(4).point2(2))/2;
picture = grayimg(topmidy+46:topmidy+107,leftmidx+35:leftmidx+106);
imshow(picture)

picture = im2bw(picture,0.8);
imshow(picture)

for i = 1:5
    c=(floor(size(picture,1)/5));
    d=c*i-4;
    Q=picture(d-6:d+6,:);
    figure()
    imshow(Q)
    for j = 1:4
        f=floor(size(Q,2)/4);
        h = [1,f.*[1,2,3,4]];
        answer(i,j)=size(find(Q(:,h(j):h(j+1))==0),1);
        figure()
        imshow(Q(:,h(j):h(j+1)));
    end
end

%%
[xx,yy]=max(answer');

chara=['A','B','C','D'];

disp('The answer is :')

for i = 1:length(yy)
    disp(chara(yy(i)))
end
