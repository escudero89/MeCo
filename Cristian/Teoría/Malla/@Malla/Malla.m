## -*- texinfo -*-
## @deftypefn  {Function File} {} Malla ()
## @deftypefnx {Function File} {} Malla (@var{lim_x}, @var{lim_y}, @var{dx}, @var{dy}, @var{objeto})
## Crea una malla con celdas por lim_x X lim_y, con un paso dx, dy.
## El objeto esta definido dentro de ella.
## @end deftypefn

function M = Malla (lim_x, lim_y, dx, dy, objeto)

	Lx = [lim_x(1) : dx : lim_x(2) - dx];
	Ly = [lim_y(1) : dy : lim_y(2) - dy];

	% Almaceno el objeto en ella
	M.objeto = objeto;

	% Para almacenar todas las celdas
	M.celdas = {};

	contador = 1;

	for j = 1 : length(Ly)
		for i = 1 : length(Lx)

			M.celdas{contador} = Celda([Lx(i), Ly(j)], dx, dy);

			contador++;
		end
	end

	% Voy recorriendo cada elemento de objeto, y marcando el estado nuevo en las celdas
	elementos = get_elementos(objeto);

	for k = 1 : length(elementos)

		actual_ele = elementos{k};

		actual_P1 = get(actual_ele{2});
		actual_P2 = get(actual_ele{3});
		actual_distancia = norm(actual_P1 - actual_P2);

		paso_interpolacion = min(min(dx, dy), actual_distancia)/actual_distancia;

		% Interpolacion entre los dos puntos de la arista
		% el vector unique es para motivos de tomar todos los intervalos correctos al interpolar
		for alfa = unique([0 , paso_interpolacion : paso_interpolacion : 1 , 1])

			punto_actual = (1 - alfa) * actual_P1 + alfa * actual_P2;

			for kCelda = 1 : length(M.celdas)

				M.celdas{kCelda} = set_in_state(M.celdas{kCelda}, punto_actual, actual_ele{1});

			end

		end

	end

	% Ahora recorremos todo de nuevo, pero para determinar lado interior y exterior del objeto
	for k = 1 : length(M.celdas)

		M.celdas{k} = set_side_state(M.celdas{k}, elementos);

	end

	M = class (M, 'Malla');

endfunction



		