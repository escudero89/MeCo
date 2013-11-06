function plot_elemento(E, etiquetado = 0, lim = 1)
		
		p1 = E.puntos(1,:); 
		p2 = E.puntos(2,:); 
		p3 = E.puntos(3,:); 
		p4 = E.puntos(4,:); 
		
		line([p1(1) p2(1)],[p1(2) p2(2)]);
        line([p2(1) p3(1)],[p2(2) p3(2)]);
        line([p3(1) p4(1)],[p3(2) p4(2)]);
        line([p4(1) p1(1)],[p4(2) p1(2)]);
        
        if(lim)
			xlim('auto');
			ylim('auto');
			
			limite_x = xlim();
			limite_y = ylim();
			
			xlim([limite_x(1) - 1, limite_x(2) + 1]);
			ylim([limite_y(1) - 1, limite_y(2) + 1]);
        endif
        
        if(etiquetado)
            x_c = (p3(1) + p1(1))/2;
			y_c = (p4(2) + p1(2))/2;
            
            label = strcat("E = ", num2str(E.cabecera(2)), 
				"\n V: [", num2str(E.vecinos), "]",
				"\n", num2str(E.idx_segmentos_internos));
            text(x_c, y_c, label);
		endif

endfunction

