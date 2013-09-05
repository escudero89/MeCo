## Copyright (C) 2013 Marcos
## 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## conduccionCalor_estacionario_2d

## Author: Marcos <marcos@marcosNetbook>
## Created: 2013-09-04

function [ phi ] = conduccionCalor_estacionario_2d (cant_x, cant_y, Lx, Ly, Q, k)

    ## Obtencion de variables
    dx = Lx / (cant_x - 1);
    dy = Ly / (cant_y - 1);

    phi = zeros(cant_x * cant_y, 1);
    f =  phi;
    K = eye( length(phi) );
    
    ## Definimos direccion de etiquetado de nodos
    if(cant_x > cant_y)
        ir_dir_y = true;
        cant_nodo_en_dir = cant_y;
    else
        ir_dir_y = false;
        cant_nodo_en_dir = cant_x;
    endif
    
    # Posicion actual en la malla (como vector)
    pos_en_malla = 1;
    
    # Salteo los nodos del borde
    pos_en_malla += cant_nodo_en_dir + 1;
    
    # Generamos un vector que nos dice si un nodo es interior (1), o de borde (0)
    es_interior = zeros(length(phi), 1);
    
    # Hasta length(phi) - cant_nodo_en_dir porque salteamos la ultima parte que son nodos de borde.
    for pos = pos_en_malla : length(phi) - cant_nodo_en_dir
        
        if (mod(pos, cant_nodo_en_dir) > 1)
            es_interior(pos) = 1;
        endif
            
    endfor
    
    
    # Armamos la matriz k diagonal en bordes.
    for i = 1 : length(es_interior)
        
        # Si hay un 1, es porque es un nodo interior: tomamos cartas en el asunto.
        if (es_interior(i))
            
            K(i, i) = -2 * (dx^2 + dy^2) / (dx^2 * dy^2);
            
            K(i, i - 1) = 1 / dy^2;
            K(i, i + 1) = 1 / dy^2;
            
            K(i, i - cant_nodo_en_dir) = 1 / dx^2;
            K(i, i + cant_nodo_en_dir) = 1 / dx^2;
                        
        endif
    end
    
    # Armamos termino independiente.
    x = 0 : dx : Lx;
    y = 0 : dy : Ly;

    f = zeros(length(phi), 1);
    
    i = 1;
    
    while  i < length(phi)
        
        if (es_interior(i))
            
            mod_i = mod(i, cant_nodo_en_dir);
            
            if (mod_i == 0)
                mod_i = cant_nodo_en_dir;
            endif
            
            if(ir_dir_y)
               f(i) = -Q(x(floor(i / cant_nodo_en_dir) + 1), y(mod_i)) / k;
            else
               f(i) = -Q(x(mod_i), y(floor(i / cant_nodo_en_dir) + 1)) / k;
            endif
            
        endif
        
        i++;
  
    endwhile
    
    phi = K \ f;
    
    ## PLOTEO
    
    # Generamos malla
    [ XX , YY ] = meshgrid(x, y);
    
    # Mapeamos punto phi a coordenada x,y
    i = 1;
    PHI = [];
    
    while  i < length(phi)
    
        if (ir_dir_y)
            PHI = [PHI , phi(i : i + cant_nodo_en_dir - 1)];
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
