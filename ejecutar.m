addpath('db');
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
        r=ga_pdi(I,strcat(out,srcFiles(i).name,'/'));
        fprintf(f_resumen,'%s; %f; %f\n',srcFiles(i).name,r.mejor,r.tiempo);
        reset(gpuDevice());
    end
end
fclose(f_resumen);
