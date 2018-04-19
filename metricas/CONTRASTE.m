function [v]= CONTRASTE(im)
%CONTRASTE Summary of this function goes here
%   Detailed explanation goes here

hist=imhist(im)';
t=numel(hist);
hist=hist/numel(im);
E=mean(mean(im));

k=double(0:t-1);
ke_pk=(k-E).^2.*hist;
v=sqrt(sum(ke_pk));
if isa(v,'gpuArray') 
    v=gather(v);
    
    clear hist;
    clear t;
    clear E;
    clear ke_pk;
end
end

