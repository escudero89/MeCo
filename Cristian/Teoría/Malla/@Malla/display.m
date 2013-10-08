function display(M)

	for k = 1 : length(M.celdas)
		
		fprintf('= CELDA NUMERO %d (state: %d) =\n', k, get_state(M.celdas{k}));
		display(M.celdas{k});
		fprintf('--------------------------------------------\n\n');

	end

endfunction