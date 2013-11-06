function [lista_vecinos] = asignar_vecinos(idx, cant_ele_x, state)
	
	vecino_upper = idx + cant_ele_x;
	vecino_down = idx - cant_ele_x;
	vecino_right = idx + 1;
	vecino_left = idx - 1;
	
	switch state
	
		case {0}
			% Nada de nada
	
		case {1}
			vecino_left = -1;
		
		case {4}
			vecino_right = -1;
		
		case {5}
			vecino_upper = -1;
		
		case {7}
			vecino_down = -1;
		
		case {6}
			vecino_upper = -1;
			vecino_left = -1;
		
		case {9}
			vecino_right = -1;
			vecino_upper = -1;
		
		case {8}
			vecino_left = -1;
			vecino_down = -1;
		
		case {11}
			vecino_right = -1;
			vecino_down = -1;
		
		otherwise
			error('Switch de asignar_vecinos mal.');
			
	endswitch

	lista_vecinos = [vecino_upper, vecino_left, vecino_down, vecino_right];

	return;

endfunction
