function [xnod, icone, state, state_matrix] = transformar_malla(M, lim_x, lim_y, max_profundidad)

	% Redefino los limites con el nuevo paso
	factor = 2^(max_profundidad + 1);
	
	lim_x = lim_x(1) : (lim_x(2) - lim_x(1))/factor : lim_x(end);
	lim_y = lim_y(1) : (lim_y(2) - lim_y(1))/factor : lim_y(end);

	% Obtenemos min cord en x y en y
	bordes = obtener_bordes(M, [lim_x(1), lim_y(1)]);

	% Recorremos todos los bordes para obtener el min y max row y col idx
	min_max_row = [bordes(1,1) , bordes(1, 1)];
	min_max_col = [bordes(1,2) , bordes(1, 2)];

	for i = 1 : size(bordes, 1)

		if (bordes(i, 1) < min_max_row(1))
			min_max_row(1) = bordes(i, 1);
		end

		if (bordes(i, 1) > min_max_row(2))
			min_max_row(2) = bordes(i, 1);
		end

		if (bordes(i, 2) < min_max_col(1))
			min_max_col(1) = bordes(i, 2);
		end

		if (bordes(i, 2) > min_max_col(2))
			min_max_col(2) = bordes(i, 2);
		end

	end

	% Reconfiguramos los vectores lim_x y lim_y para solo trabajar con lo que nos interesa

	lim_x = [ lim_x(min_max_col(1) - 1 : min_max_col(2) + 2) ];
	lim_y = [ lim_y(min_max_row(1) - 1 : min_max_row(2) + 2) ];

	[xnod, icone] = qq3d(lim_x', lim_y');
	state = zeros(length(lim_x) - 1, length(lim_y) - 1);

	for n = 1 : size(bordes, 1)
	
		state(bordes(n, 2) - min_max_col(1) + 2, bordes(n, 1) - min_max_row(1) + 2) = 1;

	endfor


	state = balde_de_pintura(state) + 1;

	state_matrix = state;
	state = reshape(state, 1, size(icone, 1));

endfunction

function state = balde_de_pintura( state )
	max_recursion_depth( 2000000 );
	state(1,1) = -1;
	
	state = balde_de_pintura_r(state, 2, 1);
	state = balde_de_pintura_r(state, 1, 2);

endfunction

function state = balde_de_pintura_r(state, i, j)

	if(!(i < 1 || j < 1 || i > size(state,1) || j > size(state,2)))

		if (state(i, j) == 0)
			state(i, j) = -1;
			
			state = balde_de_pintura_r( state, i+1, j );
			state = balde_de_pintura_r( state, i, j+1 );
			state = balde_de_pintura_r( state, i-1, j );
			state = balde_de_pintura_r( state, i, j-1 );

		endif

	endif
	

endfunction
