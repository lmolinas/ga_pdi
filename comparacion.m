srcFiles = dir('source/'); 
MC=uint8(imread('MC.jpg'));
fid=fopen('resultado_todos.csv','w');
fprintf(fid,'Imagen;Co;C H;C F;C CH;C M;SSIM H;SSIM CH;SSIM M;SSIM F;\n');
for i = 1 : length(srcFiles)
    if ~isdir(['source/',srcFiles(i).name])
    source = strcat('source/',srcFiles(i).name);
    metodo = strcat('mi/',srcFiles(i).name);
    
    S = imread(source);
    if(ndims(S)==3)
       S=rgb2gray(S); 
     end
%      if(ndims(M)==3)
%        M=rgb2gray(M); 
%      end
%      S=imresize(S,0.5);
%      M=imresize(M,0.5);
     
      C = adapthisteq(S);
      C_Hist = histeq(S);
      
      condicion=true;
      tamano=6;
      ant=-1;
      IMANT=S;
      while condicion
          IMM=funcion(S,strel('square',tamano));
          valor=fobjetivo(S,IMM);
          if valor>=ant
             IMANT=IMM;
             ant=valor;
          end
          tamano=tamano+tamano*2
          if valor<ant
              condicion=false;
          end
      end
     
       imwrite(C,['uni/CL_' srcFiles(i).name '.png']);
        imwrite(C_Hist,['uni/H_' srcFiles(i).name '.png']);
       imwrite(IMANT,['uni/F_' srcFiles(i).name '.png']);
       imwrite(S,['uni/S_' srcFiles(i).name '.png']);
%        imwrite(M,['uni/M_' srcFiles(i).name '.png']);
%         
   
%     s2=['HISTOGRAMA ' 'AMBE ' num2str(AMBE(S,C_Hist)) ' CONT G ' num2str(CONTRASTE(C_Hist)) ' CONTL ' num2str(vh) ' SSIM ' num2str(ssim(S,C_Hist))];
%     s3=['CLAHE  21x21' 'AMBE ' num2str(AMBE(S,C)) ' CONT G ' num2str(CONTRASTE(C)) ' CONTL ' num2str(vCH) ' SSIM ' num2str(ssim(S,C))];
%     s4=['MI ' 'AMBE ' num2str(AMBE(S,M)) ' CONT G ' num2str(CONTRASTE(M)) ' CONT L ' num2str(vM) ' SSIM ' num2str(ssim(S,M))];
%     
%     disp(s2);
%     disp(s3);
%     disp(s4);
%     disp(' ');
    size(S);
    size(C);
    size(C_Hist);
%     size(M);
    size(IMANT);
    srcFiles(i).name;
    
  %fprintf(fid,'%s;%f;%f;%f;%f;%f;%f;%f;\n',srcFiles(i).name,CONTRASTE(S),CONTRASTE(C_Hist),CONTRASTE(C),CONTRASTE(M),ssim(S,C_Hist),ssim(S,C),ssim(S,M));    
  fprintf(fid,'%s;%f;%f;%f;%f;%f;%f;%f;%f;%f;\n',srcFiles(i).name,CONTRASTE(S),CONTRASTE(C_Hist),CONTRASTE(IMANT),CONTRASTE(C),1,ssim(S,C_Hist),ssim(S,C),1,ssim(S,IMANT));    
  
    end
end
fclose(fid);
