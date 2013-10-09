function print_malla(M)

	print_malla_helper(M.celdas);

endfunction

function print_malla_helper(celdas)

	for k = 1 : length(celdas)

    	if (isempty(get_childs(celdas{k})))

	 		celda = celdas{k};

	 		Xs = get_points(celda);

	        Xs = [Xs; Xs(1, :)];

	        Us = get_state(celda) * ones(4 + 1, 1);

	        patch(Xs(:,1), Xs(:,2), Us(:,1));

	        text(.5 * (get_points(celdas{k})(2,1) + get_points(celdas{k})(1,1)), 
	        	.5 * (get_points(celdas{k})(4,2) + get_points(celdas{k})(1,2)),
	        	[ num2str(get_state(celdas{k})) ' [' num2str(k) ']' ]);

		else
	    	
	    	% Recorremos sus cuatros hijos
	    	print_malla_helper(get_childs(celdas{k}));

	    end
	end

endfunction