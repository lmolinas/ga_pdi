clc;
clear;
close all;

addpath('db');
addpath('NSGA-II');

formatOut = 'yyyymmddHHMM';
fecha = datestr(now,formatOut);
outFecha=strcat('pruebas/',fecha,'/');
mkdir(outFecha);

size_cuadrante=4;
pCrossoverFraction=0.75;
pMutationRate=0.025;
pPopulationSize=10;
pGenerations=5;

f_parametros=fopen(strcat(outFecha, 'parametros.csv'),'w');
fprintf(f_parametros,'size_cuadrante; pCrossoverFraction; pMutationRate; pPopulationSize; pGenerations\n');
fprintf(f_parametros,'%g; %g; %g; %g; %g\n',size_cuadrante, pCrossoverFraction, pMutationRate, pPopulationSize, pGenerations);
fclose(f_parametros);
        
outRainer=strcat(outFecha,'Rainer/');
mkdir(outRainer);
f_resumen=fopen(strcat(outRainer,'resumen.csv'),'w');
fprintf(f_resumen,'Imagen; fitness; tiempo\n');

outArEv=strcat(outFecha,'ArEv/');
mkdir(outArEv);
f_resumenArEv=fopen(strcat(outArEv,'resumen.csv'),'w');
fprintf(f_resumenArEv,'Imagen; tiempo\n');

outArEvLambda=strcat(outFecha,'ArEv-lambda/');
mkdir(outArEvLambda);
f_resumenArEvLambda=fopen(strcat(outArEvLambda,'resumen.csv'),'w');
fprintf(f_resumenArEvLambda,'Imagen; tiempo\n');

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
        %r=ga_pdi(I,strcat(outRainer,srcFiles(i).name,'/'), size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        %fprintf(f_resumen,'%s; %f; %f\n',srcFiles(i).name,r.mejor,r.tiempo);
        
        bits_lambda=0;
        rnsga2=nsga2(strcat(outArEv,srcFiles(i).name,'/'), I, size_cuadrante, bits_lambda, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        fprintf(f_resumenArEv,'%s; %f\n',srcFiles(i).name,rnsga2.tiempo);
        
        bits_lambda=3;% 3 bits para representar numeros del 1 al 8.
        rnsga2_lambda=nsga2(strcat(outArEvLambda,srcFiles(i).name,'/'), I, size_cuadrante, bits_lambda, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate);
        fprintf(f_resumenArEvLambda,'%s; %f\n',srcFiles(i).name,rnsga2_lambda.tiempo);
        
        %reset(gpuDevice());
    end
end
fclose(f_resumen);
fclose(f_resumenArEv);
fclose(f_resumenArEvLambda);