#! /usr/bin/octave -qf
1;
clear all;

% Lo hice de forma analitica (a lo de armar las matrices)

% Datos

puntos = [0, 0.05, 0.15, 0.35, 0.5, 0.75, 1];

phi = zeros(length(puntos) - 2, 1);
phi_0 = 1;
phi_L = 0;

f = phi;
K = zeros(length(phi));

Q = -10 .* puntos .* (puntos + 1);

% Voy a usar de a cuatro puntos (i-1, i, i+1, i+2), y en el ultimo uso los puntos (L-3, L-2, L-1, L)

% Tengo que obtener los valores de h (i-1, i), rh (i, i+1), rhp (i, i+2)

% Me paro en el segundo punto (el primero lo "salteo"), hasta el penultimo (caso especial)

for kP = 1 : length(puntos) - 3

	pos = kP + 1;

	h = puntos(pos) - puntos(pos - 1);
	r = (puntos(pos + 1) - puntos(pos)) / h;
	p = (puntos(pos + 2) - puntos(pos)) / (r*h);

	M_abcd = [1 1 1 1 ; -1 0 r r*p ; 1 0 r^2 (r*p)^2 ; -1 0 r^3 (r*p)^3];

	f_abcd = [1 0 2/h^2 0]';

	abcd = M_abcd \ f_abcd;

	% Ahora que tengo los coeficientes, voy armando la matriz para resolver las incognitas

	K(kP, kP) = abcd(2);
	K(kP, kP + 1) = abcd(3);
	
	f(kP) = -Q(kP);

	% Si estoy en la primera fila
	if (kP == 1)
		K(kP, kP + 2) = abcd(4);
		f(kP) -= abcd(1) * phi_0;
	else 
		K(kP, kP - 1) = abcd(1);
	end

end

f(1) = Q(2) - phi_0 * abcd(1);
f(length(f)) = Q(length(Q) - 1) - phi_L * abcd(4);

% Obtengo los coeficientes para el caso especial (penultimo punto)

pos = length(puntos) - 1;
h = puntos(pos + 1) - puntos(pos)
r = (puntos(pos) - puntos(pos - 1)) / h
p = (puntos(pos) - puntos(pos - 2)) / (r*h)

M_abcd = [1 1 1 1 ; -(r*p) -r 0 1 ; (r*p)^2 r^2 0 1 ; -(r*p)^3 -r^3 0 1];
f_abcd = [1 0 2/h^2 0]';

abcd = M_abcd \ f_abcd;

% Y actualizo la matriz K la ultima fila

K(size(K)(1), size(K)(2)-3:size(K)(2)) = [abcd(1) abcd(2) abcd(3) abcd(4)];

incognitas = [phi_0 ; K \ f; phi_L];

clear figure;

plot(puntos, incognitas, 'r');

% Resolucion analitica (por Maxima)

symbols

x = sym('x');

Q = -1*(21*Cos(1)*Sin(x))/Sin(1)+21*Cos(x)+10*x^2+10*x-20;

hold on;
splot(Q, x, 0:1);
hold off;