function display (celda)

	if (isempty(celda.hijos))
		display_helper(celda);
	else
		for k = 1 : length(celda.hijos)
			fprintf('____________________________________________\n\n')
			fprintf('Celda hijo (%d) (state: %d):\n', k, get_state(celda.hijos{k}));
			display(celda.hijos{k});
		end
	end

endfunction

function display_helper(celda)
	
	fprintf('\n');
	display(celda.arista1); fprintf('\n');
	display(celda.arista2); fprintf('\n');
	display(celda.arista3); fprintf('\n');
	display(celda.arista4);	fprintf('\n');

endfunction