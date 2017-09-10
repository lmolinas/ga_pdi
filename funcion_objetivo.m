function [resultado] = funcion_objetivo(I,S1,dimension,c1)
% sfdf
SR=convertir_individuo2se(S1,dimension);
R=metodologia_morfologica(I, strel('arbitrary',SR));
[c2]=CONTRASTE(R)/127.5;
[similaridad]=nssim(I,R);

delta=(c2-c1);
resultado=1.0;

if(delta>0)
    resultado=1-(similaridad+c2)/2;
end

if isa(I,'gpuArray') 
    clear R;
end
end

