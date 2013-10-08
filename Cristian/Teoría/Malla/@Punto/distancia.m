% Mide la distancia entre dos puntos
function d = distancia (P1, P2, norma = 1)

	if (strcmp (class (P1), 'Punto'))
		P1 = get(P1);
	end

	if (strcmp (class (P2), 'Punto'))
		P2 = get(P2);
	end

	d = norm(P2 - P1, norma);

endfunction