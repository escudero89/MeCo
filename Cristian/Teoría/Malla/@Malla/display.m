function display(M, idx = 0)

	% Es decir, le pasamos una celda
	if (nargin == 2)

		display_helper(M, idx);
		
	else

		for k = 1 : length(M.celdas)
			
			display_helper(M, k);

		end

	end

endfunction

function display_helper(M, idx)

	fprintf('= CELDA NUMERO %d (state: %d) =\n', idx, get_state(M.celdas{idx}));
	display(M.celdas{idx});
	fprintf('--------------------------------------------\n\n');

end