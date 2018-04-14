function resultado = funcion_objetivo_real(S,R,varargin)

[c2]=CONTRASTE(R)/127.5;


nVarargs = length(varargin);
if nVarargs == 0
    [c1]=CONTRASTE(S)/127.5;
else
    c1=varargin{1};
end
 [similaridad]=nssim(S,R);
delta=(c2-c1);
resultado=0;
if(delta>0)
     resultado=(similaridad+delta)/2;
%       resultado=c2;
end
end

