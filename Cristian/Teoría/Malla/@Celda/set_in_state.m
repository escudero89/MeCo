% Revisa si el punto que pasas esta dentro de la celda
% Argumentos que recibe:
%% C = celda 
%% P = punto a comparar
%% tag = etiqueta de la arista del objeto
%% normal = valor de la normal mas cercana
%% state = nuevo estado a asignar
%% depth = profundidad a descender con los hijos

function C = set_in_state(C, P, tag, normal, max_depth, depth = 0)

	% Saco la distancia entre el punto y el punto central de la celda
	D_P_C = distancia(P, C.punto_central);

	% Solo hacemos todo lo siguiente si no llegamos a la maxima profundidad
	if (depth < max_depth)

		% Y entre el punto central y el 1 (por ejemplo, es lo mismo cual sea)
		D_P1_C = distancia(C.punto_central, get_args(C.arista1, 1));

		% Si la distancia es mayor, ya esta (de seguro no esta dentro de la celda el punto)
		if (D_P_C <= D_P1_C + eps)

			% Una vez dentro, refinamos la busqueda
			if (is_inside(C, P))

				% Creamos los hijos 
				C = create_childs(C, max_depth);

				% Y volvemos a recorrer todo
				for h = 1 : length(C.hijos)

					C.hijos{h} = set_in_state(C.hijos{h}, P, tag, normal, max_depth, depth + 1);

				end

			end
		end

	end	

	% Si no hay una normal asignada, o si la distancia a la normal es la menor, se la asignamos
	% Claro que solo nos fijamos en los hijos
	if (isempty(C.hijos) && D_P_C <= C.normal_mas_cercana(2))
		C.normal_mas_cercana = [ tag , D_P_C , normal ];
		C.punto_mas_cercano = P;
	end

endfunction