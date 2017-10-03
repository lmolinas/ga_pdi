% addpath('db');
out='resumen/';
mkdir(out);
outfile=[out 'salida.xls'];
row = {'Imagen','C','SSIM','F','cuartil3','max','min','quartil1'};
xlswrite(outfile,row,1,'A1:H1');


idx=2;
in='out/';
srcFiles = dir(in);
for i = 1 : length(srcFiles)
    [in srcFiles(i).name]
    if isdir([in,srcFiles(i).name]) & ~(strcmp(srcFiles(i).name,'.') | strcmp(srcFiles(i).name,'..'))
        file=[in,srcFiles(i).name, '/bests.csv'];
        %         leer csv
        %       extraer datos de contaste y ssim
        T=readtable(file,'Delimiter',';');
        
        if size(T,2)==9
            T1=str2double(strrep(table2array(T(:, 8:9)),',','.' ) );
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
%         T=table2array(T(:, 8:9));
        
        T2
        T1

        f=mean(T2);
        mx=max(T2)
        idx = find(T==mx,1);
        
        c=max(T1(idx,1));
        ssim=max(T1(idx,2));
        
        cuartil=quantile(T2,3);
        cuartil
         cuartil3=cuartil(3);
         maxi=max(T2);
         mini=min(T2);
         quartil1=cuartil(1);

        
        row = {srcFiles(i).name,c,ssim,f,cuartil3,maxi,mini,quartil1};
    
        xlRange = strcat('A',int2str(idx),':H',int2str(idx));
        xlRange 
        row 
        xlswrite(outfile,row,1,xlRange);
        idx=idx+1;
        % almacenar en un archivo resumen
    end
end