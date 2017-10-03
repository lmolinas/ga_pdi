function [resultado] = funcion_objetivo(I,S1,dimension,c1)
% sfdf
SR=convertir_individuo2se(S1,dimension);
R=metodologia_morfologica(I, strel('arbitrary',SR));
resultado=1-funcion_objetivo_real(I,R,c1);
end

