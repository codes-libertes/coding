function Q = mat_quantif(K)

% *************
% * COMPLETER *
% *************
Xmax=8;
Ymax=8;
% Choisir un vecteur afin de faciliter la progammation
vec=zeros(1,Xmax*Ymax);

for i=0:Ymax-1
    for j=0:Xmax-1
          % l'algorithme Qij=1+K(1+i+j)
          vec(j+1+i*Ymax) = 1+K*(i+j+1);
    end
end
% Convertir un vecteur en une matrice
Q=vec2mat(vec,Ymax)
