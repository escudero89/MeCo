function plot_malla(M, etiquetado = 0)

    hold on;
    plot_malla_r(M, etiquetado);
    hold off;
    
endfunction

function plot_malla_r(M, etiquetado = 0)

    if(!isempty(M))
	for i = 1 : size(M,2)
	    if(!iscell(M{i}))
		plot_elemento(M{i}, etiquetado);
	    else
		plot_malla_r(M{i}, etiquetado);
	    endif
	    
	endfor
    endif
    
endfunction
