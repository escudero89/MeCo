1;
clear all;
clf;
close;

l = 1;
dx = 0.01;
h = 0.01;
E = 1e03;

xx = 0 : dx : l;

cond_contorno = [
		% u, u', u'', u''' (binario)
		1 , 1 , 0 , 0 ;
		0 , 0 , 1 , 1 ;
	];

val_contorno = [
		% u, u', u''
		0 , 0 , 0 , 0 ;
		0 , 0 , 0 , 0 ;
	];

[u, M, Q] = viga_1d(l, dx, h, E, cond_contorno, val_contorno);

% Datos que ingreso aca, no modifican script
q0 = 1;
I  = l * h^3 / 12;

subplot(1, 3, 1)
plot(xx/l, u * E * I / (q0 * l^4));
xlabel('x/l');
title('Deflexion: u * E * I / (q0 * l^4)');
grid;

subplot(1, 3, 2)
plot(xx, M / (q0 * l^2), 'r');
xlabel('x/l');
title('Momento flextor: M / (q0 * l^2)');
grid;

subplot(1, 3, 3)
plot(xx, Q / (q0 * l^2), 'm');
xlabel('x/l');
title('Esfuerzo cortante: Q / (q0 * l^2)');
grid;