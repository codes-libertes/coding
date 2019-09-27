clear all;
close all;

Maire = 4;
nbSymb = 8;

Fd = 2000; % le d�bit symbole
Fe = 16000; % Fr�quance d'�chantillonage 
nbEchan = Fe/Fd; % Nombre d'�chantillons par symbole
Td = 1/Fd; % Temps symbole
Te = 1/Fe; % Temps �chantillon

T = 1; %seconde
Fp = 1/T; % nombres des pulses per seconde 

seqEng  = randi([0 Maire-1],1,nbSymb)

figure
stem(seqEng(1:nbSymb))
title(['la sequence enti�re pour Maire = ',num2str(Maire)])

seqSymb = pammod(seqEng,Maire)
figure
stem(seqSymb(1:nbSymb))
title(['la sequence symbole pour Maire = ',num2str(Maire)])

scatterplot(seqSymb)
title(['la constellation pour Maire = ',num2str(Maire)])
grid on

h = ones(1,nbEchan)
ht = [h zeros(1,nbEchan)];
figure
plot(ht,"r")
title("h(t): La r�ponse temporelle du filtre d'�mission")
grid on

figure
stem(ht)
title("h(t): La r�ponse temporelle du filtre d'�mission")
grid on

[H f] = freqz(ht,1,[]);
figure
plot(f,abs(H))
title("h(t): La r�ponse fr�quentielle du filtre d'�mission")
grid on

seqSurechan = upsample(seqSymb,nbEchan)
figure
stem(seqSurechan(1:nbSymb*nbEchan))
title("Sur�chantillonager la s�quance symbole")
grid on

se = filter(h,1,seqSurechan)
figure
plot(se(1:nbSymb*nbEchan),"r")
title("se le signal �mis obtenu en sortie du filtre d'�mission")
grid on

DSPse = pwelch(se)
figure
plot(DSPse,"r")
title("DSP de se(t)")
grid on

ps = sum(abs(se.^2))/length(se)

x = -pi:0.01:pi
figure
%plot(x,(2.^0.5)*sin(x))
stem(x,(2.^0.5)*sin(x))
grid on



