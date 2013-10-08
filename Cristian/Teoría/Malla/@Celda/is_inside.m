% Revisa si el punto esta dentro de C segun sus coordenadas
function yesno = is_inside(C, P)

	if (strcmp(class(P), 'Punto'))
		P = get(P);
	end

	Points = get_points(C);

	yesno = false;

	% Reviso en x
	if (P(1) >= Points(1, 1) - eps && P(1) <= Points(2, 1) + eps)
		% Reviso en y
		if (P(2) >= Points(1, 2) - eps && P(2) <= Points(4, 2) + eps)
			yesno = true;
		end
	end

endfunction