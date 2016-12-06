clc, clear all, close all
carp= 'Cubos\Train'; direccion= dir(carp); min= inf; j =1; index= -1;
for i=4:2:size(direccion,1)
    c= i/2-1;
    eval(sprintf('M%d = load(fullfile(carp,direccion(i).name))', c));
    %     if eval(sprintf('size(M%d.cubo_mask,3) > max ',c)), eval(sprintf('max= size(M%d.cubo_mask,3)',c)), index=i; end
    if eval(sprintf('size(M%d.cubo_mask,3) < min ',c)), eval(sprintf('min= size(M%d.cubo_mask,3)',c)),  end
end
for i=3:2:size(direccion,1)
    c= i/2+1.5-2;
    eval(sprintf('I%d = load(fullfile(carp,direccion(i).name))', c));
    %     if eval(sprintf('size(I%d.cubo,3) > max ',c)), eval(sprintf('max= size(I%d.cubo,3)',c)), end
    if eval(sprintf('size(I%d.cubo,3) < min ',c)), eval(sprintf('min= size(I%d.cubo,3)',c)); end
end
m1= zeros(256, size(I1.cubo,3));
for i= 1: size(I1.cubo,3), m1(:,i)= imhist(I1.cubo(:,:,i)); end
nhis1= round(mean(m1,2));
m2= zeros(256, size(I2.cubo,3));
for i= 1: size(I2.cubo,3), m2(:,i)= imhist(I2.cubo(:,:,i)); end
nhis2= round(mean(m2,2));
for i= 1: eval(sprintf('size(I%d.cubo,3)',1))
    I1.cubo(:,:,i)= histeq(I1.cubo(:,:,i),nhis1);
    I2.cubo(:,:,i)= histeq(I2.cubo(:,:,i),nhis2);
end
% for i= 1: eval(sprintf('size(I%d.cubo,3)',1))
%     imshow(I1.cubo(:,:,i))
%     title(i)
% end
temp= I1.cubo(220:310,140:200,54:79);
% t= zeros(size(temp,1), size(temp,2),1);
% t(:,:,1)=temp;
% c= convn(I1.cubo, temp(end:-1:1,end:-1:1,end:-1:1),'same');
% [x y z] = ind2sub(size(c),find(c==max(c(:))));
% x=x-(size(temp, 1) - 1)/2;
% y=y-(size(temp, 2) - 1)/2;
% z=z-(size(temp, 3) - 1)/2;