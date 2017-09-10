function  SR = convertir_individuo2se( S1,dimension)

SE=zeros(1,dimension*dimension);
SE(1,1:(dimension*dimension)-1)=S1;
SE(1,dimension*dimension)=1;
SE=vec2mat(SE,dimension);

SR=zeros(dimension*2-1,dimension*2-1);
SR(1:dimension,1:dimension)=SE;
SR(1:dimension,dimension+1:dimension*2-1)=fliplr(SE(1:dimension,1:dimension-1));
SR(dimension+1:dimension*2-1,1:dimension)=flip(SE(1:dimension-1,1:dimension));
SR(dimension+1:dimension*2-1,dimension+1:dimension*2-1)=flip(fliplr(SE(1:dimension-1,1:dimension-1)));

end