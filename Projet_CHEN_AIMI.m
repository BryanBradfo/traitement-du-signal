clear;
close all;
clc;
load('donnees1.mat');
load('donnees2.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%3.2.1.1 et définition de toutes nos variables%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fe = 120*10^(3);                        %en Hz et fréquence d'échantillonnage
Te = 1/fe;
T = 40*10^(-3);                         %en secondes
Nbr_bits=length(bits_utilisateur1);
Ts=T/Nbr_bits;
Ns = Ts/Te;
Ordre=61;                               %(Rq : ordre doit être impair)
N=Nbr_bits*Ns;                          %Nombre de points par trame 
Nbr_Slot=5;                             %Nombre de slots
Nbr_total_point=Nbr_Slot*N;
te = Te : Te : Nbr_bits*Ts;             %échelle de temps

%%%%%%%%%%%
%%3.2.1.2%%
%%%%%%%%%%%

%%% message 1

m1=bits_utilisateur1 ;
m1_t = kron(m1, ones(1,Ns));
s1 = (2*m1_t-1);                        %permet d'avoir le message m1 (qui était en bits) avec des +1 -1

%%% message 2

m2=bits_utilisateur2;
m2_t = kron(m2, ones(1,Ns));
s2 = (2*m2_t-1);                        %permet d'avoir le message m2 (qui était en bits) avec des +1 -1

%%%%%%%%%%%
%%3.2.1.3%%
%%%%%%%%%%%

%% DSP des signaux m1 et m2 %%

Zp=2^(nextpow2(length(s1)));
f0= 0 : fe/(Zp-1) : fe;
S1=fft(s1,Zp);                          %TF du message s1
S2=fft(s2,Zp);                          %TF du message s2

%%% Affichage 3.2.1%%%
figure,
    subplot(2,2,1)
    plot(te,s1)
    title("Représentation du message 1 en échelle temporelle");
    xlabel("Temps (s)");
    ylabel("Amplitude");
    subplot(2,2,2)
    plot(te,s2)
    title("Représentation du message 2 en échelle temporelle");
    xlabel("Temps (s)");
    ylabel("Amplitude");
    subplot(2,2,3)
    %semilogy(f0, abs(S1))
    semilogy(f0, abs(S1).^2)

    %title("Représentation du message 1 en echelle fréquentielle");
    title("DSP du message 1 en échelle fréquentielle");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");
    subplot(2,2,4)
    %semilogy(f0, abs(S2))
    semilogy(f0, abs(S2).^2)
    %title("Représentation du message 2 en echelle fréquentielle");
    title("DSP du message 2 en échelle fréquentielle");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");

%%%%%%%%%%%
%%3.2.2.1%%
%%%%%%%%%%%

%% Modulation des signaux à l'aide de cosinus %%
ts = Te : Te : 2400*Ts;                 %échelle de temps adapté au nombre de point
fp2=46*10^3;                            %fréquence porteuse 2
x1 = kron ([0 1 0 0 0], s1 );           %message x1 sur le deuxième slot dans un paquet de 5slots
x1t=x1;                                 %fp1 est égal à 0 donc le cosinus n'a aucune influence sur ce message (modulé)
x2 = kron ([0 0 0 0 1], s2 );           %message x1 sur le deuxième slot dans un paquet de 5slots
x2t=x2.*cos(2*pi*fp2*ts);               %x2*cosinus avec la fréquence porteuse fp2 (modulé)
X=x1t+x2t;                              %la somme des deux

figure,
    plot(ts,X)
    title("Représentation du signal comportant les 5 slots");
    xlabel("Temps (s)");
    ylabel("Amplitude");


%%%%%%%%%%%
%%3.2.2.2%%
%%%%%%%%%%%

%% Ajout du bruit gaussien au signal %%
Px=1;                                   %On considère la puisance du signal à 1 (x=x1+x2)
SNR=100;                                %en dB
Pn=Px*10^(-SNR/10);                     %Puissance du signal gaussien

Bruit=Pn*randn(1,Nbr_total_point);
XB=X+Bruit;
figure,
    plot(ts,XB)
    title("Représentation du signal avec le bruit gaussien");
    xlabel("Temps (s)");
    ylabel("Amplitude");

%%%%%%%%%%%
%%3.2.2.3%%
%%%%%%%%%%%

%% DSP du signal MF-TDMA avec le bruit %%
Zp=2^(nextpow2(length(XB)));            %Zéro Padding
f=linspace(-fe/2,fe/2,Zp);              %Création de l'échelle fréquentielle
XX=abs(fft(XB,Zp)).^2;                  %Création de la DSP du signal MF-TDMA avec bruit

figure,
    semilogy(f, XX);
    title("Représentation de la DSP de MF-TDMA");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");
    
%%%%%%%%%%%
%%4.1.1.1%%
%%%%%%%%%%%

fc = 23000;                                         %(fp1+fp2)/2
fcb = fc/fe;
hpb = 2*fcb*sinc(2*fcb*[-(Ordre-1)/2:(Ordre-1)/2]); %réponse impulsionnelle d'un filtre passe-bas
Hpb = fft(hpb,Zp);                                  %réponse fréquentielle du filtre passe-bas

%%%%%%%%%%%
%%4.1.1.2%%
%%%%%%%%%%%

XB = [XB zeros(1, (Ordre-1)/2)];                    % Ajout de 0 à la fin du signal pour éviter les problèmes de retard
ypb=filter(hpb,1,XB);                               % cela correspond à x1til
ypb=ypb(((Ordre-1)/2)+1:end);                       % On retire les 0 après le filtrage
ypb_TF=fft(ypb,Zp);                                 %TF de la sortie par un filtre passe-bas
DSPY = abs(ypb_TF).*abs(ypb_TF);                    %DSP de la sortie par un filtre passe-bas
figure,
    subplot(2,1,1)
    plot([-(Ordre-1)/2:(Ordre-1)/2],hpb)
    title("Représentation de la réponse impulsionnelle du filtre passe bas");
    xlabel("Temps (s)");
    ylabel("Amplitude");
    subplot(2,1,2)
    semilogy(f, abs(fftshift(ypb_TF)))
    title("Représentation de la réponse du filtre passe bas en fréquentielle");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");

figure,
    semilogy(f, fftshift(XX))
    hold on
    semilogy(f, fftshift(abs(max(XX)*Hpb)));
    title("Représentation de la DSP du signal MF-TDMA et le module de la réponse en fréquentielle du filtre passe bas");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");
    legend({'DSP du signal MF-TDMA','Réponse en fréquentielle du filtre passe bas'},'Location','Southwest')
    


    


%%%%%%%%%
%%4.1.2%%
%%%%%%%%%

%% Implantation du filtre passe haut %%
hph=-hpb;                                           % réponse impulsionnelle passe-haut (définition dans l'énoncé) hph = dirac - hpb
hph((Ordre-1)/2+1)=1-hpb((Ordre-1)/2+1);            % réponse impulsionnelle passe-haut pour le cas à part où le Dirac vaut 1

%% Implantation du filtre passe haut de type RIF %%
yph=filter(hph,1,XB);                               % cela correspond à x2til
yph=yph(((Ordre-1)/2)+1:end);                       % on prend qu'à partir de (Ordre-1)/2 + 1 pour ne pas prendre en compte les 0 
                                                    % ajoutés à l'entrée du filtre pour éviter le retard 
yph_TF=fft(yph,Zp);                                 % TF de la sortie du filtre

HPH=fft(hph,Zp);                                    % réponse fréquentielle du filtre passe-haut

figure,
    subplot(2,1,1)
    plot([-(Ordre-1)/2:(Ordre-1)/2],hph)
    title("Représentation de la réponse impulsionnelle du filtre passe haut");
    xlabel("Temps (s)");
    ylabel("Amplitude");
    subplot(2,1,2)
    semilogy(f, abs(fftshift(yph_TF)))
    title("Représentation de la réponse du filtre passe haut en fréquentielle");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");

figure,
    semilogy(f, fftshift(XX))
    hold on
    semilogy(f, fftshift(abs(max(XX)*HPH)));
    title("Représentation de la DSP du signal MF-TDMA et le module de la réponse en fréquentielle du filtre passe haut");
    xlabel("Fréquence (Hz)");
    ylabel("Amplitude");
    legend({'DSP du signal MF-TDMA','Réponse en fréquentielle du filtre passe haut'},'Location','Southwest')

%%%%%%%%%
%%4.1.3%%
%%%%%%%%%


figure,
   subplot(2,1,1);
   plot(ts,ypb);
   title("Représentation du message x1till");
   xlabel("Temps (s)");
   ylabel("Amplitude");
   subplot(2,1,2);
   plot(ts, yph);
   title("Représentation du message x2till");
   xlabel("Temps (s)");
   ylabel("Amplitude");
 


%%%%%%%%%
%%%4.2%%%
%%%%%%%%%

%% Réalisation du deuxième filtrage et multiplication avec un cosinus
ytilpb=ypb;                                        %sortie du premier passe-bas modulé
ytilpb = [ytilpb zeros(1,(Ordre-1)/2)];            %ajout des zéros pour éviter le problème de retard
yfiltrerpb=filter(hpb,1,ytilpb);                   %application d'un filtre passe-bas
yfiltrerpb=yfiltrerpb(((Ordre-1)/2)+1:end);        %on reprend à (Ordre-1)/2 + 1 pour ne pas prendre en compte les zéros ajouté à l'entrée du filtre

ytilph=yph.*cos(2*pi*fp2*ts);                      %sortie du passe-haut modulé
ytilph = [ytilph zeros(1,(Ordre-1)/2)];            %ajout des zéros pour éviter le problème de retard
yphfiltrerpb=filter(hpb,1,ytilph);                 %application d'un filtre passe-bas
yphfiltrerpb=yphfiltrerpb(((Ordre-1)/2)+1:end);    %on reprend à (Ordre-1)/2 + 1 pour ne pas prendre en compte les zéros ajouté à l'entrée du filtre


figure,
    subplot(2,1,1)
    plot(ts,yfiltrerpb);
    title("Représentation du message 1 avec le retour en bande de base");
    xlabel("Temps (s)");
    ylabel("Amplitude");
    subplot(2,1,2)
    plot(ts,yphfiltrerpb);
    title("Représentation du message 2 avec le retour en bande de base");
    xlabel("Temps (s)");
    ylabel("Amplitude");

%%%%%%%%%
%%%4.3%%%
%%%%%%%%%

%%on prend le slot avec l'énergie la plus importante et on conserve le slot


x1_prime_slot=reshape(yfiltrerpb,length(yfiltrerpb)/Nbr_Slot,Nbr_Slot); %On reforme notre matrice de façon à avoir 5 slots distincts

Energie_slot0=sum(abs(x1_prime_slot));                                  %On fait la somme de l'energie de 
                                                                        %chaque slot que l'on regroupe dans un tableau

[max_energie,Slot_max_energie_1]=max(Energie_slot0);                    %On cherche le max de ce tableau

disp(Slot_max_energie_1)                                                %Vérification que le Slot du maximum d'énergie est bien le deuxième
Message_Retrouver_1 = x1_prime_slot(:,Slot_max_energie_1);              %Le message correspond au slot avec le maximum d'énergie

figure,
    plot(te, Message_Retrouver_1)
     title("Représentation du messageretrouvé 1");
     xlabel("Temps (s)");
     ylabel("Amplitude");
     
 %% On réalise exactement les même étapes que pour le message 1 avec le message 2    
     
x2_prime_slot=reshape(yphfiltrerpb,length(yfiltrerpb)/Nbr_Slot,Nbr_Slot);%On reforme notre matrice de façon à avoir 5 slots distincts

Energie_slot1=sum(abs(x2_prime_slot));                                   %On fait la somme de l'energie de 
                                                                         %chaque slot que l'on regroupe dans un tableau

[max_energie2,Slot_max_energie_2]=max(Energie_slot1);                    %On cherche le max de ce tableau

disp(Slot_max_energie_2)                                                 %Vérification que le Slot du maximum d'énergie est bien le cinquième
Message_Retrouver_2 = x2_prime_slot(:,Slot_max_energie_2);               %Le message correspond au slot avec le maximum d'énergie

figure,
    plot(te, Message_Retrouver_2)
    title("Représentation du messageretrouvé 2");
    xlabel("Temps (s)");
    ylabel("Amplitude");

%%%%%%%%%
%%%4.4%%%
%%%%%%%%%
 
%% On réalise la démodulation en bande de base pour chaque message

%Message 1

SignalFiltre=filter(ones(1,Ns),1,Message_Retrouver_1) ; %La démodulation d'après l'énoncé
SignalEchantillonne=SignalFiltre(Ns :Ns :end) ;
BitsRecuperes1=(sign(SignalEchantillonne)+1)/2 ;
texte1 = bin2str(BitsRecuperes1);
disp(texte1)                                            % affichage du premier indice

%Message 2

SignalFiltre=filter(ones(1,Ns),1,Message_Retrouver_2) ; %La démodulation d'après l'énoncé
SignalEchantillonne=SignalFiltre(Ns :Ns :end) ;
BitsRecuperes2=(sign(SignalEchantillonne)+1)/2 ;
texte2 = bin2str(BitsRecuperes2);
disp(texte2)                                            % affichage du deuxième indice