clear all;
close all;

Maire = 4;
nbSymb = 8;

Fd = 2000; % le débit symbole
Fe = 16000; % Fréquance d'échantillonage 
nbEchan = Fe/Fd; % Nombre d'échantillons par symbole
Td = 1/Fd; % Temps symbole
Te = 1/Fe; % Temps échantillon

T = 1; %seconde
Fp = 1/T; % nombres des pulses per seconde 

seqEng  = randi([0 Maire-1],1,nbSymb)

figure
stem(seqEng(1:nbSymb))
title(['la sequence entière pour Maire = ',num2str(Maire)])

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
title("h(t): La réponse temporelle du filtre d'émission")
grid on

figure
stem(ht)
title("h(t): La réponse temporelle du filtre d'émission")
grid on

[H f] = freqz(ht,1,[]);
figure
plot(f,abs(H))
title("h(t): La réponse fréquentielle du filtre d'émission")
grid on

seqSurechan = upsample(seqSymb,nbEchan)
figure
stem(seqSurechan(1:nbSymb*nbEchan))
title("Suréchantillonager la séquance symbole")
grid on

se = filter(h,1,seqSurechan)
figure
plot(se(1:nbSymb*nbEchan),"r")
title("se le signal émis obtenu en sortie du filtre d'émission")
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



