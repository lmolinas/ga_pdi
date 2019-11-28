clc;
clear;
close all;

addpath('db');
addpath('NSGA-II');

formatOut = 'yyyymmddHHMM';
fecha = datestr(now,formatOut);
outFecha=strcat('pruebas/',fecha,'/');
mkdir(outFecha);

size_cuadrante=17;
pCrossoverFraction=0.75;
pMutationRate=0.025;
pPopulationSize=80;
pGenerations=800;

f_parametros=fopen(strcat(outFecha, 'parametros.csv'),'w');
fprintf(f_parametros,'size_cuadrante; pCrossoverFraction; pMutationRate; pPopulationSize; pGenerations\n');
fprintf(f_parametros,'%g; %g; %g; %g; %g\n',size_cuadrante, pCrossoverFraction, pMutationRate, pPopulationSize, pGenerations);
        
outRainer=strcat(outFecha,'Rainer/');
mkdir(outRainer);
f_resumen=fopen(strcat(outRainer,'resumen.csv'),'w');
fprintf(f_resumen,'Imagen; fitness; tiempo\n');

outArEv=strcat(outFecha,'ArEv/');
mkdir(outArEv);
f_resumenArEv=fopen(strcat(outArEv,'resumen.csv'),'w');
fprintf(f_resumenArEv,'Imagen; tiempo\n');

db='db/';
srcFiles = dir(db);
for i = 1 : length(srcFiles)
    if ~isdir([db,srcFiles(i).name])
        source = strcat(db,srcFiles(i).name);
        I = imread(source);
        if ndims(I)==3
            I=rgb2gray(I);
        end
        %I=gpuArray(I);
        r=ga_pdi(I,strcat(outRainer,srcFiles(i).name,'/'), size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        fprintf(f_resumen,'%s; %f; %f\n',srcFiles(i).name,r.mejor,r.tiempo);
        ra=funcion_objetivo_nsga_ii(I,r.S1,size_cuadrante,CONTRASTE(I)/127.5);
        rnsga2=nsga2(strcat(outArEv,srcFiles(i).name,'/'), I, ra, size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        fprintf(f_resumenArEv,'%s; %f\n',srcFiles(i).name,rnsga2.tiempo);
        %reset(gpuDevice());
    end
end
fclose(f_parametros);
fclose(f_resumen);
fclose(f_resumenArEv);

