function R = firoz(S)
% metodo de referencia Firoz
condicion=true;tamano=2;f_anterior=-1;R_anterior=S;

% mejora iterativa
while condicion
      R=metodologia_morfologica(S,strel('disk',tamano));
      valor=calcCNR(S,R);
    % si el valor actual de la fun obj es mayor a la anterior
      if valor>=f_anterior
         R_anterior=R;
         f_anterior=valor;
         tamano=tamano+1;
      else
          % si el valor de la funcion objetivo actual es menor que la
           % anterio terminar
          condicion=false;
      end     
end

R=R_anterior;
end