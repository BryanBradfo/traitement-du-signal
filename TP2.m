N = 100; % nbre de pas
f1 = 1000;
f2 = 3000;
Fe = 10000;
Te = 1/Fe;
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x1 = cos(2*pi*f1*t);
x2 = cos(2*pi*f2*t);
x = x1 + x2;
X = fft(x);
figure
f = 0 : Fe/(N-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
semilogy(f,abs(X));
xlabel("fréquence");
ylabel("X(f)");

figure
f = 0 : Fe/(N-1) : Fe;
plot(t,x); %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
xlabel("temps");
ylabel("x(t)");

Q = 11;
fc = f1;
fcb = fc/Fe;
h = 2*fcb*sinc(2*fcb*[-(Q-1)/2 : (Q-1)/2]);
subplot(2,2,1);
plot([-(Q-1)/2 : (Q-1)/2],h);
ylabel("Réponse impulsionnelle 11");

P = 61;
fc = f1;
fcb = fc/Fe;
h = 2*fcb*sinc(2*fcb*[-(P-1)/2 : (P-1)/2]);
subplot(2,2,3);
plot([-(P-1)/2 : (P-1)/2],h);
ylabel("Réponse impulsionnelle 61");


Q = 11;
fc = f1;
fcb = fc/Fe;
ZP = 2^(nextpow2(Q));
h = 2*fcb*sinc(2*fcb*[-(Q-1)/2 : (Q-1)/2]);
H = fft(h,ZP);
f = 0 : Fe/(ZP-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
subplot(2,2,2);
semilogy(f,abs(H));
ylabel("Réponse en fréquence 11");

Q = 61;
fc = f1;
fcb = fc/Fe;
ZP = 2^(nextpow2(Q));
h = 2*fcb*sinc(2*fcb*[-(Q-1)/2 : (Q-1)/2]);
H = fft(h,ZP);
f = 0 : Fe/(ZP-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
subplot(2,2,4);
semilogy(f,abs(H));
ylabel("Réponse en fréquence 61");

N = 100; % nbre de pas
f1 = 1000;
f2 = 3000;
Fe = 10000;
Te = 1/Fe;
ZP = 2^(nextpow2(length(x)));
t = 0 : Te : (N-1)*Te; %vecteur [début, pas, fin]
x1 = cos(2*pi*f1*t);
x2 = cos(2*pi*f2*t);
x = x1 + x2;
X = fft(x, ZP);
figure
f = 0 : Fe/(ZP-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
semilogy(f,abs(X));
xlabel("fréquence");
ylabel("X(f)");

Q = 11;
fc = f1;
fcb = fc/Fe;
ZP = 2^(nextpow2(length(x)));
h1 = 2*fcb*sinc(2*fcb*[-(Q-1)/2 : (Q-1)/2]);
H1 = fft(h1,ZP);
f = 0 : Fe/(ZP-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
hold on;
semilogy(f,abs(H1));
ylabel("Réponse en fréquence 11");

Q = 61;
fc = f1;
fcb = fc/Fe;
ZP = 2^(nextpow2(length(x)));
h2 = 2*fcb*sinc(2*fcb*[-(Q-1)/2 : (Q-1)/2]);
H2 = fft(h2,ZP);
f = 0 : Fe/(ZP-1) : Fe; %plot(linspace(0,(N-1)*Te,N),x); % linspace(debut,fin, nb de points)
hold on;
semilogy(f,abs(H2));
legend('100','11','61');
ylabel("Réponse en fréquence 61");

y11 = filter (h1,1,x);
y61 = filter (h2,1,x);
Y11 = fft(y11,ZP);
Y61 = fft(y61,ZP);
figure
semilogy(f, abs(Y11));
hold on
semilogy(f, abs(Y61));
legend('Y11','Y61');