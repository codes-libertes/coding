clear all;
close all;
% Modulation 4QAM-Maire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Paramètres généraux 
Maire = 4;                      % QAM
nbSymb = 8;                     % Nombre des symboles
Fd = 2000;                      % Débit symbole
Fe = 16000;                     % Fréquance d'échantillonage 
nbEchan = Fe/Fd;                % Nombre d'échantillons par symbole
totalNbEchan = nbSymb*nbEchan;  % Nombre d'échantillons totaux
Td = 1/Fd;                      % Temps symbole
Te = 1/Fe;                      % Temps échantillon
Mmem = 3;                       % Mémoire pour la séquence PN
L = 2^(Mmem)-1;                 % Longueur pour la séquence PN
Tc = Td/L;                      % Période chip étalement
Fp = 1/nbEchan;                 % Fréquence échantillon
Tp = 1/Fp;                      % Période échantillon
RSBdb = 30;                     % SNR positif 
RSBdbneg = -20;                 % SNR négatif
fp = Fe/16;                     % Fréquence pour la porteuse 

seqEng  = randi([0 Maire-1],1,nbSymb);
bits_envoyes = de2bi(seqEng)

seqSymb = pammod(seqEng,Maire)
figure
stem(seqSymb(1:nbSymb))
title(['la sequence symbole pour Maire = ',num2str(Maire)])

scatterplot(seqSymb)
title(['la constellation pour Maire = ',num2str(Maire)])
grid on

% Partie 2
% Générer la séquence pseudo-aléatoire PN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:L
   Cn(i) = 1;
end
for i=Mmem+1:L
    Cn(i)=xor(Cn(i-2),Cn(i-3));
end
Cn(Cn==0) = -1

figure
stem(Cn(1:L))
title(['la sequence pseudo aléatoire pour longueur = ',num2str(L)])

% Partie 3
% Sur échantillonner les symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k=1;
seqSurechan=zeros(1,totalNbEchan);
for i=1:nbSymb
   for j=1:nbEchan
       seqSurechan(k)=seqSymb(i);
       k=k+1;
   end
end

figure
stem(seqSurechan(1:totalNbEchan))
title('Suréchantillonager la séquance symbole')
grid on

% Partie 4
% Générer la séquence aléatoire avec la meme taile Suréchantillons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(seqSurechan)
    if (i<=L)
        Cns(i) = Cn(i);
    elseif (mod(i,L) == 0)
        Cns(i) = Cn(L);
    else
        Cns(i) = Cn(mod(i,L));
    end
end

figure
stem(Cns,'r')
title(['la sequence pseudo aléatoire pour longueur = ',num2str(length(seqSurechan))])

% Partie 5
% Réaliser l'étalement par séquence directe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(seqSurechan)
    sEtale(i)=seqSurechan(i).*Cns(i);
end

figure
subplot(3,1,1)
stem(sEtale,"r")
title('le singal étalé par séquence directe ')
grid on

hold on
subplot(3,1,2)
stem(Cns,'r')
title(['la sequence pseudo aléatoire pour longueur = ',num2str(length(seqSurechan))])

hold on
subplot(3,1,3)
stem(seqSurechan(1:totalNbEchan))
title('Suréchantillonager la séquance symbole')
grid on

% Partie 6
% Générer la porteuse sinus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = ones(1,1)
se = filter(h,1,sEtale)
figure
stem(se,"r")
title('se le signal émis obtenu en sortie du filtre de émission avec étalement')
grid on

N=length(se)
t=[0:(N-1)]*Te
a=sqrt(2)
porteuse=a*cos(2*pi*fp*t)

% Partie 7
% Mettre le signal sur la porteuse 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smod=se.*porteuse;

figure
plot(smod,"r")
title('se le signal émis obtenu en sortie du filtre de émission avec le étalement + Porteusee')
grid on

figure
subplot(2,1,1)
plot(smod,"r")
title('se le signal émis obtenu en sortie du filtre de émission avec le étalement + Porteuse')
grid on

hold on
subplot(2,1,2)
stem(se,"r")
title('se le signal émis obtenu en sortie du filtre de émission avec le étalement')
grid on

% Partie 8
% Calculer le bruit et afficher les densités spectraux 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ps = sum(abs(smod.^2))/length(smod)

pb = ps*10^-(RSBdb/10)
bc=sqrt((pb/2)*(Fe/Fd))*(randn(1,length(smod)).*porteuse);

pbneg = ps*10^-(RSBdbneg/10)
bcneg=sqrt((pbneg/2)*(Fe/Fd))*(randn(1,length(smod)).*porteuse);

[pse,fse] = pwelch(se,[],[],[],Fe,'centered','power');
sne = filter(h,1,seqSurechan);
[psne,fsne] = pwelch(sne,[],[],[],Fe,'centered','power');
[psmod,fsmod] = pwelch(smod,[],[],[],Fe,'centered','power');

figure
plot(fsmod,pow2db(psmod),'g')
hold on
plot(fse,pow2db(pse),'r')
hold on
plot(fsne,pow2db(psne),'b')
legend('signaux modulés étalés','signaux n-modulés y-étalés','signaux n-modulés n-étalés')
xlabel('Frequency (Hz)')
ylabel('Puissance (dB)')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Récepteur via le canal 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = smod + bc
xneg = smod + bcneg
figure
subplot(2,1,1)
plot(smod(1:totalNbEchan),"b")
hold on
plot(x(1:totalNbEchan),"r")
legend('Sans bruit','Avec bruit')
title(['x(t) le signal reçu en sortie du canal RSBdb = ',num2str(RSBdb)])
grid on

hold on
subplot(2,1,2)
plot(smod(1:totalNbEchan),"b")
hold on
plot(xneg(1:totalNbEchan),"r")
legend('Sans bruit','Avec bruit')
title(['x(t) le signal reçu en sortie du canal RSBdb = ',num2str(RSBdbneg)])
grid on

% Partie 9
% Démoduler le signal par la porteuse 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xdem=x.*porteuse 

figure
plot(xdem,"r")
title('y(t) le signal démodulé par la porteuse avant le filtre de réception ')
grid on

g = h/2

y = filter(g,1,xdem)
figure
plot(y,"r")
title('y(t) le signal démodulé en sortie du filtre de réception ')
grid on

% Partie 10
% Corrélater le signal par séquence directe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:(length(seqSurechan))
    sdeetale(i)=y(i).*Cns(i)
end

figure 
subplot(3,1,1)
plot(sdeetale,"r")
hold on
plot(seqSurechan,"b")
grid on
legend('Signaux déétalés (récepteur)','Signaux déétalés (émetteur)')
title(['le signal après le corrélateur basé sur Nbréchantillons/porteuse = ',num2str(Fe/fp)])

% eyediagram(sdeetale,2*nbEchan,nbEchan)
% grid on

k=1;
for i=1:nbSymb
       seqDeechan(k)=2*sdeetale(i*nbEchan);
       k=k+1;
end

seqEngEsti = pamdemod(seqDeechan,Maire)
seqSymbEsti = pammod(seqEngEsti,Maire)
bits_recus = de2bi(seqEngEsti)
hold on
subplot(3,1,2)
stem(real(seqSymbEsti),"r")
legend('Symboles reçues')
hold on
subplot(3,1,3)
stem(real(seqSymb),"b")
legend('Symboles envoyées')
title(['la sequence symbole après la prise de décision RSBdb = ',num2str(RSBdb)])

% Partie 11
% Analiser les performances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TES = symerr(seqSymb,seqSymbEsti)
TEB = biterr(bits_envoyes,bits_recus)