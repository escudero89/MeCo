function plot_elemento(E, etiquetado = 0, lim = 1)
    
    p1 = E.puntos(1,:); 
    p2 = E.puntos(2,:); 
    p3 = E.puntos(3,:); 
    p4 = E.puntos(4,:); 

    %~ line([p1(1) p2(1)],[p1(2) p2(2)]);
    %~ line([p2(1) p3(1)],[p2(2) p3(2)]);
    %~ line([p3(1) p4(1)],[p3(2) p4(2)]);
    %~ line([p4(1) p1(1)],[p4(2) p1(2)]);
    if(isempty(E.matriz_intersecciones))
	plot([ E.puntos(:,1) ; p1(1) ], [ E.puntos(:,2) ; p1(2) ], 'k');
    else
	patch([ E.puntos(:,1) ], [ E.puntos(:,2) ], 'r');
    endif
    
    if(lim)

	xlim('auto');
	ylim('auto');

	limite_x = xlim();
	limite_y = ylim();

	xlim([limite_x(1) - 1, limite_x(2) + 1]);
	ylim([limite_y(1) - 1, limite_y(2) + 1]);

    endif

    if(etiquetado)

	if (isempty(E.matriz_intersecciones))
	    idx_segmentos = [];
	else
	    idx_segmentos = E.matriz_intersecciones(:,1)';
	end
    
	x_c = (p3(1) + p1(1))/2;
		y_c = (p4(2) + p1(2))/2;

	label = strcat("E = ", num2str(E.cabecera(2)),
		       "\n", num2str(idx_segmentos));

	text(x_c, y_c, label);

    endif

endfunction

