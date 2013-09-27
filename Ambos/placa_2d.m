%% Copyright (C) 2013 Marcos
%% 
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2 of the License, or
%% (at your option) any later version.
%% 
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License
%% along with Octave; see the file COPYING.  If not, see
%% <http://www.gnu.org/licenses/>.

%% conduccionCalor_estacionario_2d

%% Author: Marcos <marcos@marcosNetbook> y Cristian tambien che :(
%% Created: 2013-09-04

function [ phi ] = placa_2d (
    cant_x,         % Cantidad de nodos en x
    cant_y,         % Cantidad de nodos en y
    Lx,             % Tamanho del rectangulo en el eje x
    Ly,             % Tamanho del rectangulo en el eje y
    q,              % Carga distribuida
    D,              % Rigidez a la flexion
    cond_contorno,  % Un array que indica si estamos ante soporte simple (0), empotrado (1), libre (2).
    valor_cc_1,         
    valor_cc_2,
    valor_cc_3,
    valor_cc_4
    )

    begin = 1;

    %% Obtencion de variables
    dx = Lx / (cant_x - 1);
    dy = Ly / (cant_y - 1);
    
    dx2 = dx^2;
    dx4 = dx^4
    
    dy2 = dy^2;
    dy4 = dy^4

    phi = zeros(cant_x * cant_y, 1);
    f =  phi;
    K = eye( length(phi) );
    
    x = 0 : dx : Lx;
    y = 0 : dy : Ly;
    
    %% PARA OPTIMIZAR el calculo de nodos interiores

    A_interior = 6 * (dy4 + dx4) + 8 * dx2 * dy2;
    B_interior = 2 * dx2 * dy2;
    Cx_interior = -4 * (dx4 + dx2 * dy2);
    Cy_interior = -4 * (dy4 + dx2 * dy2);

    %% Definimos direccion de etiquetado de nodos
    if (cant_x > cant_y)
        ir_dir_y = true;
        cant_nodo_en_dir = cant_y;
    else
        ir_dir_y = false;
        cant_nodo_en_dir = cant_x;
    end

    % Generamos un vector que nos dice si un nodo es interior (1), o de borde ext (-1) o int(0)
    es_interior = ones(length(phi), 1);

    % Lo armamos como matriz
    ES_INTERIOR = reshape(es_interior, cant_y, cant_x)

    % Llenamos los bordes exteriores
    ES_INTERIOR(begin, :) = -1;
    ES_INTERIOR(:, begin) = -1;
    ES_INTERIOR(:, end) = -1;
    ES_INTERIOR(end, :) = -1;

    % Y los bordes interiores
    ES_INTERIOR(begin + 1, 2 : cant_x - 1) = 0;
    ES_INTERIOR(2 : cant_y - 2, begin + 1) = 0;
    ES_INTERIOR(2 : cant_y - 2, end - 1) = 0;
    ES_INTERIOR(end - 1, 2 : cant_x - 1) = 0;

    % Esquinas en orden antihorario
    esquina = [21 22 23 24];

    % Asignamos -21 -22 -23 -24 a los nodos borde-exteriores esquinas en sentido horario.
    ES_INTERIOR(begin, begin) = -esquina(4);
    ES_INTERIOR(begin, end) = -esquina(3);
    ES_INTERIOR(end, end) = -esquina(2);
    ES_INTERIOR(end, begin) = -esquina(1);

    % Asignamos 21, 22, 23, 24 a los nodos borde-interior esquinas en sentido horario
    ES_INTERIOR(begin + 1, begin + 1) = esquina(4);
    ES_INTERIOR(begin + 1, end - 1) = esquina(3);
    ES_INTERIOR(end - 1, begin + 1) = esquina(1);
    ES_INTERIOR(end - 1, end - 1) = esquina(2);

    % Asignamos un valor especial a los nodos vecinos a los de las esquinas
    ES_INTERIOR(begin + 1, begin) = -esquina(4) * 5;
    ES_INTERIOR(begin, begin + 1) = -esquina(4) * 7;
    
    ES_INTERIOR(begin + 1, end) = -esquina(3) * 5;
    ES_INTERIOR(begin, end - 1) = -esquina(3) * 7;

    ES_INTERIOR(end - 1, begin) = -esquina(1) * 5;
    ES_INTERIOR(end, begin + 1) = -esquina(1) * 7;

    ES_INTERIOR(end - 1, end) = -esquina(2) * 5;
    ES_INTERIOR(end, end - 1) = -esquina(2) * 7;

    ES_INTERIOR

    % Retornamos a la forma de vector
    es_interior = reshape(ES_INTERIOR, cant_x * cant_y, 1);

    % NOTAR que no es i, j; es j, i los indices, pero para pararse en la matriz es i,j
    for i = 1 : cant_y
        for j = 1 : cant_x

            % Posicion actual en formato vector
            pos_vec = coord2vec(j, i, ir_dir_y, cant_nodo_en_dir);
            
            f(pos_vec) = q * D;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Si hay un 1, es porque es un nodo interior: stencil de 8 puntos.
            if (ES_INTERIOR(i, j) == 1)

                % Esta matriz la voy a convertir en fila y se la asigno a K
                Z = zeros(cant_y, cant_x);

                Z(i, j) = A_interior;
            
                Z(i + 1, j + 1) = Z(i + 1, j - 1) = Z(i - 1, j + 1) = Z(i - 1, j - 1) = B_interior;

                Z(i + 2, j) = Z(i - 2, j) = dy4;
                Z(i, j + 2) = Z(i, j - 2) = dx4;

                Z(i + 1, j) = Z(i - 1, j) = Cy_interior;
                Z(i, j + 1) = Z(i, j - 1) = Cx_interior;

                % Si avanzamos en x, lo transponemos (el reshape es por columnas)
                if (!ir_dir_y)
                    Z = Z'
                end

                % Reshape a vector
                Z_vec = reshape(Z, 1, cant_x * cant_y);    
                
                % Y lo guardamos en la matriz en su respectiva fila
                K(pos_vec, :) = Z_vec;

            end

        end
    end
    K
reshape(K(es_interior==1,:)(1, :), cant_y, cant_x)
return;


    % Cambiamos dx2 dy2 dependiendo de la direccion y lo traajamos en forma
    % transparente con da db
    if(ir_dir_y)
        da2 = dy2;
        db2 = dx2;
        signo = 1;
    else
        da2 = dx2;
        db2 = dy2;
        signo = -1;
    endif
    
    % Armamos la matriz k diagonal en bordes.
    for i = 1 : length(es_interior)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Si hay un 1, es porque es un nodo interior: tomamos cartas en el asunto.
        if (es_interior(i) == 1)
            
            K(i, i) = C / k - 2 * (db2 + da2) / (db2 * da2);
            
            K(i, i - 1) = 1 / da2;
            K(i, i + 1) = 1 / da2;
            
            K(i, i - cant_nodo_en_dir) = 1 / db2;
            K(i, i + cant_nodo_en_dir) = 1 / db2;
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
        %Si es mayor a 20 es xq es una esquina                
        elseif ( es_interior(i) > 20 ) 
        
            K(i, i) = C / k + 2 * (dx2 + dy2) / (dx2 * dy2);
            
            if( es_interior(i) == 21 )
                
                K(i, i + 1) = -5/da2;
                K(i, i + 2) = 4/da2;
                K(i, i + 3) = -1/da2;
                
                K(i, i + 1*cant_nodo_en_dir) = -5/db2;
                K(i, i + 2*cant_nodo_en_dir) = 4/db2;
                K(i, i + 3*cant_nodo_en_dir) = -1/db2;
                    
            elseif ( es_interior(i) == 22 )
                
                K(i, i - signo * 1) = -5/da2;
                K(i, i - signo * 2) = 4/da2;
                K(i, i - signo * 3) = -1/da2;
                
                K(i, i + signo * 1 * cant_nodo_en_dir) = -5/db2;
                K(i, i + signo * 2 * cant_nodo_en_dir) = 4/db2;
                K(i, i + signo * 3 * cant_nodo_en_dir) = -1/db2;
                    
            elseif ( es_interior(i) == 23 )
                
                K(i, i - 1) = -5/da2;
                K(i, i - 2) = 4/da2;
                K(i, i - 3) = -1/da2;
                
                K(i, i - 1 * cant_nodo_en_dir) = -5/db2;
                K(i, i - 2 * cant_nodo_en_dir) = 4/db2;
                K(i, i - 3 * cant_nodo_en_dir) = -1/db2;
                    
            elseif ( es_interior(i) == 24 )

                K(i, i + signo * 1) = -5/da2;
                K(i, i + signo * 2) = 4/da2;
                K(i, i + signo * 3) = -1/da2;

                K(i, i - signo * 1 * cant_nodo_en_dir) = -5/db2;
                K(i, i - signo * 2 * cant_nodo_en_dir) = 4/db2;
                K(i, i - signo * 3 * cant_nodo_en_dir) = -1/db2;
                    
            endif
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Nodo de borde (es_interior es 0). cond_contorno = 0 dirichlet , 1 neumann
        else
        
            % El vector idx se utiliza para numerar los distintos contornos dependiendo de la direccion.
            idx = [11 14 12 13];
            
            if (ir_dir_y == 0)
            
                idx = [ 14 11 13 12 ];
            
            endif
            
            if (i < cant_nodo_en_dir) %% Borde 1 o 4
            
                es_interior(i) = idx(1);
            
            elseif (i < length(phi) - cant_nodo_en_dir + 1)
                
                es_interior(i) = idx(3 - mod(i, cant_nodo_en_dir));
            
            else 
            
                es_interior(i) = idx(4);
            
            endif
                
        endif
             
    endfor

    i = 1;

    while i < length(phi)

        [l, m] = vec2coord(i, ir_dir_y, cant_nodo_en_dir)

        % Si es nodo interior o de esquina
        if (es_interior(i) == 1 || es_interior(i) > 20)
                        
                f(i) = 1 / k * (C * phi_amb) - Q(x(l), y(m)) / k;

        % nodo de borde no esquina
        else

            K(i,i) = C/k - 2 * (dx2 + dy2)/(dx2 * dy2); %igual para todos los bordes
            f(i) = -Q(x(l), y(m)) / k;
              
            if(es_interior(i) == 11)
                % Si es 1, es neumann
                if (cond_contorno(1))
                        
                    K(i, coord2vec(l+1, m, ir_dir_y, cant_nodo_en_dir) ) = 2/dx2;
                    K(i, coord2vec(l, m+1, ir_dir_y, cant_nodo_en_dir) ) = 1/dy2;
                    K(i, coord2vec(l, m-1, ir_dir_y, cant_nodo_en_dir) ) = 1/dy2;

                    f(i) += 1/k * (C * phi_amb - 2 * valor_cc_1(m) / dx);
                
                else % Dirichlet
                
                    K(i, i) = 1;
                    f(i) = valor_cc_1(m);
                
                endif
    
            elseif(es_interior(i) == 12)
            
                if (cond_contorno(2))
                
                    K(i, coord2vec(l, m-1, ir_dir_y, cant_nodo_en_dir) ) = 2/dy2;
                    K(i, coord2vec(l+1, m, ir_dir_y, cant_nodo_en_dir) ) = 1/dx2;
                    K(i, coord2vec(l-1, m, ir_dir_y, cant_nodo_en_dir) ) = 1/dx2;

                    f(i) += 1/k * (C * phi_amb + 2 * valor_cc_2(l) / dy);
            
                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_2(l);
                
                endif
                
            elseif(es_interior(i) == 13)
                
                if (cond_contorno(3))
                
                    K(i, coord2vec(l-1, m, ir_dir_y, cant_nodo_en_dir) ) = 2/dx2;
                    K(i, coord2vec(l, m+1, ir_dir_y, cant_nodo_en_dir) ) = 1/dy2;
                    K(i, coord2vec(l, m-1, ir_dir_y, cant_nodo_en_dir) ) = 1/dy2;

                    f(i) += 1/k * (C * phi_amb + 2 * valor_cc_3(m) / dx);
                    
                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_3(m);
                
                endif
                       
            elseif(es_interior(i) == 14)
         
                if (cond_contorno(4))
                
                    K(i, coord2vec(l, m+1, ir_dir_y, cant_nodo_en_dir) ) = 2/dy2;
                    K(i, coord2vec(l+1, m, ir_dir_y, cant_nodo_en_dir) ) = 1/dx2;
                    K(i, coord2vec(l-1, m, ir_dir_y, cant_nodo_en_dir) ) = 1/dx2;
                    
                    f(i) += 1/k * (C * phi_amb - 2 * valor_cc_4(l) / dy); 

                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_4(l);
                
                endif
                
            endif
           
        endif
        
        i++;
  
    endwhile
    K
    f
    phi = K \ f
    
    %% PLOTEO
    
    % Generamos malla
    [ XX , YY ] = meshgrid(x, y);
    
    % Mapeamos punto phi a coordenada x,y
    i = 1;
    PHI = [];
    length(phi)
    while  i < length(phi)
    
        if (ir_dir_y)
            PHI = [PHI , phi(i : i + cant_nodo_en_dir - 1)];
            % PHI = reshape(phi, cant_nodo_en_dir, prod(length(phi) / cant_nodo_en_dir);
        else
            PHI = [PHI ; phi(i : i + cant_nodo_en_dir - 1)'];
        endif
        
        i += cant_nodo_en_dir;
    
    endwhile

    surf(XX, YY, PHI);
    
    xlabel('x');
    ylabel('y');
    zlabel('phi');
    
endfunction


function [pos] = coord2vec( i, j, ir_dir_y, cant_nodo_en_dir)

    if (ir_dir_y)
    
        pos = j + cant_nodo_en_dir * (i - 1);
    
    else
        pos = i + cant_nodo_en_dir * (j - 1);
    
    end

end

function [l, m] = vec2coord(i, ir_dir_y, cant_nodo_en_dir)

    mod_i = mod(i, cant_nodo_en_dir);
        
    if (mod_i == 0)
        mod_i = cant_nodo_en_dir;
    endif

    if(ir_dir_y)
    
        l = ceil(i / cant_nodo_en_dir);
        m = mod_i;
   
    else
    
        l = mod_i;
        m = ceil(i / cant_nodo_en_dir);
   
    endif

endfunction
