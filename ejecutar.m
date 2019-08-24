clc;
clear;
close all;

addpath('db');
addpath('NSGA-II');
out='pruebas/20180703/';
db='db/';
mkdir(out);
srcFiles = dir(db);
f_resumen=fopen(strcat(out,'resumen.csv'),'w');

fprintf(f_resumen,'Imagen; fitness; tiempo\n');

for i = 1 : length(srcFiles)
    if ~isdir([db,srcFiles(i).name])
        source = strcat(db,srcFiles(i).name);
        I = imread(source);
        size_cuadrante=17;
        %r=ga_pdi(I,strcat(out,srcFiles(i).name,'/'), size_cuadrante);
        nsga2(I, size_cuadrante);
        fprintf(f_resumen,'%s; %f; %f\n',srcFiles(i).name,r.mejor,r.tiempo);
        reset(gpuDevice());
    end
end
fclose(f_resumen);
