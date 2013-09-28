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

    Aint_interior = 3 * (dx4 + dy4) + 8 * dx2 * dy2;

    Ax_interior = 6 * dy4 + 8 * ( dx2 * dy2 + dx4 );
    Ay_interior = 6 * dx4 + 8 * ( dx2 * dy2 + dy4 );

    B_interior = 2 * dx2 * dy2;

    Cx_interior = -4 * (dx4 + dx2 * dy2);
    Cy_interior = -4 * (dy4 + dx2 * dy2);

    Dx_interior = -5 * dx4 - 4 * dx2 * dy2;
    Dy_interior = -5 * dy4 - 4 * dx2 * dy2;

    Ex_interior = 14 * dx4 + 4 * dx2 * dy2;
    Ey_interior = 14 * dy4 + 4 * dx2 * dy2;

    alfa_x_interior = 26 * dx4;
    beta_x_interior = 24 * dx4;
    gamma_x_interior = 11 * dx4;
    delta_x_interior = 2 * dx4;

    alfa_y_interior = 26 * dy4;
    beta_y_interior = 24 * dy4;
    gamma_y_interior = 11 * dy4;
    delta_y_interior = 2 * dy4;

    %% Definimos direccion de etiquetado de nodos
    if (cant_x > cant_y)
        ir_dir_y = true;
        cant_nodo_en_dir = cant_y;
    else
        ir_dir_y = false;
        cant_nodo_en_dir = cant_x;
    end

    % Generamos un vector que nos dice si un nodo es interior (0), u otro valor si es de borde
    es_interior = zeros(length(phi), 1);

    % Lo armamos como matriz
    ES_INTERIOR = reshape(es_interior, cant_y, cant_x);

    % Bordes en orden antihorario
    borde = [1 2 3 4];

    % Constante de esquina
    ESQ = 20;

    % Llenamos los bordes exteriores
    ES_INTERIOR(begin, :) = -borde(3);
    ES_INTERIOR(:, begin) = -borde(4);
    ES_INTERIOR(:, end) = -borde(2);
    ES_INTERIOR(end, :) = -borde(1);

    % Y los bordes interiores
    ES_INTERIOR(begin + 1, 2 : cant_x - 1) = borde(3);
    ES_INTERIOR(2 : cant_y - 2, begin + 1) = borde(4);
    ES_INTERIOR(2 : cant_y - 2, end - 1) = borde(2);
    ES_INTERIOR(end - 1, 2 : cant_x - 1) = borde(1);


    % Asignamos -21 -22 -23 -24 a los nodos borde-exteriores esquinas en sentido horario.
%    ES_INTERIOR(begin, begin) = -borde(4) * ESQ;
%    ES_INTERIOR(begin, end) = -borde(3) * ESQ;
%    ES_INTERIOR(end, end) = -borde(2) * ESQ;
%    ES_INTERIOR(end, begin) = -borde(1) * ESQ;

    % Asignamos 21, 22, 23, 24 a los nodos borde-interior esquinas en sentido horario
    ES_INTERIOR(begin + 1, begin + 1) = borde(4) * ESQ;
    ES_INTERIOR(begin + 1, end - 1) = borde(3) * ESQ;
    ES_INTERIOR(end - 1, begin + 1) = borde(1) * ESQ;
    ES_INTERIOR(end - 1, end - 1) = borde(2) * ESQ;

    % Asignamos un valor especial a los nodos vecinos a los de las esquinas
%    ES_INTERIOR(begin + 1, begin) = -borde(4) * ESQ * 5;
%    ES_INTERIOR(begin, begin + 1) = -borde(4) * ESQ * 7;
%    
%    ES_INTERIOR(begin + 1, end) = -borde(3) * ESQ * 5;
%    ES_INTERIOR(begin, end - 1) = -borde(3) * ESQ * 7;
%
%    ES_INTERIOR(end - 1, begin) = -borde(1) * ESQ * 5;
%    ES_INTERIOR(end, begin + 1) = -borde(1) * ESQ * 7;
%
%    ES_INTERIOR(end - 1, end) = -borde(2) * ESQ * 5;
%    ES_INTERIOR(end, end - 1) = -borde(2) * ESQ * 7;

    ES_INTERIOR

    % Retornamos a la forma de vector
    es_interior = reshape(ES_INTERIOR, cant_x * cant_y, 1);

    % NOTAR que no es i, j; es j, i los indices, pero para pararse en la matriz es i,j
    for i = 1 : cant_y
        for j = 1 : cant_x

            % Esta matriz la voy a convertir en fila y se la asigno a K
            Z = zeros(cant_y, cant_x);

            % Posicion actual en formato vector
            pos_vec = coord2vec(j, i, ir_dir_y, cant_nodo_en_dir);
            
            f(pos_vec) = (q / D) * dx4 * dy4;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Si hay un 0, es porque es un nodo interior: stencil de 8 puntos.
            if (ES_INTERIOR(i, j) == 0)

                Z(i, j) = A_interior;
            
                Z(i + 1, j + 1) = Z(i + 1, j - 1) = Z(i - 1, j + 1) = Z(i - 1, j - 1) = B_interior;

                Z(i + 2, j) = Z(i - 2, j) = dx4;
                Z(i, j + 2) = Z(i, j - 2) = dy4;

                Z(i + 1, j) = Z(i - 1, j) = Cx_interior;
                Z(i, j + 1) = Z(i, j - 1) = Cy_interior;

            % Si hay un 1,2,3,4 es porque es un nodo de borde INTERIOR (excluida esquinas)
            elseif (sum(ES_INTERIOR(i, j) == borde)),

                current_border = abs(ES_INTERIOR(i, j));
                current_cc = cond_contorno(current_border);

                % Siempre se cumple            
                Z(i + 1, j + 1) = Z(i + 1, j - 1) = Z(i - 1, j + 1) = Z(i - 1, j - 1) = B_interior;

                % Para cada tipo de borde interior, tengo una formula diferente
                switch(current_border)
                    % Borde inferior
                    case {1}

                        Z(i - 2, j) = dx4;
                        Z(i, j + 2) = Z(i, j - 2) = dy4;

                        Z(i, j + 1) = Z(i, j - 1) = Cy_interior;
                        Z(i + 1, j) = Cx_interior;
                        
                        Z(i - 1, j) = Dx_interior; % <=

                        % Aca no mas cambia si tenemos simple o empotrado
                        if (current_cc == 0) % Simple
                            Z(i, j) = Ax_interior;
                            f(pos_vec) += -1 * dx4 * dy2 * valor_cc_1(i);

                        elseif (current_cc == 1) % Empotrado
                            Z(i, j) = A_interior;
                            f(pos_vec) += -2 * dx4 * dy * valor_cc_1(i);

                        else
                            error('No se ha programado para esta cc');
                        end

                    % Borde derecha
                    case {2}

                        Z(i, j - 2) = dy4;
                        Z(i + 2, j) = Z(i - 2, j) = dx4;

                        Z(i, j + 1) = Cy_interior;
                        Z(i + 1, j) = Z(i - 1, j) = Cx_interior;
                        
                        Z(i, j - 1) = Dy_interior; % <=

                        % Aca no mas cambia si tenemos simple o empotrado
                        if (current_cc == 0) % Simple
                            Z(i, j) = Ay_interior;
                            f(pos_vec) += -1 * dy4 * dx2 * valor_cc_2(j);

                        elseif (current_cc == 1) % Empotrado
                            Z(i, j) = A_interior;
                            f(pos_vec) += -2 * dy4 * dx * valor_cc_2(j);

                        else
                            error('No se ha programado para esta cc');
                        end

                    % Borde superior
                    case {3}

                        Z(i + 2, j) = dx4;
                        Z(i, j + 2) = Z(i, j - 2) = dy4;

                        Z(i, j + 1) = Z(i, j - 1) = Cy_interior;
                        Z(i - 1, j) = Cx_interior;
                        
                        Z(i + 1, j) = Dx_interior; % <=

                        % Aca no mas cambia si tenemos simple o empotrado
                        if (current_cc == 0) % Simple
                            Z(i, j) = Ax_interior;
                            f(pos_vec) += -1 * dx4 * dy2 * valor_cc_3(i);

                        elseif (current_cc == 1) % Empotrado
                            Z(i, j) = A_interior;
                            f(pos_vec) += -2 * dx4 * dy * valor_cc_3(i);

                        else
                            error('No se ha programado para esta cc');
                        end

                    % Borde izquierda
                    case {4}
        
                        Z(i, j + 2) = dy4;
                        Z(i + 2, j) = Z(i - 2, j) = dx4;

                        Z(i, j - 1) = Cy_interior;
                        Z(i + 1, j) = Z(i - 1, j) = Cx_interior;
                        
                        Z(i, j + 1) = Dy_interior; % <=

                        % Aca no mas cambia si tenemos simple o empotrado
                        if (current_cc == 0) % Simple
                            Z(i, j) = Ay_interior;
                            f(pos_vec) += -1 * dy4 * dx2 * valor_cc_4(j);

                        elseif (current_cc == 1) % Empotrado
                            Z(i, j) = A_interior;
                            f(pos_vec) += -2 * dy4 * dx * valor_cc_4(j);

                        else
                            error('No se ha programado para esta cc');
                        end

                    otherwise
                        error('Error: valor invalido en switch (borde interior)');
                end

            % Si es mayor que los valores es bordes, es porque es un nodo de esquina borde interior
            elseif (ES_INTERIOR(i, j) > max(borde)),

                current_border = abs(ES_INTERIOR(i, j) / ESQ);
                current_cc = cond_contorno(current_border);

                Z(i, j) = Aint_interior;
                Z(i + 1, j + 1) = Z(i + 1, j - 1) = Z(i - 1, j + 1) = Z(i - 1, j - 1) = B_interior;

                switch (current_border)
                    % esquina |_
                    case {1}

                        Z(i + 1, j) = -2 * B_interior;
                        Z(i, j - 1) = -2 * B_interior;

                        Z(i, j + 1) = -Ey_interior;
                        Z(i - 1, j) = -Ex_interior;

                        Z(i, j + 2) = alfa_y_interior;
                        Z(i, j + 3) = -beta_y_interior;
                        Z(i, j + 4) = gamma_y_interior;
                        Z(i, j + 5) = -delta_y_interior;

                        Z(i - 2, j) = alfa_x_interior;
                        Z(i - 3, j) = -beta_x_interior;
                        Z(i - 4, j) = gamma_x_interior;
                        Z(i - 5, j) = -delta_x_interior;

                    % esquina _|
                    case {2}

                        Z(i + 1, j) = -2 * B_interior;
                        Z(i, j + 1) = -2 * B_interior;

                        Z(i, j - 1) = -Ey_interior;
                        Z(i - 1, j) = -Ex_interior;

                        Z(i, j - 2) = alfa_y_interior;
                        Z(i, j - 3) = -beta_y_interior;
                        Z(i, j - 4) = gamma_y_interior;
                        Z(i, j - 5) = -delta_y_interior;

                        Z(i - 2, j) = alfa_x_interior;
                        Z(i - 3, j) = -beta_x_interior;
                        Z(i - 4, j) = gamma_x_interior;
                        Z(i - 5, j) = -delta_x_interior;
                    
                    % esquina ^|
                    case {3}

                        Z(i - 1, j) = -2 * B_interior;
                        Z(i, j + 1) = -2 * B_interior;

                        Z(i, j - 1) = -Ey_interior;
                        Z(i + 1, j) = -Ex_interior;

                        Z(i, j - 2) = alfa_y_interior;
                        Z(i, j - 3) = -beta_y_interior;
                        Z(i, j - 4) = gamma_y_interior;
                        Z(i, j - 5) = -delta_y_interior;

                        Z(i + 2, j) = alfa_x_interior;
                        Z(i + 3, j) = -beta_x_interior;
                        Z(i + 4, j) = gamma_x_interior;
                        Z(i + 5, j) = -delta_x_interior;
                    
                    % esquina |^
                    case {4}

                        Z(i - 1, j) = -2 * B_interior;
                        Z(i, j - 1) = -2 * B_interior;

                        Z(i, j + 1) = -Ey_interior;
                        Z(i + 1, j) = -Ex_interior;

                        Z(i, j + 2) = alfa_y_interior;
                        Z(i, j + 3) = -beta_y_interior;
                        Z(i, j + 4) = gamma_y_interior;
                        Z(i, j + 5) = -delta_y_interior;

                        Z(i + 2, j) = alfa_x_interior;
                        Z(i + 3, j) = -beta_x_interior;
                        Z(i + 4, j) = gamma_x_interior;
                        Z(i + 5, j) = -delta_x_interior;

                    otherwise
                        error('Error: valor invalido en switch (nodo borde interior)');
                end

            % Si hay un -1,-2,-3,-4 es porque es un nodo de borde EXTERIOR (excluida esquinas)
            elseif (sum(ES_INTERIOR(i, j) == -borde)),
                
                current_border = abs(ES_INTERIOR(i, j));
                current_cc = cond_contorno(current_border);

                % Me fijo que condicion de contorno tiene (simple y empotrado comparten u_borde=0)
                if (current_cc == 0 || current_cc == 1),
                    
                    Z(i, j) = 1;

                    switch (current_border)
                        case {1}
                            f(pos_vec) = valor_cc_1(i);
                        case {2}
                            f(pos_vec) = valor_cc_2(j);
                        case {3}
                            f(pos_vec) = valor_cc_3(i);
                        case {4}
                            f(pos_vec) = valor_cc_4(j);
                        otherwise
                            error('Error: valor invalido en switch (borde exterior)');
                    end

                end

            end

            % Si avanzamos en x, lo transponemos (el reshape es por columnas)
            if (!ir_dir_y)
                Z = Z';
            end

            % Reshape a vector
            Z_vec = reshape(Z, 1, cant_x * cant_y);    
            
            % Y lo guardamos en la matriz en su respectiva fila
            K(pos_vec, :) = Z_vec;
            
        end
    end

    [K f]
    
    K_vec = reshape(K(es_interior==1,:)(1, :), cant_y, cant_x);

    phi = K \ f;
    
    %% PLOTEO
    
    % Generamos malla
    [ XX , YY ] = meshgrid(x, y);
    
    % Mapeamos punto phi a coordenada x,y
    i = 1;
    PHI = [];
    
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
    
end


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

end