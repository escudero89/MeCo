% En base a la arista mas cercana (la normal), saca de que lado se encuentra
% Necesito pasarle el objeto porque uso la informacion del tag para encontrar la arista
function C = set_side_state(C, objetos)

	if (isempty(C.hijos))

		objeto = objetos{C.normal_mas_cercana(1)};

		punto_medio_arista = .75 * C.punto_mas_cercano + .125 * (get(objeto{2}) + get(objeto{3}));

		vector = punto_medio_arista - get(C.punto_central);

		% Ahora comparo con la normal mas cercana, si coinciden en producto punto, van pa el mismo lado
		if (dot(vector, C.normal_mas_cercana(3:end)) <= 0)
			C.state = -abs(get_state(C));
		end

	else
		
		for k = 1 : length(C.hijos)
			C.hijos{k} = set_side_state(C.hijos{k}, objetos);
		end

	end

endfunction