% Subdivide recursivamente en elemento hasta sub_max.
function D = subdividir(E, max_profundidad, cant_ele_inicial, segmentos)

    D = {};
    profundidad = E.cabecera(3);

    idx_mod = cant_ele_inicial * 4^profundidad;

    if( profundidad == max_profundidad)

        D = hijos(E, idx_mod, segmentos); % hijos devuelve {cell}

    else

        D = hijos(E, idx_mod, segmentos);

        for i = 1:size(D, 2)
      
            if( !isempty(D{i}.matriz_intersecciones) ) % si hay interseccion
                D{i} = subdividir(D{i},
                                  max_profundidad,
                                  cant_ele_inicial,
                                  segmentos);
            endif

        endfor

    endif

endfunction


function [ H ] = hijos(E, idx_mod, segmentos)

    cabecera = [E.cabecera(2), E.cabecera(2) * idx_mod, E.cabecera(3)+1];

    % p7 -- p6 -- p5
    % ||    ||    ||
    % p8 -- p9 -- p4
    % ||    ||    ||
    % p1 -- p2 -- p3

    %Calculamos hijos

    p1 = E.puntos(1, :);
    p3 = E.puntos(2, :);  
    p5 = E.puntos(3, :);
    p7 = E.puntos(4, :);

    p2 = [ (p1(1)+p3(1))/2 , p1(2) ];
    p4 = [ p3(1), (p1(2)+p7(2))/2 ];
    p6 = [ (p1(1)+p3(1))/2 , p5(2) ];
    p8 = [ p1(1) , p4(2) ];
    p9 = [ p2(1) , p4(2) ];

    vecinos = []; %@TODO funcion que calcula vecinos

    E1 = struct('cabecera', cabecera + [0 1 0],
                'puntos', [p1 ; p2 ; p9 ; p8],
                'matriz_intersecciones', []);%,
                %'vecinos', vecinos);

    E2 = struct('cabecera', cabecera + [0 2 0],
                'puntos', [p2 ; p3 ; p4 ; p9],
                'matriz_intersecciones', []);%,
                %'vecinos', vecinos);

    E3 = struct('cabecera', cabecera + [0 3 0],
                'puntos', [p9 ; p4 ; p5 ; p6],
                'matriz_intersecciones', []);%,
                %'vecinos', vecinos);

    E4 = struct('cabecera', cabecera + [0 4 0],
                'puntos', [p8 ; p9 ; p6 ; p7],
                'matriz_intersecciones', []);%,
                %'vecinos', vecinos);

    H = { E1 , E2, E3, E4 };

    H = actualizar_intersecciones(H, E.matriz_intersecciones, segmentos);

    return;

endfunction


% MIP = Matriz Intersecciones Padre
function [H] = actualizar_intersecciones(H, MIP, segmentos)

    % La unica optimizacion seria heredar solo los segmentos padres
    for k = 1 : 4

        if (!isempty(MIP))

        H{k}.matriz_intersecciones = [
            H{k}.matriz_intersecciones ;
            segmentos_en_elemento(H{k}, segmentos(unique(MIP(:,1)),:));
        ];

        endif

    endfor

    %%%% COMENTADO TODO ABAJO. BORRAR CUANDO SE DESEE

#{

    global TOL; 

    puntos_en_cruz = [
        H{1}.puntos(2,:) ;
        H{3}.puntos(2,:) ;
        H{3}.puntos(4,:) ;
        H{1}.puntos(4,:) ];
        
    elemento_ganador = [ 1 2 ; 2 3 ; 4 3 ; 1 4 ];

    idx_segmentos_sin_calcular = [];

    % Las pos son siempre las mismas
    pos_inter_aristas = [6 10 14 18];

    % Calcular Intersecciones Aristas Exteriores
    for i = 1 : size(MIP,1)

        % Si es un segmento interior.
        if (sum(MIP(i, 2:5)) == 0 )

            idx_segmentos_sin_calcular = [ idx_segmentos_sin_calcular , MIP(i,1) ];
        
        else % Si es un segmento que intersecta

            % Igual agrego los segmentos para trabajar con ellos mas tarde y analizar las aristas interiores
            idx_segmentos_sin_calcular = [ idx_segmentos_sin_calcular , MIP(i,1) ];

            for j = 2:5 % Recorremos Aristas

                pos = pos_inter_aristas(j - 1); % vincula intersecciones de la arista j

                if (MIP(i, j) == 1) %Interseccion simple

                    % Va a depender de la orientacion, 1 o 2 => x o y
                    x_y = mod(j, 2) + 1;
                    
                    pto_inter = [ MIP(i, pos) , MIP(i, pos + 1) ];

                    % Si esta del lado menor coord... (puede estar en ambos)
                    if (pto_inter(x_y) <= puntos_en_cruz(j-1, x_y) + TOL)
                        
                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif
                    
                    % Si esta del lado mayor coord... (puede estar en ambos)
                    if (pto_inter(x_y) >= puntos_en_cruz(j-1, x_y) - TOL)

                        H{elemento_ganador(j - 1, 2)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 2)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif

                elseif (MIP(i,j) == 2) %Interseccion Coincidente
                    %% @TODO se puede optimizar reduciendo el numero de casos
                    
                    % Va a depender de la orientacion, 1 o 2 => x o y
                    x_y = mod(j,2) + 1;
                    
                    pto_inter_1 = [ MIP(i, pos) , MIP(i, pos + 1) ];
                    pto_inter_2 = [ MIP(i, pos + 2) , MIP(i, pos + 3) ];

                    % Si estan ambos extremos del lado menor... (puede estar en ambos)
                    if (pto_inter_1(x_y) <= (puntos_en_cruz(j-1, x_y) + TOL) &&
                        pto_inter_2(x_y) <= (puntos_en_cruz(j-1, x_y) + TOL) )

                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif
                    
                    % Si ambos extremos estan del lado mayor... (puede estar en ambos)
                    if (pto_inter(x_y) >= (puntos_en_cruz(j-1, x_y) - TOL) &&
                        pto_inter(x_y) >= (puntos_en_cruz(j-1, x_y) - TOL))

                        H{elemento_ganador(j - 1, 2)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 2)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];

                    endif

                    % Si los extremos estan en distintos lados
                    if ( (pto_inter_1(x_y) - puntos_en_cruz(j-1, x_y)) * 
                         (pto_inter_2(x_y) - puntos_en_cruz(j-1, x_y)) < 0) 

                        nuevo_MIP = MIP(i, :);
                        
                        if (pto_inter_1(x_y)  >= puntos_en_cruz(j-1, x_y))
                            nuevo_MIP(pos:pos+1) = [
                                max(nuevo_MIP(pos), puntos_en_cruz(j-1, x_y)),
                                max(nuevo_MIP(pos+1), puntos_en_cruz(j-1, x_y)),
                            ];
                        else
                            nuevo_MIP(pos:pos+1) = [
                                min(nuevo_MIP(pos), puntos_en_cruz(j-1, x_y)),
                                min(nuevo_MIP(pos+1), puntos_en_cruz(j-1, x_y)),
                            ];
                        endif

                        
                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            nuevo_MIP
                        ];
                        
                    endif

                endif

            endfor


        end
        
    endfor
    
    % Calcular Intersecciones Aristas Interiores
    aristas_interiores = [ 0 1 1 0 ; 0 0 1 1 ; 1 0 0 1 ; 1 1 0 0 ];

    % Recorre cada uno de los elementos apendando las matrices de intersecciones
    % de aquellos segmentos que eran 'interiores'
    for k = 1 : 4

        H{k}.matriz_intersecciones = [
            H{k}.matriz_intersecciones ;
            segmentos_en_elemento(H{k},
                                  segmentos(unique(idx_segmentos_sin_calcular), :),
                                  aristas_interiores(k, :));
        ];
        
    endfor


#}

endfunction
