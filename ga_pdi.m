function resultado = ga_pdi(I,out)
%% 
addpath('metricas');
if ndims(I)==3
    I=rgb2gray(I);
end
I=gpuArray(I);

mkdir(out);

fbest=fopen(strcat(out,'bests.csv'),'w');
size_cuadrante=17;
f_fitness = @(S)funcion_objetivo(I,S,size_cuadrante,CONTRASTE(I)/127.5);
% definir los parametros del GA
opts = gaoptimset(@ga);
opts.TolFun=0;
opts.StallGenLimit=800;
opts.Display='iter';
opts.PopulationType='bitstring';
opts.PopulationSize=80;
opts.Generations=800;
opts.CrossoverFcn=@crossovertwopoint;
opts.CrossoverFraction=0.75;
opts.UseParallel=false;
opts.MutationFcn={@mutationuniform, 0.025};
opts.SelectionFcn=@selectiontournament;

fprintf(fbest,'Tiempo; best; promedio; cuartil3; max; min; quartil1;c ;ssim\n');


F=[];
tt=tic()
for i=1:2
    fid=fopen(strcat(out,'iter_',int2str(i),'.csv'),'w');
    try
        tini=tic();
        opts.OutputFcns=@(options,state,flag)log_in_file(options,state,flag,fid,fbest,tini,I,size_cuadrante,out,int2str(i));    
        [x,Fval,exitFlag,Output] = ga(f_fitness,size_cuadrante*size_cuadrante-1,opts);
        F(i)=Fval;
    catch ME
        fprintf(fbest,'NO SE TERMONO ITER NRO %f\n',i);
        ME
    end
    fclose(fid);
end
fclose(fbest);
final=toc(tt);
if isa(I,'gpuArray') 
    clear I;
end
resultado={};
resultado.mejor=mean(1-F);
resultado.tiempo=final;

end
