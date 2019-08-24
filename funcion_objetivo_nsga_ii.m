function [resultado] = funcion_objetivo_nsga_ii(I,S1,dimension,c1)
% sfdf
SR=convertir_individuo2se(S1,dimension);
R=metodologia_morfologica(I, strel('arbitrary',SR));
resultado=funcion_objetivo_real_nsga_ii(I,R,c1);
end

