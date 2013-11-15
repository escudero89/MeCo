function [ M ] = generar_malla(x,y, segmentos, max_profundidad = 0)

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
            
            % Creamos Elemento [idx_padre ; idx_elemento ; profundidad ]
             E = struct('cabecera', cabecera,
                        'puntos', [P1 ; P2 ; P3 ; P4],
                        'matriz_intersecciones', []);%,
                        %'vecinos', asignar_vecinos(idx, cant_ele_x, Z(j,i)));


            [ matriz_intersecciones ] = segmentos_en_elemento(E, segmentos);

            E.matriz_intersecciones = matriz_intersecciones;
            
            % Guardamos el Elemento en la malla
            M{idx} = E;

            if( !isempty(E.matriz_intersecciones) )
                           
                M{idx} =  subdividir(E,                    
                                     max_profundidad,
                                     cant_ele_x * cant_ele_y,
                                     segmentos);
                
            endif

            
        % Asignamos los puntos de la figura a los Elementos Correspondientes
    %    [E idx_figura] = mapear_puntos(E, figura, idx_figura, tol);
                
        endfor
    endfor

endfunction
