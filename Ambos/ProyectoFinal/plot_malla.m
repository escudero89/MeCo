function plot_malla(M, etiquetado = 0)
	clf;
	hold on;
	
    for i = 1 : size(M, 2)
		plot_elemento(M{1, i}, etiquetado, 0);
    endfor
	
	hold off;
endfunction
