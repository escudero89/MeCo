#! /usr/bin/octave -qf
1;
clear all;

% Defino la maxima profundidad
global MAX_DEPTH = 6;

% Le paso una celda con dos puntos (izq a der, abajo a arriba)
% Devuelve una con 4+5 puntos, que seria la misma subdivida en 4
function [nueva_celda] = subdivide_cell(vieja_celda)

	% Creo una nueva celda con 4 puntos
	celda = [
			vieja_celda(1, 1) , vieja_celda(1, 2) ;
			vieja_celda(2, 1) , vieja_celda(1, 2) ; % nueva _|
			vieja_celda(1, 1) , vieja_celda(2, 2) ; % nueva |-
			vieja_celda(2, 1) , vieja_celda(2, 2) ;
		];

	% Guardo el primer punto x0, y0 en la primera fila y saco el punto entre medio del x0 y el x1 
	% y lo agrego (horizontalmente) y asi suceviamente
	nueva_celda = [
			celda(1,1) , celda(1, 2) ;
			(celda(2, 1) + celda(1, 1))/2 , (celda(2, 2) + celda(1, 2))/2 ;
			celda(2,1) , celda(2, 2) ;
			(celda(3, 1) + celda(1, 1))/2 , (celda(3, 2) + celda(1, 2))/2 ;
			(celda(4, 1) + celda(1, 1))/2 , (celda(4, 2) + celda(1, 2))/2 ;
			(celda(4, 1) + celda(2, 1))/2 , (celda(4, 2) + celda(2, 2))/2 ;
			celda(3,1) , celda(3, 2) ;
			(celda(4, 1) + celda(3, 1))/2 , (celda(4, 2) + celda(3, 2))/2 ;
			celda(4,1) , celda(4, 2) ;
		];

	return;

end

% Le paso una celda con dos puntos (esq inf izq, esq sup der), y los puntos que puede contener
function [retorno] = subdivide(celda, ro_points, iteracion)

	global MAX_DEPTH; % requiero definirla tambien aca

	iteracion++;
	true_points = [];

	for j = 1 : size(ro_points)(1)

		if (ro_points(j, 1) >= celda(1, 1) && ro_points(j, 1) <= celda(2, 1))
			% Otra prueba para ver si estoy realmente ahi
			if (ro_points(j, 2) >= celda(1, 2) && ro_points(j, 2) <= celda(2, 2))
				true_points = [ true_points ; ro_points(j, 1) ro_points(j, 2) ];
			end
		end
	end

	% Subdivido
	celda = subdivide_cell(celda);

	if (length(true_points) == 0)
		retorno = [ 
				celda(1, 1) celda(1, 2) ; celda(3, 1) celda(3, 2) ;
				celda(7, 1) celda(7, 2) ; celda(9, 1) celda(9, 2) ;
			];

		return;
	end

	% Si pasamos la iteracion
	if (iteracion > MAX_DEPTH)
		% Pero si no hay puntos en el
		retorno = celda;
		return;
	end

	% Llamo a subdivide cuatro veces para la nueva celda
	disp('P1');
	p1 = subdivide([celda(1, 1) celda(1, 2) ; celda(5, 1) celda(5, 2)], true_points, iteracion);
	
	if (length(p1) == 0)
		p1 = [ celda(1, 1) celda(1, 2) ];
	end
	
	disp('P2');
	p2 = subdivide([celda(2, 1) celda(2, 2) ; celda(6, 1) celda(6, 2)], true_points, iteracion);
	
	if (length(p2) == 0)
		p2 = [ celda(3, 1) celda(3, 2) ];
	end
	
	disp('P3');
	p3 = subdivide([celda(4, 1) celda(4, 2) ; celda(8, 1) celda(8, 2)], true_points, iteracion);
	
	if (length(p3) == 0)
		p3 = [ celda(7, 1) celda(7, 2) ];
	end

	disp('P4');
	p4 = subdivide([celda(5, 1) celda(5, 2) ; celda(9, 1) celda(9, 2)], true_points, iteracion);

	if (length(p4) == 0)
		p4 = [ celda(9, 1) celda(9, 2) ];
	end

	retorno = [ p1 ; p2 ; p3 ; p4];

end


% Le paso un array con dos puntos [x0 y0 ; xf yf], y los puntos que contiene [x0 y0, x1 y1, ..., xn, yn]
function [celda_subdividida] = subdivide_main(celda, puntos)

	celda_subdividida = unique(subdivide(celda, puntos, 0), 'rows');
	
end

% Tamanho malla de NxM

N = 5;
M = 4;

% Rango de x, rango de y

x_range = [0 4];
y_range = [0 3];

% Creo los puntos

x = [x_range(1) : x_range(end) / (N - 1) : x_range(end)];
y = [y_range(1) : y_range(end) / (M - 1) : y_range(end)];

[xx yy] = meshgrid(x, y);

%%%%%%%%%%%%%%%%%%%%%%%%

% Prueba, inserto el dibujo de un rectangulo (arista_bajo, arista_izq, arista_arriba, arista der)

ro_points = [1.1 1.1 ; 2.3 2.3];

% Voy a recorrer toda la matriz horizontalmente, parandome en un punto y recibando su cuadrado inferior izq :; (asi pero reflejado vertical)

pos_row = 1;
pos_col = 1;

celda_subdividida = [];

for kContador = [1 : (N - 1) * (M - 1)]

	% Desde la esquina izq inferior a la sup derecha
	celda_actual = [
		x(pos_col)		y(pos_row) 		;
		x(pos_col + 1)	y(pos_row + 1)	;
	];

	% Estoy parado en ella?
	for j = 1 : size(ro_points)(1)

		if (ro_points(j, 1) >= celda_actual(1, 1) && ro_points(j, 1) <= celda_actual(2, 1))
			% Otra prueba para ver si estoy realmente ahi
			if (ro_points(j, 2) >= celda_actual(1, 2) && ro_points(j, 2) <= celda_actual(2, 2))

				% Quiere decir aca que realmente esta el punto en la celda.
				celda_subdividida = [ 
						celda_subdividida ; subdivide_main(celda_actual, [ ro_points(j, 1) ro_points(j, 2) ]) 
					];

			end
		end
	end

	pos_col++;

	if (pos_col > (N - 1))
		pos_col = 1;
		pos_row ++;
	end

end

celda_subdividida = unique(celda_subdividida, 'rows');

clf;
hold on;
plot(xx, yy, 'xb');
plot(celda_subdividida(:,1), celda_subdividida(:,2), 'or');
hold off;