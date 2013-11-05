1;

function [ M ] = generar_malla(x,y, objeto)

    cant_x = length(x);
    cant_y = length(y);

    
    for j = 1:cant_y - 1
        for i = 1 : cant_x - 1
           
            
            idx = i + (j - 1) * cant_x;
            
            P1 = [x(i), y(j)];
            P2 = [x(i+1), y(j)];
            P3 = [x(i+1), y(j+1)];
            P4 = [x(i), y(j+1)];            
            
            # Creamos Elemento [idx_padre, idx_elemento, profundidad]
             E = struct("cabecera", [0, idx, 0],
                        "puntos", [P1 ; P2 ; P3 ; P4],
                        "interseccion_idx", []);
            
            # Guardamos el Elemento en la malla
            M{i,j} = E;
           
        
        # Asignamos los puntos de la figura a los Elementos Correspondientes
    %    [E idx_figura] = mapear_puntos(E, figura, idx_figura, tol);
        
            
        endfor
    endfor


endfunction


tic
generar_malla([-1:0.02:1], [-1:0.02:1], 3);
toc
