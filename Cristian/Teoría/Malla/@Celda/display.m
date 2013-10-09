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
	fprintf('Punto mas cercano {central}: [ %f , %f , %f ] { %f , %f , %f } <%f> \n', 
		celda.punto_mas_cercano, 
		get(celda.punto_central));

	if (!isempty(celda.normal_mas_cercana))
		fprintf('Normal mas cercana (%d) <%f>: ', 
			celda.normal_mas_cercana(1), 
			celda.normal_mas_cercana(2));

		display(celda.normal_mas_cercana(3:end));
	else
		fprintf('\n');
	end

	display(celda.arista1); fprintf('\n');
	display(celda.arista2); fprintf('\n');
	display(celda.arista3); fprintf('\n');
	display(celda.arista4);	fprintf('\n');	

endfunction