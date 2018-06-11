addpath('./metricas')

path='db/';
out_path=strcat(pwd,'\r20180611\');
mkdir(out_path);
srcFiles = dir(path); 
filename = strcat(out_path,'ref.xls');

row = {'Imagen','Ci','C','SSIM','CLAHE','C','SSIM','HIST','C','SSIM','FIROZ'};
xlswrite(filename,row,1,'A1:K1');

idx=2;
for i = 1 : length(srcFiles)
if ~isdir([path,srcFiles(i).name])
        source = strcat(path,srcFiles(i).name);
        S = imread(source);
        if(ndims(S)==3)
           S=rgb2gray(S); 
        end
       disp(srcFiles(i).name);
       CLAHE = adapthisteq(S);
       HISTO = histeq(S);
       FIROZ=firoz(S);
      
%       imwrite(CLAHE,['uni/CLAHE_' srcFiles(i).name '.png']);
%       imwrite(HISTO,['uni/HISTO_' srcFiles(i).name '.png']);
%       imwrite(IMANT,['uni/C_' srcFiles(i).name '.png']);

    row = {srcFiles(i).name,...
        CONTRASTE(S),...
        CONTRASTE(CLAHE),nssim(S,CLAHE),funcion_objetivo_real(S,CLAHE),...
        CONTRASTE(HISTO),nssim(S,HISTO),funcion_objetivo_real(S,HISTO),...
        CONTRASTE(FIROZ),nssim(S,FIROZ),funcion_objetivo_real(S,FIROZ)};
    
    xlRange = strcat('A',int2str(idx),':K',int2str(idx));
    xlswrite(filename,row,1,xlRange);
    idx=idx+1;
end
end