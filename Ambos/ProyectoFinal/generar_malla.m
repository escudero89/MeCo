function [ M ] = generar_malla(x,y, segmentos)

    cant_ele_x = length(x) - 1;
    cant_ele_y = length(y) - 1;
    
    %% La idea es hacer una matriz de la forma
    %% 6 ... 5 5 5 5 ... 9
    %% 1 ... 0 0 0 0 ... 4
    %% 1 ... 0 0 0 0 ... 4
    %% 8 ... 7 7 7 7 ... 11
    
    Z = zeros(cant_ele_y, cant_ele_x);
    Z(:,1) = 1;
    Z(:,end) = 4;
    Z(1,:) += 7;
    Z(end,:) += 5;
    
    Z
    
    % No recorremos la ultima fila ni la ultima columna
    for j = 1 : cant_ele_y
        for i = 1 : cant_ele_x

            P1 = [x(i), y(j)];
            P2 = [x(i+1), y(j)];
            P3 = [x(i+1), y(j+1)];
            P4 = [x(i), y(j+1)];  
            
            idx = i + (j - 1) * ( cant_ele_x );
            
			idx_padre = idx;
            
            cabecera = [ idx_padre , idx , 0 ];
            
            # Creamos Elemento [idx_padre ; idx_elemento ; profundidad ]
             E = struct("cabecera", cabecera,
                        "puntos", [P1 ; P2 ; P3 ; P4],
                        "idx_segmentos", [],
                        "vecinos", asignar_vecinos(idx, cant_ele_x, Z(j,i)));


            [matriz_intersecciones , E] = segmentos_en_elemento(E, segmentos);
            
            # Guardamos el Elemento en la malla
            M{idx} = E;

            if( !isempty(E.idx_segmentos_internos) )
                           
                M{idx} =  subdividir(E, matriz_intersecciones, max_profundidad);
                
            endif

            
            
            
            
        # Asignamos los puntos de la figura a los Elementos Correspondientes
    %    [E idx_figura] = mapear_puntos(E, figura, idx_figura, tol);
                
        endfor
    endfor

endfunction

