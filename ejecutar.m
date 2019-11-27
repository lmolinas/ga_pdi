clc;
clear;
close all;

addpath('db');
addpath('NSGA-II');
formatOut = 'yyyymmddHHMM';
fecha = datestr(now,formatOut);
outFecha=strcat('pruebas/',fecha,'/');
outRainer=strcat(outFecha,'Rainer/');
db='db/';
mkdir(outRainer);
srcFiles = dir(db);
f_resumen=fopen(strcat(outRainer,'resumen.csv'),'w');

fprintf(f_resumen,'Imagen; fitness; tiempo\n');

for i = 1 : length(srcFiles)
    if ~isdir([db,srcFiles(i).name])
        source = strcat(db,srcFiles(i).name);
        I = imread(source);
        if ndims(I)==3
            I=rgb2gray(I);
        end
        %I=gpuArray(I);
        size_cuadrante=17;
        pCrossoverFraction=0.75;
        pMutationRate=0.025;
        pPopulationSize=5;
        pGenerations=10;
        r=ga_pdi(I,strcat(outRainer,srcFiles(i).name,'/'), size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        fprintf(f_resumen,'%s; %f; %f\n',srcFiles(i).name,r.mejor,r.tiempo);
        ra=funcion_objetivo_nsga_ii(I,r.S1,size_cuadrante,CONTRASTE(I)/127.5);
        nsga2(I, ra, size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        %reset(gpuDevice());
    end
end
fclose(f_resumen);
