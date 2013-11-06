# Subdivide recursivamente en elemento hasta sub_max.
function D = subdividir(E, matriz_intersecciones, max_profundidad)
    D = {};
    profundidad = E.cabecera(3);

    if( profundidad == max_profundidad)

        D = hijos(E, matriz_intersecciones); # hijos devuelve {cell}

    else

        [D, nueva_matriz_intersecciones] = hijos(E, matriz_intersecciones);

        for i = 1:size(D,1)
      
            if( !isempty(D{i}.idx_segmentos) ) % si hay interseccion
                D{i} = subdividir(D{i}, nueva_matriz_intersecciones, max_profundidad);
            endif

        endfor

    endif

endfunction



function [D, nueva_matriz_intersecciones] = hijos(E, matriz_intersecciones)




endfunction
