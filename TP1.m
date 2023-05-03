
% Respecte Shannon
N = 90; % nbre de pas
f0 = 1100;
Fe = 10000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
figure
f = 0 : Fe/(N-1) : Fe;
subplot(2,2,1);
plot(t,x); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("temps");
ylabel("amplitude de x(t)");

%2.1 : Ne respecte pas Shannon 
N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,2,2);
plot(t,x); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("temps");
ylabel("amplitude de x(t)");

N = 90; % nbre de pas
f0 = 1100;
Fe = 10000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,2,3)
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");

N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,2,4)
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");

%%%%%%%%%%%%%%%%
% ZERO PADDING %
%%%%%%%%%%%%%%%%
N=90;
f0 = 1100;
Fe = 10000;
Te = 1/Fe;
ZP = 2^(nextpow2(N)) ; % nbre de pas
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin] et le vecteur t, on l'arrête à N, et on rajoute avec du zéro
x = cos(2*pi*f0*t);
X = fft(x,ZP);

f = 0 : Fe/(ZP-1) : Fe;
figure
subplot(2,3,3);
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");


N=90;
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
ZP = 2^(nextpow2(N))*2 ; % nbre de pas
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x,ZP);

f = 0 : Fe/(ZP-1) : Fe;
subplot(2,3,6);
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");


N = 90; % nbre de pas
f0 = 1100;
Fe = 10000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,3,1);
plot(t,x); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("temps");
ylabel("amplitude de x(t)");
N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,3,5)
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");
N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,3,4);
plot(t,x); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("temps");
ylabel("amplitude de x(t)");

N = 90; % nbre de pas
f0 = 1100;
Fe = 10000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,3,2);
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");

N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
f = 0 : Fe/(N-1) : Fe;
subplot(2,3,5)
semilogy(f,abs(X));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");

%%%%%%%%%%%%%%%
%%%%  DSP  %%%%
%%%%%%%%%%%%%%%

%%% Periodogramme
N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
ZP = 2^(nextpow2(N));
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
X = fft(x);
% f = 0 : Fe/N : Fe;
f = linspace(0,Fe,N);
figure
subplot(2,1,1)
semilogy(f, abs(X).^2/(N-1));
%plot(,); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("frequence");
ylabel("amplitude de X(f)");

%%%CORRELOGRAMME
N = 90; % nbre de pas
f0 = 1100;
Fe = 1000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x = cos(2*pi*f0*t);
Rx = conv(fliplr(x),x);
X = fft(Rx);
% f = 0 : Fe/N : Fe;
f = linspace(0,Fe,N);
subplot(2,1,2)
semilogy(f, X);
xlabel("frequence");
ylabel("amplitude de X(f)");

