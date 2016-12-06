function [ J, nim ] = Mandible_segmentation( imagen, template, mask )
%MANDIBLE_SEGMENTATION Función que permite segmentar la mandibula de las
%imagenes de tomografia axial computarizada.
%   Es necesario que le entren 3 parametros donde se necesita la imagen en
%   3D que contiene la tomografia del paciente y se encuentra ecualizada. 
%   El template, es una imagen
%   2D mas pequeña que la imagen grande. Por último, la mascara (opcional)
%   permite calcular el indice de Jaccard. Si no hay mascara el indice
%   retornado es 0
%Se realiza la comprobación de los argumentos de entrada
tic
hayMask= 0;
switch nargin
    case 2
        hayMask=0;
    case 3
        hayMask=1;
end

%Realiza la morfologia matematica en la mascara y en la imagen
p= strel('ball',3,3);
pe= strel('ball',5,5);
temptemp= E; mask2= ME;

temptemp= imdilate(temptemp,p);
temptemp= imerode(temptemp,pe);

%Se realiza la binarización y morfologia pertinente
for i=1:size(temptemp,3)
    temptemp(:,:,i)= medfilt2(temptemp(:,:,i),[7,7]);
    temptemp(:,:,i)= im2bw(temptemp(:,:,i),0.76);
    mask2(:,:,i)=im2bw(mask2(:,:,i));
    temptemp(:,:,i)= bwmorph(temptemp(:,:,i),'majority',inf);
end
    
f= template;
temp= temptemp;

temp2=zeros(size(temp,1), size(temp,2)*size(temp,3));

for i=1:size(temp,3)
    temp2(:,1+512*(i-1):512*i)=temp(:,:,i);
end

temp2=double(temp2);
a=vision.TemplateMatcher;
c=step(a,temp2,f);
ret=c;

temp3=temp;
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

temp3=double(temp3); mask2= double(mask2);
nim=temp3;

if hayMask
    suma= temp3 + mask2;
    s= numel(find(suma==2));
    J= s/(numel(find(temp3==1))+numel(find(mask2==1)));
else
    J=0;
end
toc
end

