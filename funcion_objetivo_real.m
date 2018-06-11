function resultado = funcion_objetivo_real(S,R,varargin)

[c2]=CONTRASTE(R)/127.5;


nVarargs = length(varargin);
if nVarargs == 0
    [c1]=CONTRASTE(S)/127.5;
else
    c1=varargin{1};
end

[similaridad]=nssim(S,R,'exponents',[1 0 1]);
 
 
% delta=(c2-c1);
% resultado=0;
% if(delta>0)
%      resultado=(similaridad+delta)/2;
% %       resultado=c2;
% end

% clazz=class(S);
% if strcmp(clazz,'gpuArray')
%     clazz=classUnderlying(S);
% end
% dynmRange = diff(getrangefromclass(zeros(1,1,clazz)));
% C=(0.03*dynmRange).^2;
% dc=(2*c1*c2+C)/(c1^2+c2^2+C);
% if(c1>c2)
%    dc=dc*-1; 
% end
    if(c2>c1)
        resultado=abs(c2+similaridad)/2;
    end
end

