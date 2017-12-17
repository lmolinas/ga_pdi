addpath('metricas');

out='resumen2/';
pathDB='db/';

mkdir(out);
outfile=[out 'salida.xlsx'];
row = {'Imagen','cuartil3','max','min','quartil1','C','SSIM','F','CLAHE','HE','M-FIROZ'};
xlswrite(outfile,row,1,'A1:K1');

idx=2;
in='out/';
srcFiles = dir(in);
for i = 1 : length(srcFiles)
    [in srcFiles(i).name]
    if isdir([in,srcFiles(i).name]) & ~(strcmp(srcFiles(i).name,'.') | strcmp(srcFiles(i).name,'..'))     
        % Leer imagen original, mejorar y evaluar
           source = strcat(pathDB,srcFiles(i).name);
           S = imread(source);
           if(ndims(S)==3)
              S=rgb2gray(S); 
           end
           disp(srcFiles(i).name);
           CLAHE = adapthisteq(S);
           HE = histeq(S);
           FIROZ=firoz(S);
        
        file=[in,srcFiles(i).name, '/bests.csv'];
        %         leer csv
        %       extraer datos de contaste y ssim
        T=readtable(file,'Delimiter',';');
        
        if size(T,2)==9
            % Datos de ssim y contraste
            T1=str2double(strrep(table2array(T(:, 8:9)),',','.' ) );
            % datos de 1-fitness
            T2=1-str2double(strrep(table2array(T(:,2)) ,',','.'));
        else
            aux=strrep(table2array(T(:,7)),',','.' );
            r=double(zeros(numel(aux),3));
            for idxr = 1:numel(aux)
               gg=aux(idxr);
               r(idxr,:)=str2double(strsplit(gg{1},' '));
            end
            T1=r(:,2:3);
            T2=1-table2array(T(:,2));
        end
%        T=table2array(T);
%         T
%         T2
%         T1

        f=mean(T2);
        mx=max(T2);
        idxMAX = find(T2 == mx,1);
        
        c=T1(idxMAX,1);
        ssim=T1(idxMAX,2);
        
        cuartil=quantile(T2,3);
        cuartil3=cuartil(3);
        maxi=max(T2);
        mini=min(T2);
        quartil1=cuartil(1);

        
        row = {srcFiles(i).name...
            ,cuartil3 ,maxi ,mini ,quartil1 ,c ,ssim ,f...
            ,funcion_objetivo_real(S,CLAHE)...
            ,funcion_objetivo_real(S,HE)...
            ,funcion_objetivo_real(S,FIROZ)}
    
        xlRange = strcat('A',int2str(idx),':K',int2str(idx));
        xlRange 
        xlswrite(outfile,row,xlRange);
        idx=idx+1
        % almacenar en un archivo resumen
    end
end