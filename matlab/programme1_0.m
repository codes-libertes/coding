close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Paramètres généraux 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 20000;               %  Fréquence d'échantillons
M=4;                      %  Modulation
N=64;                     %  OFDM paramètres
P=52;
Nu=P;
Ng=16;
ind_info = [2:27 39:64];  % les indices des sous-pouteuses actives
Taille_preambleC = 160;
Taille_preambleB = Taille_preambleC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%debut_preambleB =766%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load signal1_0.mat;
pwelch(xg_tot,256,[],[],Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du “coarse” TOD, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 1;
for k=1:3000
    rb(k) = sum(real(xg_tot(n:15+n).*conj(xg_tot(n+16:31+n))));
    n= n+1;
end
figure,
plot(abs(rb)),title('Préambule B#');

rb_reel = real(rb);
for k=1:3000-130
    moyenne(k+1) = mean(real(rb((1+k):(130+k))));
end
figure,
plot(moyenne),title('La moyenne des parties de Rb');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Préambule B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vecteur_de_zeros=zeros(N,1);
spb=[0,0,0,-1-j,0,0,0,-1-j,0,0,0,+1+j,0,0,0,+1+j,0,0,0,+1+j,0,0,0,+1+j,0,0,0,0,+1+j,0,0,0,-1-j,0,0,0,+1+j,0,0,0,-1-j,0,0,0,-1-j,0,0,0,+1+j,0,0,0];
vecteur_de_zeros(ind_info)=spb; 

preambule_b=ifft(vecteur_de_zeros); 
b_prime=preambule_b(33:64); 
preambule_b=[b_prime;preambule_b;preambule_b];
sn=preambule_b(1:16);

figure,
plot(abs(preambule_b),'r'),title('Préambule B#');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du “fine” TOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 1;
for k=1:3000
    rbs(k)=sum(xg_tot(n:15+n).*conj(sn));
    n= n+1;
end
figure,
plot(abs(rbs),'r'),title('Estimation du fine TDO');

ind=find(abs(rbs)>0.9*max(abs(rbs)));
debut_preambleB=ind(1); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Préambule C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ps=sum(abs(xg_tot).^2)/length(xg_tot);
Kc=sqrt(ps/(Nu*N^2));

spc=[1,-1,-1,1,1,-1,1,-1,1,-1,-1,-1,-1,-1,1,1,-1,-1,1,-1,1,-1,1,1,1,1,1,1,-1,-1,1,1,-1,1,-1,1,1,1,1,1,1,-1,-1,1,1,-1,1,-1,1,1,1,1];
spc=spc.';

preambule_c = xg_tot(debut_preambleB+Taille_preambleB:debut_preambleB+2*Taille_preambleB-1);
figure,
plot(real(preambule_c)),title('le preambule #C');

preambule_c_pre_64=preambule_c(33:96); 
preambule_c_pre_64=fft(preambule_c_pre_64);
spc_recu1=preambule_c_pre_64(ind_info);

preambule_c_apres_64=preambule_c(97:Taille_preambleC); 
preambule_c_apres_64=fft(preambule_c_apres_64);
spc_recu2=preambule_c_apres_64(ind_info);

Cn1=spc_recu1./(spc*Kc); 
Cn2=spc_recu2./(spc*Kc);
Coefficients=(Cn1+Cn2)/2;

figure
plot(20*log(abs(Coefficients)));
title('Estimation des coefficients du canal ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Démoduler les données OFDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xt=xg_tot(debut_preambleB+Taille_preambleB*2:end);
%Couper chaque morceau de la taille (80) = (16) Cyclic préfixe + (64) OFDM symboles
morceau = Ng+N;
nb=length(xt)/morceau;
nb = fix(nb)
morceau_decalage = 0;
Matsymb=zeros(Nu,nb);

for k=1:nb
     x= xt(morceau_decalage+1:k*morceau);
     %on enlève le préfixe cyclique de taille 16
     symb=x(Ng+1:morceau);
     %à la sortie de FFT on obtient les 52 
     symb=fft(symb);
     % on enleve les zeros 
     symb=symb(ind_info);
     symb=symb./(Coefficients);
     Matsymb(:,k)=symb;
     morceau_decalage = k*morceau;
end

figure,
plot(real(Matsymb),imag(Matsymb),'+');
title(['Constellation de Réception M = ',num2str(M)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traiter OFDM symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sym_recu=reshape(Matsymb,1,Nu*nb); 
sym_recu=qamdemod(sym_recu,M); 

bit_recu=decimal2binaire(sym_recu);
bit_recu_en_ordre=descrambler(bit_recu); 
bit_recu_en_ordre=binaire2octet(bit_recu_en_ordre); 
data=Maire2octet(bit_recu_en_ordre);

emplacement_sync=[240;240;240;240;240;240];
% détection du pattern sync
for m=1:length(data)
   if data(m+0:m+5) == emplacement_sync
       % décaler 10 octets pour les 2 zones(sync+size) 
       debut_data=m+10;     
       break;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraire image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Récupérer 4 octets avant les données d'image
taille_image_octet = data(debut_data-4:debut_data-1);
taille_image_int = octet2int(taille_image_octet);
dataImg=data(debut_data:taille_image_int+debut_data);

fd = fopen('image.jpg', 'wb');
fwrite(fd, dataImg, 'uint8'); 
A = imread('image.jpg');
imshow(A),title('image mystere du signal1.0.mat');
