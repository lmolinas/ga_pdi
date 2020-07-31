function resultado = funcion_objetivo_real_nsga_ii(S,R)

[c2]=CONTRASTE(R);
[similaridad]=nssim(S,R,'Exponents',[1 0 1]);

resultado=[similaridad c2]';
end

