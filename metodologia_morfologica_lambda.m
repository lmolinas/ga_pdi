function r = metodologia_morfologica_lambda( i, se, l )
%FUNCION Summary of this function goes here
%   Detailed explanation goes here

th=imtophat(i,se);
bh=imbothat(i,se);
r=i+(l*th)-(l*bh);

if strcmp(class(i),'gpuArray')
    clear bh;
    clear th;
end
    
end

