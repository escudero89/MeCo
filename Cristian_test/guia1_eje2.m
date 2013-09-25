#! /usr/bin/octave -qf
1;
clear all;

% Lo hice de forma analitica (a lo de armar las matrices)

% Datos
N = 10;

L_x = 1; % rango maximo

h = L_x / N;

x = 0 : h : L_x;

% La cantidad de filas va a ser N + 1
K = zeros(N + 1, N + 1)

% K x = f

f = zeros(N + 1, 1)

% Estos son valores que calculo teniendo simplemente los puntos
Q = [];

for x_i = x
	Q = [ Q ; 1 - 4 * (x_i - 1 / 2)^2 ]
end

% Caso especial en los extremos
K(1, 1:2) = [ (h^2 - 2) , 2 ];
K(length(K), (length(K) - 1 : length(K))) = [ 2 , (h^2 - 2) ];

f(1) = h * (-20 - Q(1) * h);

for i = 2 : length(f)
	f(i) = - Q(i) * h^2;

	if (i < length(f)) 
		K(i, i - 1) = 1;
		K(i, i) = h^2 - 2;
		K(i, i + 1) = 1;
	end
end

% Resolvemos y graficamos
plot(x, K \ f, 'g');

title('Grafica de la solucion')
xlabel('Distancia: x [m]');
ylabel('Temperatura: T(x) [ºC]');


% Parte analitica (extraida del wolfram)

symbols

x = sym('x');

C2 = (-6 * Cos(1) + 4) / Sin(1);
T = -6 * Sin(x) + C2 * Cos(x) + 4 * x^2 - 4 * x - 8

pause;

hold on;

splot(T, x, 0:1)

hold off;