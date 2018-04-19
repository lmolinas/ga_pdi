function [v]= C_bloques(imagen)
%CONTRASTE Summary of this function goes here
%   Detailed explanation goes here

[x,y]=size(imagen);
idx=0:10;
idy=0:10;

idx=idx*x/4;
idy=idy*y/4;

idx(1)=1;
idy(1)=1;

valores=1:4;
for i=1:4
    a=idx(i);
    b=idx(i+1);
    
    
    c=idy(i);
    d=idy(i+1);
    im=imagen(a:b,c:d);
    hist=imhist(im)';
    t=numel(hist);
    hist=hist/numel(im);
    E=mean(mean(im));

    k=double(0:t-1);
    ke_pk=(k-E).^2.*hist;
    valores(i)=sqrt(sum(ke_pk));
    if isa(valores(i),'gpuArray') 
        clear hist;
        clear t;
        clear E;
        clear ke_pk;
    end
    
end
    
v=mean(valores);
end

