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

## conduccion_calor_corona

## Author: Marcos <marcos@marcosNetbook> y Cristian tambien che :(
## Created: 2013-09-04

function [ phi ] = conduccion_calor_corona(
    cant_r,         # Cantidad de nodos radiales
    cant_tita,      # Cantidad de nodos angulares
    r1,             # Tamanho del radio interior
    r2,             # Tamanho del radio exterior
    tita1,          # Tamanho del angulo inicial
    tita2,          # Tamanho del angulo final
    Q,              # Fuente, funcion
    k,              # La conductividad termica
    cond_contorno,  # Un array que indica si estamos ante dirichlet (0) o neumann (1)
    valor_cc_1,     # En borde r=r1 para todo tita
    valor_cc_2,     # En borde tita=tita2 para todo r
    valor_cc_3,     # En borde r=r2 para todo tita    
    valor_cc_4      # En borde tita=tita1 para todo r
    )

    ## Obtencion de variables
    dr = (r2 - r1) / (cant_r - 1);
    dtita = (tita2 - tita1) / (cant_tita - 1);
    
    dr2 = dr^2;
    dtita2 = dtita^2;

    phi = zeros(cant_r * cant_tita, 1);
    f =  phi;
    K = eye( length(phi) );
    
    r = r1 : dr : r2;
    tita = tita1 : dtita : tita2;
            
    ## Definimos direccion de etiquetado de nodos
    if(cant_r > cant_tita)
        ir_dir_tita = true;
        cant_nodo_en_dir = cant_tita;
    else
        ir_dir_tita = false;
        cant_nodo_en_dir = cant_r;
    endif
    
    # Posicion actual en la malla (como vector)
    pos_en_malla = 1;
    
    # Salteo los nodos del borde
    pos_en_malla += cant_nodo_en_dir + 1;
    
    # Generamos un vector que nos dice si un nodo es interior (1), o de borde (0)
    es_interior = zeros(length(phi), 1);
    
    # Hasta length(phi) - cant_nodo_en_dir porque salteamos la ultima parte que son nodos de borde.
    for pos = pos_en_malla : length(phi) - cant_nodo_en_dir - 1
        
        if (mod(pos, cant_nodo_en_dir) > 1)
            es_interior(pos) = 1;
        endif
            
    endfor
    
    # Asignamos 21 22 23 24 a los nodos  esquinas en sentido horario.
    if(ir_dir_tita)
        es_interior(1) = 21;
        es_interior(cant_nodo_en_dir) = 22;
        es_interior(end - cant_nodo_en_dir + 1) = 24;
        es_interior(end) = 23;
    else
        es_interior(1) = 21;
        es_interior(cant_nodo_en_dir) = 24;
        es_interior(end - cant_nodo_en_dir + 1) = 22;
        es_interior(end) = 23;
    
    endif
    # Cambiamos dx2 dy2 dependiendo de la direccion y lo traajamos en forma
    # transparente con da db
    if(ir_dir_tita)
        da2 = dtita2;
        db2 = dr2;
        da = dtita;
        db = dr;
        signo = 1;
        vec_delta = r;
    else
        da2 = dtita2;
        db2 = dr2;
        da = dtita;
        db = dr;
        vec_delta = r;
        
        
        #da2 = dr2;
        #db2 = dtita2;
        #da = dr;
        #db = dtita;
        signo = -1;
        #vec_delta=tita;
    endif
    
    # Armamos la matriz k diagonal en bordes.
    for i = 1 : length(es_interior)

        ###########################################################################
        # Si hay un 1, es porque es un nodo interior: tomamos cartas en el asunto.
        if (es_interior(i) == 1)
            [l m] = vec2coord(i, ir_dir_tita, cant_nodo_en_dir);
            if(1) lm=l; else lm = m; endif 
            delta = vec_delta(lm);
            
            K(i, i) = -4*delta^2*da2-4*db2;
            
            if(ir_dir_tita)
              K(i, i - 1) = 2*db2;
              K(i, i + 1) = 2*db2;
              
              K(i, i - cant_nodo_en_dir) = (2*delta^2-db*delta)*da^2;
              K(i, i + cant_nodo_en_dir) = (2*delta^2+db*delta)*da^2;
            else
              
              K(i, i - cant_nodo_en_dir) = 2*db2;
              K(i, i + cant_nodo_en_dir) = 2*db2;
              
              K(i, i - 1) = (2*delta^2-db*delta)*da^2;
              K(i, i + 1) = (2*delta^2+db*delta)*da^2;
            
            endif
 
        ###########################################################################       
        #Si es mayor a 20 es xq es una esquina                
        elseif ( es_interior(i) > 20 ) 
            [l m] = vec2coord(i, ir_dir_tita, cant_nodo_en_dir);
            if(1) lm=l; else lm = m; endif 
            delta = vec_delta(lm);
            
            # Defino variables los coeficientes y los trabajo
            # de manera transparente
            if(ir_dir_tita)
              tp1_a = 5*dr2;
              tp1_b = 5*dr2;
              
              tp2_a = -4*dr2;
              tp2_b = -4*dr2;
              
              tp3 = dr2;
              
              ts1_a = (5*r(l)^2+2*dr*r(l))*dtita2;
              ts1_b = (5*r(l)^2-2*dr*r(l))*dtita2;
              
              ts2_a = (-4*r(l)^2-dr*r(l))*dtita2;
              ts2_b = (dr*r(l)-4*r(l)^2)*dtita2;
              
              ts3 = r(l)^2*dtita2;
            else
              
              #ts1_a = 5*dtita2;
              #ts1_b = 5*dtita2;
              
              #ts2_a = -4*dtita2;
              #ts2_b = -4*dtita2;
              
              #ts3 = dtita2;
              
              #tp1_a = (5*tita(m)^2+2*dtita*tita(m))*dr2;
              #tp1_b = (5*tita(m)^2-2*dtita*tita(m))*dr2;
              
              #tp2_a = (-4*tita(m)^2-dtita*tita(m))*dr2;
              #tp2_b = (dtita*tita(m)-4*tita(m)^2)*dr2;
              
              #tp3 = tita(m)^2*dr2;
              
              
              ts1_a = 5*dr2;
              ts1_b = 5*dr2;
              
              ts2_a = -4*dr2;
              ts2_b = -4*dr2;
              
              ts3 = dr2;
              
              tp1_a = (5*r(l)^2+2*dr*r(l))*dtita2;
              tp1_b = (5*r(l)^2-2*dr*r(l))*dtita2;
              
              tp2_a = (-4*r(l)^2-dr*r(l))*dtita2;
              tp2_b = (dr*r(l)-4*r(l)^2)*dtita2;
              
              tp3 = r(l)^2*dtita2;
            endif
            
            
            if( es_interior(i) == 21 )
              
              #Termino central de los nodos esquinas
              #K(i, i) = ((-2*r(l)^2-dr*r(l))*dtita2-2*dr2);
              K(i, i) = ((-2*delta^2-db*delta)*da2-2*db2);
              
              K(i, i + 1) = tp1_a;
              K(i, i + 2) = tp2_a;
              K(i, i + 3) = tp3;
              
              K(i, i + 1*cant_nodo_en_dir) = ts1_a;
              K(i, i + 2*cant_nodo_en_dir) = ts2_a;
              K(i, i + 3*cant_nodo_en_dir) = ts3; 
              
            elseif ( es_interior(i) == 22 )
              
                #Termino central de los nodos esquinas
                K(i, i) = ((-2*delta^2-db*delta)*da2-2*db2);
                
                K(i, i - signo * 1) = ts1_a;
                K(i, i - signo * 2) = ts2_a;
                K(i, i - signo * 3) = ts3;
                
                K(i, i + signo * 1 * cant_nodo_en_dir) = tp1_a;
                K(i, i + signo * 2 * cant_nodo_en_dir) = tp2_a;
                K(i, i + signo * 3 * cant_nodo_en_dir) = tp3;
                 
            elseif ( es_interior(i) == 23 )
               
                #Termino central de los nodos esquinas
                K(i, i) = ((db*delta-2*delta^2)*da2-2*db2);
                
                K(i, i - 1) = tp1_b;
                K(i, i - 2) = tp2_b;
                K(i, i - 3) = tp3;
                
                K(i, i - 1 * cant_nodo_en_dir) = ts1_b;
                K(i, i - 2 * cant_nodo_en_dir) = ts2_b;
                K(i, i - 3 * cant_nodo_en_dir) = ts3;
                
            elseif ( es_interior(i) == 24 )
                
                #Termino central de los nodos esquinas
                K(i, i) = ((db*delta-2*delta^2)*da2-2*db2);
            
                K(i, i + signo * 1) = tp1_b;
                K(i, i + signo * 2) = tp2_b;
                K(i, i + signo * 3) = tp3;

                K(i, i - signo * 1 * cant_nodo_en_dir) = ts1_b;
                K(i, i - signo * 2 * cant_nodo_en_dir) = ts2_b;
                K(i, i - signo * 3 * cant_nodo_en_dir) = ts3;
                
            endif
        
        ###########################################################################
        # Nodo de borde (es_interior es 0). cond_contorno = 0 dirichlet , 1 neumann
        else
        
            # El vector idx se utiliza para numerar los distintos contornos dependiendo de la direccion.
            idx = [11 14 12 13];
            
            if (ir_dir_tita == 0)
            
                idx = [ 14 11 13 12 ];
            
            endif
            
            if (i < cant_nodo_en_dir) ## Borde 1 o 4
            
                es_interior(i) = idx(1);
            
            elseif (i < length(phi) - cant_nodo_en_dir + 1)
                
                es_interior(i) = idx(3 - mod(i, cant_nodo_en_dir));
            
            else 
            
                es_interior(i) = idx(4);
            
            endif
                
        endif
             
    endfor

    i = 1;

    while i <= length(phi)

        [l, m] = vec2coord(i, ir_dir_tita, cant_nodo_en_dir);
        if(1) lm=l; else lm = m; endif 
        delta = vec_delta(lm);
        
        # Si es nodo interior o de esquina
        if (es_interior(i) == 1 || es_interior(i) > 20)
         
          if(es_interior(i) == 1)
            # Termino independiente de los nodos interiores
            f(i) = -(2*db2*delta^2*Q(l,m)*da2)/k(l,m);
          
          else
           # Termino independiente de los nodos esquinas
           f(i) = (db2*delta^2*Q(l,m)*da2)/k(l,m); 
           
           endif
           
        # nodo de borde no esquina
        else

            K(i,i) = (-4*delta^2*k(l,m)*da2-4*db2*k(l,m)); #igual para todos los bordes
            
            if(es_interior(i) == 11) # Borde: r=r1,tita
                # Si es 1, es neumann
                if (cond_contorno(1))
                        
                    K(i, coord2vec(l+1, m, ir_dir_tita, cant_nodo_en_dir) ) = 4*delta^2*k(l,m)*da2;
                    K(i, coord2vec(l, m+1, ir_dir_tita, cant_nodo_en_dir) ) = 2*db2*k(l,m);
                    K(i, coord2vec(l, m-1, ir_dir_tita, cant_nodo_en_dir) ) = 2*db2*k(l,m);
                    
                    f(i) = ((db2*delta-2*db*delta^2)*valor_cc_1(m)-2*db2*delta^2*Q(l,m))*da2;
                    
                else # Dirichlet
                
                    K(i, i) = 1;
                    f(i) = valor_cc_1(m);
                
                endif
    
            elseif(es_interior(i) == 12) # Borde: r,tita=tita2
            
                if (cond_contorno(2))
                
                    K(i, coord2vec(l, m-1, ir_dir_tita, cant_nodo_en_dir) ) = 4*db^2*k(l,m);
                    K(i, coord2vec(l+1, m, ir_dir_tita, cant_nodo_en_dir) ) = (2*delta^2+db*delta)*k(l,m)*da2;
                    K(i, coord2vec(l-1, m, ir_dir_tita, cant_nodo_en_dir) ) = (2*delta^2-db*delta)*k(l,m)*da2;

                    f(i) = 2*db2*delta*valor_cc_2(l)*da-2*db2*delta^2*Q(l,m)*da2;
            
                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_2(l);
                
                endif
                
            elseif(es_interior(i) == 13) # Borde: r=r2,tita
                
                if (cond_contorno(3))
                
                    K(i, coord2vec(l-1, m, ir_dir_tita, cant_nodo_en_dir) ) = 4*delta^2*k(l,m)*da2;
                    K(i, coord2vec(l, m+1, ir_dir_tita, cant_nodo_en_dir) ) = 2*db^2*k(l,m);
                    K(i, coord2vec(l, m-1, ir_dir_tita, cant_nodo_en_dir) ) = 2*db^2*k(l,m);

                    f(i) = -(-2*db*delta^2-db^2*delta)*valor_cc_3(l)*da2-2*db^2*delta^2*Q(l,m)*da2;
                    
                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_3(m);
                
                endif
                       
            elseif(es_interior(i) == 14) # Borde: r,tita=tita1
         
                if (cond_contorno(4))
                
                    K(i, coord2vec(l, m+1, ir_dir_tita, cant_nodo_en_dir) ) = 4*db2*k(l,m);
                    K(i, coord2vec(l+1, m, ir_dir_tita, cant_nodo_en_dir) ) = (2*delta^2+db*delta)*k(l,m)*da2;
                    K(i, coord2vec(l-1, m, ir_dir_tita, cant_nodo_en_dir) ) = (2*delta^2-db*delta)*k(l,m)*da2;
                    
                    f(i) += -2*db2*delta^2*Q(l,m)*da2-2*db2*delta*valor_cc_4(l)*da; 

                else
                    
                    K(i, i) = 1;
                    f(i) = valor_cc_4(l);
                
                endif
                
            endif
           
        endif
        
        i++;
  
    endwhile
    
    
    phi = K \ f;
    
    ## PLOTEO
    
    # Transformamos coordenadas polares en cartesianas para
    # poder graficar.
    
      for i = 1 : cant_tita
        for j = 1 : cant_r
        
          X(i,j) = r(j) * cos(tita(i));
          Y(i,j) = r(j) * sin(tita(i));
        
        endfor
      endfor
    
    
    # Mapeamos punto phi a coordenada x,y
    i = 1;
    PHI = [];
    while  i < length(phi)
    
        if (ir_dir_tita)
            PHI = [PHI , phi(i : i + cant_nodo_en_dir - 1)];
            # PHI = reshape(phi, cant_nodo_en_dir, prod(length(phi) / cant_nodo_en_dir);
        else
            PHI = [PHI ; phi(i : i + cant_nodo_en_dir - 1)'];
        endif
        
        i += cant_nodo_en_dir;
    
    endwhile

    plot3(X,Y, PHI);
    hold on;
    plot3(X',Y', PHI');
    hold off;
    
    xlabel('x');
    ylabel('y');
    zlabel('phi');
    
endfunction


function [pos] = coord2vec( i, j, ir_dir_y, cant_nodo_en_dir)

    if(ir_dir_y)
    
        pos = j + cant_nodo_en_dir * (i - 1);
    
    else
        pos = i + cant_nodo_en_dir * (j - 1);
    
    endif

endfunction

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
