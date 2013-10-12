% La recurssion me va a hacer que me cree hijos una y otra vez
function C = create_childs(C, max_depth, recurssion = false)

	% Los hijos se crean solo si no existen (o si no se llego a la profundidad maxima)
	if (isempty(C.hijos) && abs(C.state) < max_depth)

		Points = get_points(C);

		dx_child = (Points(2, 1) - Points(1, 1)) / 2;
		dy_child = (Points(4, 2) - Points(1, 2)) / 2;

		% El nuevo hijo tendra el estado del padre incrementado
		state = (abs(C.state) + 1) * sign(C.state);

		C.hijos = {
			Celda(Points(1, :), dx_child, dy_child, state) ;
			Celda(Points(1, :) + [ dx_child, 0 , 0], dx_child, dy_child, state) ;
			Celda(Points(1, :) + [ dx_child, dy_child , 0 ], dx_child, dy_child, state) ;
			Celda(Points(1, :) + [ 0, dy_child , 0], dx_child, dy_child, state) ;
		};

	end

	if (recurssion)
		for hijo = 1 : length(C.hijos)
			C.hijos{hijo} = create_childs(C.hijos{hijo}, max_depth, recurssion);
		end
	end

	return;

endfunction