close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Paramètres généraux 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chanel Bandwidth: 1.2MHz
N=128;      % taille de FFT
Ch=1;       % Choix canal LTE dans [1:5] <=> [1.2 3 5 10 15 20] Mhz 
Ng=32;      % nombre de Cp
Fs=15000*N; %Fréquence d'eChantillonage
Slot=20;
Cp=6;       % Chaque slot contient 6 CP LONG
conf_cp = 1;% conf_cp : choix config CP dans [1:3]
            %           1 : long
            %           2 : short premier symbol
            %           3 : short second  symbol
P=73
Nu=P-1;
Maire=4;    % Taille de la constellation QAM   
MatSym=zeros(N+Ng,Cp*Slot);

rng(0) % initialiser la graine de générateuraleatoire pour générer les meme symbole

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Générer une frame OFDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:Slot*Cp
    seq_ent=randsrc(1,Nu,[0:Maire-1]);% générer les entiers
    symb=qammod(seq_ent,Maire);% generer les symboles
    e=zeros(1,N);% mettre toute la séquence a 0
    a=[2:Nu/2+1]; % on commence par la deuxième entrée pour un f=1/N. la première est une composante continu [36 entrée= intervale 1]
    b=[N-Nu/2+1:N];% intervale 2
    ind_freq=[a b]; %indice fréq
    e(ind_freq)=symb; % mettre les symbole a nos indices  
    s=ifft(e); % transformée dde fourier de notre signal
    %--aprés avoir calculer le nombre de Cp on a trouvé 32 o va les rajouté a la séquence  128 et le total sera 160 ---%
    c=s(N-Ng+1:N);% prendre les 32Cp                                                                                                                              
    s2=horzcat(c,s); % mettre les 32Cp puis la séquence =>160
    MatSym(:,j) =s2;
end
slot = MatSym(:).';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ajuster la pussance à -10dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=-10 %puissance PFDM EN dBm
Ps=sum(abs(slot).^2)/length(slot)%calcul de puissance
fprintf('vérif : %1.2f\n',10*log10(Ps))
kdB= (p-30)-10*log10(Ps) %calcul le A pour une puissance de -10 dbm
A=10^(kdB/20)

r=A*slot;   % signal aprés l'application de A 

%--verif
Pr=sum(abs(r).^2)/length(r);%calcul de puissance
fprintf('vérif : %1.2f\n',10*log10(Pr))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vérifier le signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
verif_lte_frame(r,Ch,2,Maire,p-30)% verifier si notre signal est OK ou pas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimer la DSP du signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dsp f] = pwelch(real(r),[],[],[],Fs);
figure,
plot(f,10*log10(dsp));
title('Spectre ');
xlabel('Frequence en Hz');
ylabel('DSP en db');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ajouter l'atténuation K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Kdb= -60;
Pbdb = -130;
K = 10^(-60/20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ajouter le bruit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ps=sum(abs(r.^2))/length(r)
Pb = 10^(Pbdb/10);
sigma= sqrt(Pb/2);               % l'ecart type du bruit
bc = sigma *(randn(1,length(r))+1i*randn(1,length(r))); % génération du bruit AWGN

Pse = pwelch(bc); % DSP du bruit

xt = K*r + bc;
Px=sum(abs(xt.^2))/length(xt)
fprintf('vérif : %1.2f\n',10*log10(Px))
RSBx=20*log10(K) + 10*log10(Ps)-10*log10(Pb)
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Démoduler une frame OFDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(0) % initialiser la graine de générateur aleatoire pour générer les memes symboles
y = zeros(Nu,N);
symb = zeros(Nu,N);
for j = 1:Slot*Cp
      s = xt;
      s_sansprefixe = [s(Ng+1:N+Ng)];
      e = fft(s_sansprefixe);
      y(:,j) = [e(2:Nu/2+1)  e(N-Nu/2+1:N)].';
      symb(:,j) = qamdemod(y(:,j),Maire);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Afficher la constellation pour les symboles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scatterplot(y(:));
title('constellation recue pour les symbole ');

[Num,Rat] = biterr(seq_ent,symb.');% determiner le nombre de bits erronés

