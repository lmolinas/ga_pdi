% addpath('db');
out='resumen/';
mkdir(out);
outfile=[out 'diagrama_cajas.xls'];
% row = {'Imagen','C','SSIM','F','cuartil3','max','min','quartil1'};
% xlswrite(outfile,row,1,'A1:H1');


idx=2;
in='out/';
srcFiles = dir(in);
for i = 1 : length(srcFiles)
    [in srcFiles(i).name]
    if isdir([in,srcFiles(i).name]) ...
            & ~(strcmp(srcFiles(i).name,'.') ...
            | strcmp(srcFiles(i).name,'..'))
        srcSubFiles = dir([in,srcFiles(i).name]);
        V=zeros(length(srcSubFiles)-3,1000);
        minIteracion=1000;
        idxRow=1;
        for j = 1 : length(srcSubFiles)
            srcSubFiles(j).name
            if ~(strcmp(srcSubFiles(j).name,'bests.csv') ...
                    | strcmp(srcSubFiles(j).name,'.') ...
                    | strcmp(srcSubFiles(j).name,'..'))                
                file=[ in,srcFiles(i).name, '/',srcSubFiles(j).name ];
                T=readtable(file,'Delimiter',';');
                T1=table2array(T(:, 2));
                T1=1-T1';
                V(idxRow,1:size(T1,2))=T1;
                if(size(T1,2)<minIteracion)
                    minIteracion=size(T1,2);
                end
                idxRow=idxRow+1;
                
            end    
        end
        % aca tenemos la matriz, columna son iteraciones
        % filas son valores
        % tomamos  60 puntos a intervalos iguales 
        % calculamos valores necesarios para dibujar el
        % grafico de cajas
        % quartil 3, max, min quartil 1
        V2=V(:,1:minIteracion);
        
        rango=floor(minIteracion/50)-1;
        totalElementos=50;
        rango=rango*[1:totalElementos];
        
        totalElementos=totalElementos+2;
        V2=V(:,[1 rango minIteracion]);
        size(V2)
%         num = sum(V2 == 0)
        cuartil=quantile(V2,3);
        mx=max(V2);
        mn=min(V2);
        totalElementos
        R=ones(totalElementos,4);
        R(:,1)=cuartil(3,:)';
        R(:,2)=mx';
        R(:,3)=mn';
        R(:,4)=cuartil(1,:)';
        xlswrite(outfile,R,srcFiles(i).name);
    end
end