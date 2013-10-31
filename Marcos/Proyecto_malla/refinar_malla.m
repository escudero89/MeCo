function M = refinar_malla(figura, malla_x, malla_y, lim_subd = 1, tol = 0)
  
  # Defino un vector de indices para acceder a los puntos de figura
  idx_figura = 1:length(figura.x);
  
  # Transformamos Malla en arbol de elementos.
  for( i = 1 : length(malla_x) - 1 )
    for( j = 1 : length(malla_y) - 1 )    
        
        # Creamos Elemento
        E = Elemento([
        malla_x(i), malla_y(j)
        malla_x(i), malla_y(j+1)
        malla_x(i+1), malla_y(j+1)
        malla_x(i+1), malla_y(j)
        ]);
        
        # Asignamos los puntos de la figura a los Elementos Correspondientes
        [E idx_figura] = mapear_puntos(E, figura, idx_figura, tol);
        
        # Guardamos el Elemento en la malla
        M{i,j} = E;
        
      endfor
  endfor
 
# Ploteo inicial. 
#  plot(figura.x, figura.y, 'dr');
#  plot(M);
#  hold on;
#  plot_malla(M,1);
#  hold off;
    
  
  # Recorro la malla M para buscar elementos a subdividir.
  for( j = 1 : size(M)(2) )
    for( i = 1 : size(M)(1) )  
      
      %if( hay_interseccion(M{i,j}, M{i,j}(5), figura) )
      if(M{i,j}(5)) % Si hay interseccion
      
        M{i,j} = subdividir(M{i,j}, figura, 1, lim_subd, tol);
        
      endif
     
    endfor
  endfor

endfunction


# Subdivide recursivamente en elemento hasta sub_max.
function M = subdividir(E, figura, sub_actual, sub_max, tol)
  M = {};
  
  if(sub_actual == sub_max)
    
    M = hijos(E, figura, tol); # hijos devuelve {cell}
  
  else

    H = hijos(E, figura, tol);
  
    for(j = 1:size(H)(2) )
      for(i = 1:size(H)(1))
      
      %if( hay_interseccion(H{i,j}, figura) )
      
      if( H{i,j}(5) ) % si hay interseccion
        H{i,j} = subdividir(H{i,j}, figura, sub_actual + 1, sub_max, tol);
      endif

      endfor
    endfor
    
    M = H;
    
  endif
  
endfunction

# Dado un Elemento E, devuelve sus 4 hijos.
function M = hijos(E, figura, tol)
  #Calculamos hijos
  p1 = E(1);
  p3 = E(2);  
  p5 = E(3);
  p7 = E(4);
  
  p2 = [E(1,1), (E(2,2)+E(1,2))/2];
  p4 = [(E(3,1)+E(2,1))/2, E(2,2)];
  p6 = [E(3,1), (E(3,2)+E(4,2))/2];
  p8 = [(E(4,1)+E(1,1))/2, E(4,2)];
  
  p9 = [(E(3,1)+E(2,1))/2, (E(2,2)+E(1,2))/2];
  
  M{1,1} = Elemento([p1; p2; p9; p8]);
  M{1,2} = Elemento([p2; p3; p4; p9]);
  M{2,2} = Elemento([p9; p4; p5; p6]);
  M{2,1} = Elemento([p8; p9; p6; p7]);
  
  idx_figura = E(5);
  
  # Calculamos intersecciones
  [M{1,1} idx_figura] = mapear_puntos(M{1,1}, figura, idx_figura, tol);
  [M{1,2} idx_figura] = mapear_puntos(M{1,2}, figura, idx_figura, tol);
  [M{2,1} idx_figura] = mapear_puntos(M{2,1}, figura, idx_figura, tol);
  [M{2,2} idx_figura] = mapear_puntos(M{2,2}, figura, idx_figura, tol);
  
endfunction

# Dado un elemento y una figura (lista de puntos) me 
# devuelve el mismo elemento pero con los puntos de la figura
# que caigan dentro del elemento referenciados en el mismo.
function [E idx_figura_actualizado] = mapear_puntos(E, figura, idx_figura, tol = 0.001)
  
  x_min = E(1,1);
  y_min = E(1,2);
  x_max = E(3,1);
  y_max = E(3,2);
  
  puntos_dentro_de_elemento = [];
  idx_figura_actualizado =[];
  
  for(i = idx_figura)
    
    # Si estan en la zona difusa, pregunto en que parte de la misma...
    if(     figura.x(i) > (x_min - tol) &&
            figura.x(i) < (x_max + tol) && 
            figura.y(i) > (y_min - tol) &&
            figura.y(i) < (y_max + tol) )
        
        # Si estan claramente dentro del elemento
        if(figura.x(i) > x_min &&
            figura.x(i) < x_max && 
            figura.y(i) > y_min &&
            figura.y(i) < y_max)
            
            # Agrego el punto SOLAMENTE al elemento.
            puntos_dentro_de_elemento = [puntos_dentro_de_elemento i];

        else  # Si NO estan claramente dentro del elemento
            
            # Agrego el punto al elemento y a la lista para seguir comparando.
            puntos_dentro_de_elemento = [puntos_dentro_de_elemento i];
            idx_figura_actualizado = [idx_figura_actualizado i];

        endif
      
    else # Si estan lejos del elemento
      
      # Agrego el punto a la lista de seguir buscando.
      idx_figura_actualizado = [idx_figura_actualizado i];
      
    endif
  
  endfor
  
  E(5) = puntos_dentro_de_elemento;
   
endfunction

