function resultado = funcion_objetivo_real_nsga_ii(S,R,varargin)


[c2]=CONTRASTE(R);

nVarargs = length(varargin);
if nVarargs == 0
    [c1]=CONTRASTE(S);
else
    c1=varargin{1}*127.5;
end

[similaridad]=nssim(S,R,'Exponents',[1 0 1]);
 

clazz=class(S);
if strcmp(clazz,'gpuArray')
    clazz=classUnderlying(S);
end
dynmRange = diff(getrangefromclass(zeros(1,1,clazz)));
C=(0.03*dynmRange).^2;
dc=(2*c1*c2+C)/(c1^2+c2^2+C);
if(c1>c2)
   dc=dc*-1; 
end
resultado=[similaridad dc]';
end

