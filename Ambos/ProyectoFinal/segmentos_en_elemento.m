% Va a devolver una fila de la forma
% idx_segm , inter_x, inter_y, idx_ele, profundidad_ele

function [ matriz_intersecciones ] = segmentos_en_elemento(E, segmentos, aristas = [1 1 1 1])

	% Tenemos una matriz de inter. por elemento
	% [ idx_segm_1 , hay_inter_1(1:4) , punto_inter_1(:, :) ]
	% [     ...             ...                ...          ]
	% [ idx_segm_n , hay_inter_n(1:4) , punto_inter_n(:, :) ]
	matriz_intersecciones = []; 

	for kSeg = 1 : size(segmentos, 1)

		P1 = segmentos(kSeg, 1:2); 
		P2 = segmentos(kSeg, 3:4);

		% Le agregue un indice en la ultima col de segmentos
		idx_segmento = segmentos(kSeg, end);
	
		if ( dentro_elemento(E,P1) && dentro_elemento(E,P2) )

			% Una fila con todos ceros excepto el primer elemento marca un segmento interno
			matriz_intersecciones = [
				matriz_intersecciones ; idx_segmento, zeros(1, 20),
				];
				
		else
		
			A = E.puntos;

			for kAr = 1 : 4
				
				if (aristas(kAr))
					[hay_inter_n, punto_inter_n] = ...
						hay_interseccion(P1, P2, A(kAr,:), A(mod(kAr,4)+1,:));
				else
					hay_inter_n = 0;
					punto_inter_n = zeros(1, 4);					
				endif
				4*(kAr-1)+1 : 4*kAr;
				
				hay_inter(kAr) = hay_inter_n;
				punto_inter(4*(kAr-1)+1 : 4*kAr) = punto_inter_n;
				
			endfor
			
		%	 A = E.puntos;
			% El for de arriba hace esto:
	%		 [hay_inter(1), punto_inter(1:4)] = hay_interseccion(P1, P2, A(1,:), A(2,:));
	%		 [hay_inter(2), punto_inter(5:8)] = hay_interseccion(P1, P2, A(2,:), A(3,:));
	%		 [hay_inter(3), punto_inter(9:12)] = hay_interseccion(P1, P2, A(3,:), A(4,:));
	%		 [hay_inter(4), punto_inter(13:16)] = hay_interseccion(P1, P2, A(4,:), A(1,:));

			if (sum(hay_inter) > 0)

				matriz_intersecciones = [
					matriz_intersecciones ; idx_segmento, hay_inter, punto_inter
					];

			endif
			
		endif
	
	endfor

endfunction

function [dentro] = dentro_elemento(E, P, tol=eps)
	
	x_min = E.puntos(1,1) - tol;
	x_max = E.puntos(3,1) + tol;
	y_min = E.puntos(1,2) - tol;
	y_max = E.puntos(3,2) + tol;
	
	dentro = false;
	
	if(	P(1) >= x_min && P(1) <= x_max &&
		P(2) >= y_min && P(2) <= y_max )
		dentro = true;
	endif 

endfunction



