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
etape = Ng+N;              % Taille de chaque morceau de OFDM
ind_info = [2:27 39:64];   % Les indices des sous-pouteuses actives
Taille_preambleC = 160;
Taille_preambleB = Taille_preambleC;
marge = 60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load signal2_1.mat;
pwelch(xg_tot,256,[],[],Fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du “coarse” TOD, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
for k = 1:5000
    rb(i) = sum(xg_tot(k:k+15).*conj(xg_tot(k+16:k+31)));  
    i = i+1;   
end

figure;
plot(abs(rb));
title('Estimation grossiere TDO'); 

i=1; 
for k = 1:5000-144
        moyenne(i) = sum(rb(k:k+144)); 
        i=i+1;
end
figure;
plot(abs(moyenne)); 
title('Moyenne glissante TDO ');

[valeurMax debut_preambleB_estime] = max(abs(moyenne)); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du CFO puis compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dopplerEffet = (4/(2*pi))*angle(rb);
moyenneCFO = mean (dopplerEffet(debut_preambleB_estime + marge : debut_preambleB_estime + marge + 120 - marge));
moyenneCFO = 0;
for k = 1 : length(xg_tot)
    xg_tot(k) = xg_tot(k)*exp(j*2*pi*moyenneCFO*((k-1)/N));
end

figure,
plot(abs(dopplerEffet)),
hold on
plot([debut_preambleB_estime + marge debut_preambleB_estime + marge], [0 500], 'r')
title('Estimation du CFO');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du “fine” TOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
spb = [ 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 0 1+j 0 0 0 -1-j 0 0 0 1+j 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0]; % sous porteuse de B
vecteur_de_zero_B= zeros(1,64);
vecteur_de_zero_B(ind_info) = spb;   
B = ifft(vecteur_de_zero_B);        
B_prime = B(33:64);  
B_prime = B_prime.';

for k = 1 : 5000
    rbs3(i)= sum(xg_tot(k : k + 15) .* conj(B_prime(1 : 16))); 
    i = i+1; 
end

rbs3 = abs(rbs3);
for i =1 : 4500
  rf(i)= rbs3(i) + rbs3(i + 16) + rbs3(i + (16  *2)) + rbs3(i + (16 * 3)) + rbs3(i + (16 * 4)) + rbs3(i + (16 * 5)) + rbs3(i + (16 * 6)) + rbs3(i + (16 * 7)) + rbs3(i + (16 * 8)) + rbs3(i + (16 * 9)) + rbs3(i + (16 * 10)) + rbs3(i + (16 * 11));
end

% Déterminer le début du préambule B par cet algorithme
seuil = 0.9 * max(abs(rbs3));
[valeurMax_rf debut_preambleB] = max(rf);  

for k = debut_preambleB_estime - marge : debut_preambleB_estime + marge
    if(abs(rbs3(k)) >= seuil)
        debut_preambleB = k;                
     break;
    end
end

debut_preambleB = debut_preambleB - 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation du Coefficients et egalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ps = sum(abs(xg_tot).^2 / length(xg_tot));
% P_preambule = Nu / (N^2);      
% Kc = sqrt(Ps/P_preambule);                
spc = [1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1];
Kc=1;
veteur_zeros = zeros(N, 1);
veteur_zeros(ind_info) = spc;

preambule_C1 = xg_tot(debut_preambleB + Taille_preambleB + 32 : debut_preambleB + Taille_preambleB + 32 + 63);
preambule_C2 = xg_tot(debut_preambleB + Taille_preambleB + 32 + 64 : debut_preambleB + Taille_preambleB + 32 + 64 + 63);

preambule_c_recu_64_first = fft(preambule_C1);
preambule_c_recu_64_last = fft(preambule_C2);

Cn1 = preambule_c_recu_64_first./veteur_zeros;
Cn2 = preambule_c_recu_64_last./veteur_zeros;
Coefficients = (Cn1+Cn2)./2;

figure,
stem(abs(Cn1),'b*-')
hold on
stem(abs(Cn2),'r-')
title('les preambules C1 et C2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Démoduler les données OFDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debut_ofdm = debut_preambleB + Taille_preambleC + Taille_preambleB;
donnee = xg_tot(debut_preambleB +Taille_preambleC + Taille_preambleB : end);
trameSize = fix(length(donnee) ./ (etape));

phi0 =9*pi/180;
phi_cum=0;
phi_cum_est=0;
ordre = 4 ;
for k = 1:trameSize
    vecteur_zero = zeros(1,etape); 
    vecteur_zero = donnee(1 + etape * (k - 1) : etape * k);
    symb(1 : N) = vecteur_zero(Ng+1 : etape);    
    symb = fft(symb); 
    symb=symb./(Coefficients);
    
    n=.05*(randn(1,P)+1i*randn(1,P));
    phi_cum=phi_cum+phi0;
    x=symb(ind_info)*exp(j*phi_cum)+n;
    
    y=x.*exp(-j*phi_cum_est);
    phi0_est=angle(mean(y .^ ordre)) / ordre;
    Modsymb(:,k) =y.*exp(-j*phi0_est);
    phi_cum_est=phi_cum_est+phi0_est;
    
    figure(100)
    hold on
    plot(1/2*Modsymb(:,k),'.')
    axis('equal')
    pause(0.003)
    
    Phi_cum_est(k)=phi_cum_est;
    Phi_cum(k) = phi_cum;
end 
grid
Modsymb = Modsymb .* exp(-j * pi / ordre); 
figure
plot(Modsymb.','.'),axis('square')  
title(['Constellation avec M = ', num2str(M)]);

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traiter OFDM symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
donneeDecimale = qamdemod(Modsymb,M);     
donneeBinaire = decimal2binaire(donneeDecimale);
decodeBinaire = donneeBinaire;
descrambleDonnee = descrambler(decodeBinaire); 
data = binaire2octet(descrambleDonnee); 

emplacement_sync=[240;240;240;240;240;240];
% détection du pattern sync
for m=1:length(data)
   if data(m+0:m+5) == emplacement_sync
       % décaler 10 octets pour les 2 zones(sync+size) 
       debut_preambleB=m+10;
       break;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extraire image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Récupérer 4 octets avant les données d'image
taille_image_octet = data(debut_preambleB-4:debut_preambleB-1);
taille_image_int = octet2int(taille_image_octet);
dataImg=data(debut_preambleB:taille_image_int+debut_preambleB);

fd = fopen('image.jpg', 'wb');
fwrite(fd, dataImg, 'uint8'); 
A = imread('image.jpg');
figure
imshow(A),title('image mystere du signal2.1.mat ');
