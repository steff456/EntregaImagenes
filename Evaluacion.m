    %Prueba Imagenes train
clc, clear all, close all
carp= 'Cubos\Test'; direccion= dir(carp); j =1; index= 0;
%carga el template
dire= 'Cubos\template.mat';
load(dire);
%Carga todas las imagenes de train
for i=4:2:size(direccion,1)
    c= i/2-1;
    eval(sprintf('M%d = load(fullfile(carp,direccion(i).name));', c));
    %     if eval(sprintf('size(M%d.cubo_mask,3) > max ',c)), eval(sprintf('max= size(M%d.cubo_mask,3)',c)), index=i; end
%     if eval(sprintf('size(M%d.cubo_mask,3) < min ',c)), eval(sprintf('min= size(M%d.cubo_mask,3)',c)),  end
end
for i=3:2:size(direccion,1)
    c= i/2+1.5-2;
    eval(sprintf('I%d = load(fullfile(carp,direccion(i).name));', c));
    %     if eval(sprintf('size(I%d.cubo,3) > max ',c)), eval(sprintf('max= size(I%d.cubo,3)',c)), end
%     if eval(sprintf('size(I%d.cubo,3) < min ',c)), eval(sprintf('min= size(I%d.cubo,3);',c)); end
    index= index+1;
end
%Ecualiza todas las imagenes
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
    
    iact= eval(sprintf('E%d',i));
    mact= eval(sprintf('ME%d',i));
    [in, nim]= Mandible_segmentation(iact,template,mact);
%     eval(sprintf('[index%d, nim%d] = Mandible_segmentation(iact,template,mact);',i))
    fprintf('seleccione cualquier tecla para continuar \n')
    pause()
end

% h= inputdlg('Escriba el numero de la imagen que quiere cargar', 'Función');
% numi= strcat('E',h{1});
% numm= strcat('ME',h{1});
