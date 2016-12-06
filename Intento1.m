%Proyecto - Intento 1 - Segmentar hueso
clc, clear all, close all
tic
cout= 'Cubos'; nout= fullfile(cout, 'Train',horzcat('0522c0081','.mat'));
mout= fullfile(cout, 'Train',horzcat('0522c0081_mask','.mat'));
load(mout), load(nout)
m= zeros(256, size(cubo,3));
for i= 1: size(cubo,3), m(:,i)= imhist(cubo(:,:,i)); end
nhis= round(mean(m,2)); I= cubo; bw= I; nbw=bw;
ses= strel('disk',1); se= strel('square',3);
for k= 1: size(I,3), bw(:,:,k)=imerode(imdilate(im2bw(histeq(cubo(:,:,k),nhis),0.82),se),se); end
for j= 1: size(I,3), nbw= medfilt2(bw(:,:,i),[3,3]); end

toc
%mascarita
mask= cubo_mask;
for k= 1: size(I,3), mask(:,:,k)=im2bw(histeq(cubo_mask(:,:,k),nhis)); end %imdilate(im2bw(histeq(cubo_mask(:,:,k),nhis)),se)-imerode(im2bw(histeq(cubo_mask(:,:,k),nhis)),se); end
index= zeros(1,size(cubo,3)); maxvol=0;
for j= 1:size(cubo,3)
    if(j==1)
        index(j)=numel(find(and(bw(:,:,j),mask(:,:,j))==1))/numel(find(imadd(bw(:,:,j),mask(:,:,j)))~=0);
    else
        index(j)= index(j-1) + numel(find(and(bw(:,:,j),mask(:,:,j))==1))/numel(find(imadd(bw(:,:,j),mask(:,:,j)))~=0);
    end
    if(numel(find(mask(:,:,j))~=0) ~=0)
        maxvol= maxvol+ numel(find(and(mask(:,:,j),mask(:,:,j))==1))/numel(find(imadd(mask(:,:,j),mask(:,:,j)))~=0);
    end
    subplot(1,2,1)
    imshow(bw(:,:,j), [0 1])
    title('Imagen segmentada')
    drawnow()
    subplot(1,2,2)
    imshow(mask(:,:,j), [0 1])
    title('Máscara')
end


