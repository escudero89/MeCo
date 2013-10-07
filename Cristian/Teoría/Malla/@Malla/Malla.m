## -*- texinfo -*-
## @deftypefn  {Function File} {} Malla ()
## @deftypefnx {Function File} {} Malla (@var{lim_x}, @var{lim_y}, @var{dx}, @var{dy})
## Crea una malla con celdas por lim_x X lim_y, con un paso dx, dy
## @end deftypefn

function M = Malla (lim_x, lim_y, dx, dy)

	Lx = [lim_x(1) : dx : lim_x(2) - dx];
	Ly = [lim_y(1) : dy : lim_y(2) - dy];

	% Para almacenar todas las celdas
	M.celdas = {};

	contador = 1;

	for j = 1 : length(Ly)
		for i = 1 : length(Lx)

			M.celdas{contador} = Celda([Lx(i), Ly(j)], dx, dy);

			contador++;
		end
	end

	M = class (M, 'Malla');

endfunction



		