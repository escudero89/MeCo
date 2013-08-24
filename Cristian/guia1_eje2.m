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

f(1) = h * (20 - h * (Q(1) + 10));

for i = 2 : length(f)
	f(i) = - Q(i) * h^2;

	if (i < length(f)) 
		K(i, i - 1) = 1 + h / 2;
		K(i, i) = h^2 - 2;
		K(i, i + 1) = 1 - h / 2;
	end
end

% Resolvemos y graficamos
plot(x, K \ f, 'g');

title('Grafica de la solucion')
xlabel('Distancia: x [m]');
ylabel('Temperatura: T(x) [ºC]');


% Parte analitica (extraida del wolfram)

symbols

t = sym('t');

%T = (4 * e^(t/2) - 12 * e^(t/2)*  t + 4 * e^(t/2) * t^2 - 11 * Cos((Sqrt(3) * t)/2) + 11 * Sqrt(3) * Cos((Sqrt(3) * t)/2) * 1 / Tan(Sqrt(3)/2) - 2 * Sqrt(3 * e) * Cos((Sqrt(3) * t)/2) / Sin(Sqrt(3)/2) + 11 * Sqrt(3) * Sin((Sqrt(3) * t)/2) + 11 / Tan(Sqrt(3)/2) * Sin((Sqrt(3) * t)/2) - 2 * Sqrt(e) / Sin(Sqrt(3)/2) * Sin((Sqrt(3) * t)/2))/e^(t/2)
T_temp = 10.5;

T=((14*e-36)/(3*e-3)+(22*e^(1-t))/(3*e-3)+(4*t^3-18*t^2+36*t-36)/3) / (1 - (3*e-3)/(3*e-3));

pause;

hold on;
%plot(t, T_val, 'r');
splot(T, t, 0:1)

hold off;