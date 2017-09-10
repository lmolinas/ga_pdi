function r = metodologia_morfologica( i ,se )
%FUNCION Summary of this function goes here
%   Detailed explanation goes here

th=imtophat(i,se);
bh=imbothat(i,se);
r=i+th-bh;

if strcmp(class(i),'gpuArray')
    clear bh;
    clear th;
end
    
end

