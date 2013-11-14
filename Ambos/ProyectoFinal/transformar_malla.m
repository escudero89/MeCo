function [xnod, inode, state] = transformar_malla(M, lim_x, lim_y, max_profundidad)

	% Redefino los limites con el nuevo paso
	factor = 2^(max_profundidad + 1);
	
	lim_x = lim_x(1) : (lim_x(2) - lim_x(1))/factor : lim_x(end);
	lim_y = lim_y(1) : (lim_y(2) - lim_y(1))/factor : lim_y(end);

	% Obtenemos min cord en x y en y
	bordes = obtener_bordes(M, [lim_x(1), lim_y(1)]);

	[xnod, inode] = qq3d(lim_x', lim_y');

	state = zeros(sqrt(size(inode, 1)));

	for n = 1 : size(bordes, 1)

		state(bordes(n, 1), bordes(n, 2)) = 1;

	endfor

	state = balde_de_pintura(state) + 1;
	state = reshape(state, 1, size(inode, 1));

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
