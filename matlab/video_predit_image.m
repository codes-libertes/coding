
function Ip = predit_image(Iref,V)

% param�tres

% taille de l'image
[ty,tx,nbcolor] = size(Iref);
% taille de la matrice de mouvement
[tvy,tvx,tmp] = size(V);
% taille du macrobloc
tmby = ty / tvy;
tmbx = tx / tvx;

% Convertir la matrice en Vecteur afin de faciliter la progammation
Vy = reshape(V(:,:,2)',1,[]);
Vx = reshape(V(:,:,1)',1,[]);
% Index du Vecteur
IndexV = 1;

Ip = uint8(zeros(ty,tx,nbcolor));

% signification des variables
% (by,bx) = position du bloc dans l'image pr�dite
% (rby,rbx) = position du bloc dans l'image de r�f�rence
% (dy,dx) = mouvement
% (vy,vx) = position courante dans la matrice V

for by=1:tmby:ty
    for bx = 1:tmbx:tx
        % *************
        % * COMPLETER *
        % *************
        fprintf('\nI Blk Iref: x:%d---%d y:%d----%d Vx[%d] Vy[%d]\n',bx,tmbx+bx-1, by,tmby+by-1,Vx(IndexV),Vy(IndexV));
        % Prendre un macrobloc (4*4)
        % En abscisse X, chaque �l�ment du bloc bouge � l'inverse plusieurs pas selon la valeur du vecteur de mouvement Vx 
        % En ordonn�e Y, chaque �l�ment du bloc bouge � l'inverse plusieurs pas selon la valeur du vecteur de mouvement Yx
        Ip(by:tmby+by-1,bx:tmbx+bx-1) = Iref(by-Vy(IndexV):tmby+by-1-Vy(IndexV),bx-Vx(IndexV):tmbx+bx-1-Vx(IndexV));
        IndexV = IndexV+1;
    end
end
