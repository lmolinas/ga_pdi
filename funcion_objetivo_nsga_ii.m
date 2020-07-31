function [resultado] = funcion_objetivo_nsga_ii(I,S1,L,dimension)
    % sfdf
    SR=convertir_individuo2se(S1,dimension);

    if isempty(L)
        R=metodologia_morfologica(I, strel('arbitrary',SR));
    else
        lambda=bi2de(L)+1;
        R=metodologia_morfologica_lambda(I, strel('arbitrary',SR), lambda);
    end
    
    resultado=funcion_objetivo_real_nsga_ii(I,R);

end

