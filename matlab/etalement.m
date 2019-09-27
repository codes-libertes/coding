clear all;
close all;
% Modulation 4QAM-Maire
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Param�tres g�n�raux 
Maire = 4;                      % QAM
nbSymb = 8;                     % Nombre des symboles
Fd = 2000;                      % D�bit symbole
Fe = 16000;                     % Fr�quance d'�chantillonage 
nbEchan = Fe/Fd;                % Nombre d'�chantillons par symbole
totalNbEchan = nbSymb*nbEchan;  % Nombre d'�chantillons totaux
Td = 1/Fd;                      % Temps symbole
Te = 1/Fe;                      % Temps �chantillon
Mmem = 3;                       % M�moire pour la s�quence PN
L = 2^(Mmem)-1;                 % Longueur pour la s�quence PN
Tc = Td/L;                      % P�riode chip �talement
Fp = 1/nbEchan;                 % Fr�quence �chantillon
Tp = 1/Fp;                      % P�riode �chantillon
RSBdb = 30;                     % SNR positif 
RSBdbneg = -20;                 % SNR n�gatif
fp = Fe/16;                     % Fr�quence pour la porteuse 

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
% G�n�rer la s�quence pseudo-al�atoire PN
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
title(['la sequence pseudo al�atoire pour longueur = ',num2str(L)])

% Partie 3
% Sur �chantillonner les symboles
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
title('Sur�chantillonager la s�quance symbole')
grid on

% Partie 4
% G�n�rer la s�quence al�atoire avec la meme taile Sur�chantillons
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
title(['la sequence pseudo al�atoire pour longueur = ',num2str(length(seqSurechan))])

% Partie 5
% R�aliser l'�talement par s�quence directe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(seqSurechan)
    sEtale(i)=seqSurechan(i).*Cns(i);
end

figure
subplot(3,1,1)
stem(sEtale,"r")
title('le singal �tal� par s�quence directe ')
grid on

hold on
subplot(3,1,2)
stem(Cns,'r')
title(['la sequence pseudo al�atoire pour longueur = ',num2str(length(seqSurechan))])

hold on
subplot(3,1,3)
stem(seqSurechan(1:totalNbEchan))
title('Sur�chantillonager la s�quance symbole')
grid on

% Partie 6
% G�n�rer la porteuse sinus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = ones(1,1)
se = filter(h,1,sEtale)
figure
stem(se,"r")
title('se le signal �mis obtenu en sortie du filtre de �mission avec �talement')
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
title('se le signal �mis obtenu en sortie du filtre de �mission avec le �talement + Porteusee')
grid on

figure
subplot(2,1,1)
plot(smod,"r")
title('se le signal �mis obtenu en sortie du filtre de �mission avec le �talement + Porteuse')
grid on

hold on
subplot(2,1,2)
stem(se,"r")
title('se le signal �mis obtenu en sortie du filtre de �mission avec le �talement')
grid on

% Partie 8
% Calculer le bruit et afficher les densit�s spectraux 
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
legend('signaux modul�s �tal�s','signaux n-modul�s y-�tal�s','signaux n-modul�s n-�tal�s')
xlabel('Frequency (Hz)')
ylabel('Puissance (dB)')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R�cepteur via le canal 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = smod + bc
xneg = smod + bcneg
figure
subplot(2,1,1)
plot(smod(1:totalNbEchan),"b")
hold on
plot(x(1:totalNbEchan),"r")
legend('Sans bruit','Avec bruit')
title(['x(t) le signal re�u en sortie du canal RSBdb = ',num2str(RSBdb)])
grid on

hold on
subplot(2,1,2)
plot(smod(1:totalNbEchan),"b")
hold on
plot(xneg(1:totalNbEchan),"r")
legend('Sans bruit','Avec bruit')
title(['x(t) le signal re�u en sortie du canal RSBdb = ',num2str(RSBdbneg)])
grid on

% Partie 9
% D�moduler le signal par la porteuse 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xdem=x.*porteuse 

figure
plot(xdem,"r")
title('y(t) le signal d�modul� par la porteuse avant le filtre de r�ception ')
grid on

g = h/2

y = filter(g,1,xdem)
figure
plot(y,"r")
title('y(t) le signal d�modul� en sortie du filtre de r�ception ')
grid on

% Partie 10
% Corr�later le signal par s�quence directe
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
legend('Signaux d��tal�s (r�cepteur)','Signaux d��tal�s (�metteur)')
title(['le signal apr�s le corr�lateur bas� sur Nbr�chantillons/porteuse = ',num2str(Fe/fp)])

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
legend('Symboles re�ues')
hold on
subplot(3,1,3)
stem(real(seqSymb),"b")
legend('Symboles envoy�es')
title(['la sequence symbole apr�s la prise de d�cision RSBdb = ',num2str(RSBdb)])

% Partie 11
% Analiser les performances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TES = symerr(seqSymb,seqSymbEsti)
TEB = biterr(bits_envoyes,bits_recus)