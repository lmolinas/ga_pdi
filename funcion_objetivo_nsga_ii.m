function [resultado] = funcion_objetivo_nsga_ii(I,S1,dimension,bits_lambda,c1)
    % sfdf
    if bits_lambda > 0
        SR=convertir_individuo2se(S1(1:numel(S1)-bits_lambda),dimension);
        R=metodologia_morfologica_lambda(I, strel('arbitrary',SR), bi2de(S1(numel(S1)-bits_lambda+1:numel(S1)))+1);
    else
        SR=convertir_individuo2se(S1,dimension);
        R=metodologia_morfologica(I, strel('arbitrary',SR));
    end
    resultado=funcion_objetivo_real_nsga_ii(I,R,c1);
end

