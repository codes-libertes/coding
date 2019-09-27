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
marge = 25;
ind_freq= [2:27 39:64];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal original
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load signal2_0.mat;
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

moyenneCFO = mean(dopplerEffet(debut_preambleB_estime+marge:debut_preambleB_estime+Taille_preambleB-marge));

for k =0:length(xg_tot)-1
    phi(k+1) = exp(j*2*pi*moyenneCFO*k/N);
end

phi = phi.';
signal_comp = xg_tot.*phi;

figure,
plot(abs(dopplerEffet)),hold on;

axeY=get(gca,'YLim');
Ymax=axeY(2); 
stem([debut_preambleB_estime+marge debut_preambleB_estime+Taille_preambleB-marge],[Ymax Ymax],'r+');
title('Estimation du CFO');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimation du “fine” TOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1;
spb = [ 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 1+j 0 0 0 0 1+j 0 0 0 -1-j 0 0 0 1+j 0 0 0 -1-j 0 0 0 -1-j 0 0 0 1+j 0 0 0]; % sous porteuse de B
vecteur_de_zero_B= zeros(1,64);
vecteur_de_zero_B(ind_freq) = spb;   
B = ifft(vecteur_de_zero_B);        
B_prime = B(33:64);  
B_prime = B_prime.';

for a = 1:5000
    R(i) = sum(signal_comp(a:a+15).*conj(B_prime(1:16)));
    i = i+1;   
end

% Déterminer le début du préambule B par cet algorithme
seuil = 0.9*max(abs(R(debut_preambleB_estime-marge:debut_preambleB_estime+marge)));
for i = debut_preambleB_estime:debut_preambleB_estime+marge
    if(abs(R(i)) >= seuil)
            debut_preambleB = i;                
       break;
    end 
end

debut_preambleB = debut_preambleB-5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation du Coefficients et egalisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spc = [1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1];
Kc=1;

vecteur_de_zeros = zeros(1,64); 
vecteur_de_zeros(ind_freq) = spc;  
vecteur_de_zeros = ifft(vecteur_de_zeros);  

debut_preambule_c = debut_preambleB+Taille_preambleB;
preambule_c_recu = signal_comp(debut_preambule_c:debut_preambule_c+Taille_preambleC-1);
preambule_c_recu = preambule_c_recu(33:Taille_preambleC); 

preambule_c_recu_64_first = fft(preambule_c_recu(1:64));  
preambule_c_recu_64_last = fft(preambule_c_recu(65:128));     

moyenne_de_c = (preambule_c_recu_64_first + preambule_c_recu_64_last)/2;
remise_a_zeros = moyenne_de_c(ind_freq);

figure,
stem(abs(preambule_c_recu_64_first),'b*-')
hold on
stem(abs(preambule_c_recu_64_last),'r-')
title('les preambules C1 et C2')

Coefficients = remise_a_zeros./(spc*Kc).';

figure,
stem(abs(moyenne_de_c),'g')
title('Coefficients signal2.0.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Démoduler les données OFDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debut_ofdm = debut_preambleB+Taille_preambleC+Taille_preambleB;
trame = (length(signal_comp)-debut_preambleB-Taille_preambleC-Taille_preambleB+1)/etape;
for i=1:trame
    vecteur_zero = zeros(1,etape);                 
    vecteur_zero = signal_comp(debut_ofdm+etape*(i-1):debut_ofdm-1+etape*i); 
    vecteur_init(1:N)=vecteur_zero(Ng+1:etape);         
    vecteur_init = fft(vecteur_init);              
    Matsymb(1+Nu*(i-1):Nu*i)= vecteur_init(ind_freq)./Coefficients.';  
end

figure
plot(Matsymb.','.'),axis('square')  
title(['Constellation avec M = ', num2str(M)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Traiter OFDM symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
donneeDecimale = dpskdemod(Matsymb,M);     
donneeBinaire = decimal2binaire(donneeDecimale);
decodeBinaire = donneeBinaire;
descrambleDonnee = descrambler(decodeBinaire); 
data = binaire2octet(descrambleDonnee); 

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
figure
imshow(A),title('image mystere du signal2.0.mat ');
