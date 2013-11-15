function [vector_bordes] = obtener_bordes(M, min_coord)

    vector_bordes=obtener_bordes_r(M, min_coord);
    
endfunction

function [vector_bordes] = obtener_bordes_r(M, min_coord)

    vector_bordes = [];
    
    if(!isempty(M))
    	for i = 1 : size(M,2)

    	    if(!iscell(M{i}))
    		if( es_borde(M{i}) );
    		    vector_bordes = [vector_bordes ; obtener_id_de_elemento(M{i}, min_coord)];
        
    		endif
    	    else
    		vector_bordes = [vector_bordes ; obtener_bordes_r(M{i}, min_coord)];
    	    endif
    		
    	endfor
    endif
    
endfunction


function borde = es_borde(E)

    if(isempty(E.matriz_intersecciones))
	borde = false;
    else
	borde = true;
    endif

endfunction

function [id_row_col] = obtener_id_de_elemento(E, min_coord)

    punto_ref = E.puntos(1, :);

    % El paso se puede optimizar
    paso = E.puntos(3, :) - E.puntos(1, :);
    
    id_col = (punto_ref(1) - min_coord(1)) / paso(1) + 1;
    id_row = (punto_ref(2) - min_coord(2)) / paso(2) + 1;

    id_row_col = [id_row , id_col];

    return;

endfunction
