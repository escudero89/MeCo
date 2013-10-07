function print_malla(M)

    for k = 1 : length(M.celdas)

 		celda = M.celdas{k};

 		Xs = get_points(celda);

        Xs = [Xs; Xs(1, :)];

        Us = get_state(celda) * ones(4 + 1, 1);

        patch(Xs(:,1), Xs(:,2), Us(:,1));

    end

endfunction