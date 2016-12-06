clc, clear all, close all
carp= 'Cubos\Train'; direccion= dir(carp); min= inf; j =1; index= 0;
for i=4:2:size(direccion,1)
    c= i/2-1;
    eval(sprintf('M%d = load(fullfile(carp,direccion(i).name));', c));
    %     if eval(sprintf('size(M%d.cubo_mask,3) > max ',c)), eval(sprintf('max= size(M%d.cubo_mask,3)',c)), index=i; end
    if eval(sprintf('size(M%d.cubo_mask,3) < min ',c)), eval(sprintf('min= size(M%d.cubo_mask,3)',c)),  end
end
for i=3:2:size(direccion,1)
    c= i/2+1.5-2;
    eval(sprintf('I%d = load(fullfile(carp,direccion(i).name));', c));
    %     if eval(sprintf('size(I%d.cubo,3) > max ',c)), eval(sprintf('max= size(I%d.cubo,3)',c)), end
    if eval(sprintf('size(I%d.cubo,3) < min ',c)), eval(sprintf('min= size(I%d.cubo,3);',c)); end
    index= index+1;
end
for i=1:index
    act= eval(sprintf('I%d', i));
    actM= eval(sprintf('M%d', i));
    m= zeros(256, size(act.cubo,3));
    n= zeros(256, size(actM.cubo_mask,3));
    for j= 1:size(act.cubo,3)
        m(:,j)= imhist(act.cubo(:,:,j));
        n(:,j)= imhist(actM.cubo_mask(:,:,j));
    end
    nhis= round(mean(m,2)); nhis2= round(mean(n,2));
    eval(sprintf('E%d= act.cubo;', i));
    eval(sprintf('ME%d= actM.cubo_mask;', i));
    for j= 1: size(act.cubo,3)
        eval(sprintf('E%d(:,:,j)= histeq(act.cubo(:,:,j),nhis);', i));
        eval(sprintf('ME%d(:,:,j)= histeq(actM.cubo_mask(:,:,j),nhis);', i));
    end
%     p= strel('ball',3,3);
%     pe= strel('ball',5,5);
%     eval(sprintf('R%d = act.cubo;', i))
%     eval(sprintf('MB%d = actM.cubo_mask;', i))
%     eval(sprintf('R%d = imdilate(R%d,p);', i))
%     fprintf('holooo')
%     eval(sprintf('R%d = imerode(R%d,pe);', i))
%     for j=1:size(act.cubo,3)
%         eval(sprintf('R%d(:,:,j) = im2bw(R%d(:,:,j),0.76);', i))
%         eval(sprintf('MB%d(:,:,j) = im2bw(ME%d(:,:,j),0.76);', i))
% %         temp(:,:,j)= im2bw(temp(:,:,j),0.76);
% %         mask(:,:,j)= im2bw(ME1(:,:,j));
%     end
end
%%
%pruebita
close all
se= strel('disk',3);
ses= strel('disk',5);
sese= strel('disk',1);
% a= imdilate(E1(:,:,65),se)-imerode(E1(:,:,65),se);
% imshow(a)
temp= E1; mask= M1.cubo_mask; temptemp= E13; mask2= ME13;
% y= find(temp<150);
% temp(y)= 0;
% r= ones(31,31,size(E1,3)); r(:,16,:)=1;
p= strel('ball',3,3);
pe= strel('ball',5,5);
temp= imdilate(temp, p);
temp= imerode(temp,pe);
temptemp= imdilate(temptemp,p);
temptemp= imerode(temptemp,pe);
% skel= temp;
for i=1:size(temp,3)
    temp(:,:,i)= medfilt2(temp(:,:,i),[7,7]); % 7 9  13::: 15
    temp(:,:,i)= im2bw(temp(:,:,i),0.76);
    mask(:,:,i)= im2bw(ME1(:,:,i));
    temp(:,:,i)= bwmorph(temp(:,:,i),'majority',inf);
%     skel(:,:,i)= bwmorph(temp(:,:,i),'skel', inf);
end
for i=1:size(temptemp,3)
    temptemp(:,:,i)= medfilt2(temptemp(:,:,i),[7,7]);
    temptemp(:,:,i)= im2bw(temptemp(:,:,i),0.76);
    mask2(:,:,i)=im2bw(mask2(:,:,i));
    temptemp(:,:,i)= bwmorph(temptemp(:,:,i),'majority',inf);
end

%%
f= double(temp(220:310,140:200,60));
temp= temptemp;
temp2=zeros(size(temp,1), size(temp,2)*size(temp,3));

for i=1:size(temp,3)
    temp2(:,1+512*(i-1):512*i)=temp(:,:,i);
end
temp2=double(temp2);
%%
fprintf('HOLOO ************')
a=vision.TemplateMatcher;
c=step(a,temp2,f);
fprintf('----------------------- ------------------')
%%
temp3=temp;
% jo=strel('line',20,0);
for i=ceil(c(1)/512)+1:size(temp,3)
    if i== ceil(c(1)/512)+1;
    ef=zeros(size(temp,1),size(temp,2));
    ef(c(2)-(size(f,2)/2):c(2)+(size(f,2)/2),c(1)-(ceil(c(1)/512))*512-(size(f,2)/2):c(1)-(ceil(c(1)/512))*512+(size(f,2)/2))=temp(c(2)-(size(f,2)/2):c(2)+(size(f,2)/2),c(1)-(ceil(c(1)/512))*512-(size(f,2)/2):c(1)-(ceil(c(1)/512))*512+(size(f,2)/2),i);
    temp3(:,:,i)=and(imdilate(ef,strel('disk',15)),temp(:,:,i));
    else
        ef=zeros(size(temp,1),size(temp,2));
        temp3(:,:,i)=and(imdilate(temp3(:,:,i-1),strel('disk',2)),temp(:,:,i));
    end
            
end
for i=floor(c(1)/512)+1:-1:1
    if i==floor(c(1)/512)+1;
    ef=zeros(size(temp,1),size(temp,2));
    ef(c(2)-(size(f,2)/2):c(2)+(size(f,2)/2),c(1)-(ceil(c(1)/512))*512-(size(f,2)/2):c(1)-(ceil(c(1)/512))*512+(size(f,2)/2))=temp(c(2)-(size(f,2)/2):c(2)+(size(f,2)/2),c(1)-(ceil(c(1)/512))*512-(size(f,2)/2):c(1)-(ceil(c(1)/512))*512+(size(f,2)/2),i);
    temp3(:,:,i)=and(imdilate(ef,strel('disk',15)),temp(:,:,i));
    else
        ef=zeros(size(temp,1),size(temp,2));
        temp3(:,:,i)=and(imdilate(temp3(:,:,i+1), strel('disk',4)),temp(:,:,i));
    end
            
end                    

% for i= 1:size(E2,3)
%     subplot(1,3,1)
%     imshow(temp(:,:,i), [0 1])
%     title('segmentación')
%     subplot(1,3,2)
%     imshow(skel(:,:,i), [0 1])
%     title('skel')
%     subplot(1,3,3)
%     imshow(mask(:,:,i), [0 1])
%     title('Mascara')
%     drawnow()
% end
% for i= 1: size(E1,3)
%     imshow(mask(:,:,i), [0 1])
% end
temp3=double(temp3); mask2= double(mask2);
suma= temp3 + mask2;
s= numel(find(suma==2));
index= s/(numel(find(temp3==1))+numel(find(mask2==1)));