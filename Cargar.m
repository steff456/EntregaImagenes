%Proyectito
%Cargar las imagenes a un cubo
close all, clc, clear all
direccion= dir('data');
for j=3:size(direccion,1)
    nombre= direccion(j).name;
    carp= dir(fullfile('data', nombre));
    cubo_mask= uint8(zeros(512,512,size(carp,1)-11));
    for i= 3:size(carp,1)
        iact= carp(i).name;
        c= strsplit(iact, '.'); % c{1}= nombreactual_id c{2}= png
        if isequal(c{2}, 'png')
            d= strsplit(c{1},'_'); id= str2num(d{2}); %d{1}= nombreactual d{2}= id
            im= imread(fullfile('data',nombre,iact));
            g= rgb2gray(im);
            cubo_mask(:,:,id)=g;
        end
    end
    cout= 'Cubos'; nout= fullfile(cout, horzcat(nombre,'.mat'));
    save(nout, 'cubo');
end
%%
for i= 1: size(bw,3)
    imshow(bw(:,:,i))
end
%%
%Importar mascara mandibula
close all, clc, clear all
direccion= dir('data');
h = waitbar(0,'Hagale papito...');
steps = size(direccion,1);
for j=3:size(direccion,1)
    nombre= direccion(j).name;
    carp= dir(fullfile('data', nombre));
    for i= 3:size(carp,1)
        iact= carp(i).name;
        c= strsplit(iact, '.'); % c{1}= nombreactual_id c{2}= png
        if isequal(c{1}, 'Mandible')
            man= dir(fullfile('data',nombre,horzcat(c{1},'.',c{2})));
            cubo_mask= uint8(zeros(512,512,size(man,1)-2));
            for k= 3:size(man,1)
                kact=man(k).name;
                p= strsplit(kact, '.'); q= strsplit(p{2},'_'); id= str2num(q{2});
                im= imread(fullfile('data',nombre,horzcat(c{1},'.',c{2}),kact));
                g= rgb2gray(im);
                cubo_mask(:,:,id)=g;
            end
            cout= 'Cubos'; nout= fullfile(cout, horzcat(nombre,'_mask.mat'));
            save(nout, 'cubo_mask');
        end
    end
    waitbar(j / steps)
end
close(h)