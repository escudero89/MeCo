% Revisa si el punto que pasas esta dentro de la celda
% Argumentos que recibe:
%% C = celda 
%% P = punto a comparar
%% tag = etiqueta de la arista del objeto
%% state = nuevo estado a asignar
%% depth = profundidad a descender con los hijos

function C = set_in_state(C, P, tag, state = 2, depth = 0)

	MAX_DEPTH = 1;

	% Saco la distancia entre el punto y el punto central de la celda
	D_P_C = distancia(P, C.punto_central);

	% Solo hacemos todo lo siguiente si el nuevo estado es diferente al anterior
	% O si ya llegamos a la maxima profundidad

	if (depth <= MAX_DEPTH)%C.state != state)

		% Y entre el punto central y el 1 (por ejemplo, es lo mismo cual sea)
		D_P1_C = distancia(C.punto_central, get_args(C.arista1, 1));

		% Si la distancia es mayor, ya esta (de seguro no esta dentro de la celda el punto)
		if (D_P_C <= D_P1_C + eps)

			% Una vez dentro, refinamos la busqueda
			if (is_inside(C, P))
				C.state = state;

				% Creamos los hijos
				Points = get_points(C);
				dx_child = (Points(2, 1) - Points(1, 1)) / 2;
				dy_child = (Points(4, 2) - Points(1, 2)) / 2;

				C.hijos = {
					Celda(Points(1, :), dx_child, dy_child, C.state) ;
					Celda(Points(1, :) + [ dx_child, 0 , 0], dx_child, dy_child, C.state) ;
					Celda(Points(1, :) + [ dx_child, dy_child , 0 ], dx_child, dy_child, C.state) ;
					Celda(Points(1, :) + [ 0, dy_child , 0], dx_child, dy_child, C.state) ;
				};

				for h = 1 : length(C.hijos)

					C.hijos{h} = set_in_state(C.hijos{h}, P, tag, state + 1, depth + 1);

				end

			end
		end

	end

	% Si no hay una arista asignada, o si la distancia a la arista es la menor, se la asignamos
	if (isempty(C.arista_mas_cercana) || D_P_C <= C.arista_mas_cercana(2))
		C.arista_mas_cercana = [ tag , D_P_C ];
	end

endfunction