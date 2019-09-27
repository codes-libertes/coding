
function V = estim_mvt(I,Iref)

% convention:
% x = indice de colonne (vers la droite)
% y = indice de ligne (vers le bas)

Iref = double(Iref)
I = double(I)
% param�tres
% extension du domaine de recherche
ex = 4; % ne pas descendre en dessous de 4
ey = ex;
% taille du macrobloc
tmbx = 16;
tmby = tmbx;
% taille de l'image
[ty,tx,nbcolor] = size(Iref);

% taille de la matrice de mouvement
tvy = ty / tmby;
tvx = tx / tmbx;

V = zeros(tvy,tvx,2);

% Choisir le vecteur afin de faciliter la progammation
Vx = zeros(1,tvx*tvy);
Vy = zeros(1,tvx*tvy);

% signification des variables
% (by,bx) = position du bloc dans l'image courante
% (rby,rbx) = position du bloc dans l'image de r�f�rence
% (dy,dx) = mouvement
% (vy,vx) = position courante dans la matrice V

for by=1:tmby:ty
    for bx = 1:tmbx:tx
        % *************
        % * COMPLETER *
        % *************
        % Prendre un macrobloc de l'image courante qui compare avec toutes
        % les macrobloc possibles de l'image pr�c�dente -ex<x<ex -ey<y<ey
        BI=I(by:by+tmby-1,bx:bx+tmbx-1);
        % Choisir la diff�fence minimale entre des pixels des macroblocs  
        differencemin = 500;
        %Cas 1: 1�re ligne X - 1�re macrobloc [en haut - � gauche]
        if (by+tmby-1 == tmby) && (bx+tmbx-1 == tmbx)
            for dy=0:ey
                for dx=0:ex
                    BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                    fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                    % Comparer la diff�rence avec celle pr�c�dente. Si oui,
                    % prendre la minimale;si non, d�passer cette boucle
                    if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        % Stocker xpas et ypas dans le vecteur de
                        % mouvement
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                    end
                end
            end
        end
        %Cas 2: 1�re ligne X - dernier macrobloc [en haut - � droit]
        if (by+tmby-1 == tmby) && (bx+tmbx-1 == tx)
            for dy=0:ey
                for dx=-ex:0
                    BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                    fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                    if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                    end
                end
            end
        end
        %Cas 3: derni�re ligne X - 1�re macrobloc [en bas - � gauche]
        if (by+tmby-1 == ty) && (bx+tmbx-1 == tmbx)
            for dy=-ey:0
                for dx=0:ex
                    BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                    fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                    if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                    end
                end
            end
        end
        %Cas 4: derni�re ligne X - dernier macrobloc [en bas - � droit]
        if (by+tmby-1 == ty) && (bx+tmbx-1 == tx)
            for dy=-ey:0
                for dx=-ex:0
                    BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                    fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                    if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                    end
                end
            end
        end
        %Cas 5: 1�re ligne X - plusieurs colonnes sauf 1�re et dernier macroblocs 
        if (by+tmby-1 == tmby) && (bx+tmbx-1 < tx) && (bx+tmbx-1 > tmbx)
            for dy=0:ey
                for dx=-ex:ex
                     BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                     fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                     if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                     end
                end
            end
        end
        %Cas 6: Derni�re ligne X - plusieurs colonnes sauf 1�re et dernier macroblocs 
        if (by+tmby-1 == ty) && (bx+tmbx-1 < tx) && (bx+tmbx-1 > tmbx) 
            for dy=-ey:0
                for dx=-ex:ex
                     BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                     fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                     if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                     end
                end
            end
        end
        %Cas 7: 1�re colonne Y - plusieurs lignes sauf 1�re et dernier macroblocs 
        if (bx+tmbx-1 == tmbx) && (by+tmby-1 < ty) && (by+tmby-1 > tmby)
            for dy=-ey:ey
                for dx=0:ex
                     BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                     fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                     if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                     end
                end
            end
        end
        %Cas 8: derni�re colonne Y - plusieurs lignes sauf 1�re et dernier macroblocs 
        if (bx+tmbx-1 == tx) && (by+tmby-1 < ty) && (by+tmby-1 > tmby)
            for dy=-ey:ey
                for dx=-ex:0
                     BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                     fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                     if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                     end
                end
            end
        end
        %Cas 9:  plusieurs colonnes sauf 1�re et dernier macroblocs - plusieurs lignes sauf 1�re et dernier macroblocs
        if (by+tmby-1 < ty) && (by+tmby-1 > tmby) && (bx+tmbx-1 < tx) && (bx+tmbx-1 > tmbx) 
            for dy=-ey:ey
                for dx=-ex:ex
                     BIref=Iref(by+dy:by+tmby-1+dy,bx+dx:bx+tmbx-1+dx);
                     fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,somme=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,nnz(minus(BI,BIref)));
                     if (nnz(minus(BI,BIref)) < differencemin)
                        differencemin = nnz(minus(BI,BIref));
                        Vx((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx) = -dx;Vy((by+tmby-1)/tmby*tvx-tvx+(bx+tmbx-1)/tmbx)=-dy;
                        fprintf('\nI Blk y: %d---%d x:%d----%d,Movement: dy=%d dx=%d,differencemin=%d',by,by+tmby-1,bx,bx+tmbx-1,dy,dx,differencemin);
                     end
                end
            end
        end
    end
end
% Convertir un vecteur en une matrice et Mettre deux matrices dans une
% seule 
V(:,:,1)=vec2mat(Vx,30);
V(:,:,2)=vec2mat(Vy,30);

% Matrice de mouvement Vx
V(:,:,1)
% Matrice de mouvement Vy
V(:,:,2)