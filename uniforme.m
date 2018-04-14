

i=1;
f=9000;
for k=0:255
    i=1+k*9000;
    f=(k+1)*9000;
    fx(i:f)=k;
end
imhist(fx)