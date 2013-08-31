#! /usr/bin/octave -qf
1;
clear all;

% Tamanho malla de NxM

N = 11;
M = 21;

% Rango de x, rango de y

x_range = [0 5];
y_range = [0 5];

% Creo los puntos

x = [x_range(1) : x_range(end) / (N - 1) : x_range(end)];
y = [y_range(1) : y_range(end) / (M - 1) : y_range(end)];

[xx yy] = meshgrid(x, y);

%%%%%%%%%%%%%%%%%%%%%%%%

% Prueba, inserto el dibujo de un rectangulo (arista_bajo, arista_izq, arista_arriba, arista der)

ro_points = [[0 : 3/10 : 3] ; [0 : 3/10 : 3]];

% Voy a recorrer toda la matriz horizontalmente, parandome en un punto y recibando su cuadrado inferior izq :; (asi pero reflejado vertical)

pto_inicio_col = ceil((0 + M)/M);
pto_inicio_row = min([1 M]);

% Desde la esquina sup derecha, a la izq inferior
celda_actual = [
	x(pto_inicio_row + 1)	y(pto_inicio_col + 1)	;
	x(pto_inicio_row)		y(pto_inicio_col) 		;
]

% Estoy parado en ella?
for j = 1 : size(ro_points)(2)

	if (ro_points(1, j) >= celda_actual(2, 1) && ro_points(1, j) <= celda_actual(1, 1))
		% Otra prueba para ver si estoy realmente ahi
		if (ro_points(2, j) >= celda_actual(2, 2) && ro_points(2, j) <= celda_actual(1, 2))

			[ ro_points(1, j) ro_points(2, j) ]

		end
	end
end
