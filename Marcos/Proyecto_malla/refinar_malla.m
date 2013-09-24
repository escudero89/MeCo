function M = refinar_malla(figura, malla_x, malla_y, lim_subd = 1, tol = 0)
  
  # Transformamos Malla en arbol de elementos.
#  for( i = 1 : length(malla_x) - 1 )
#    for( j = 1 : length(malla_y) - 1 )
#    
#      M{i,j} = Elemento([
#        malla_x(i), malla_y(j)
#        malla_x(i), malla_y(j+1)
#        malla_x(i+1), malla_y(j+1)
#        malla_x(i+1), malla_y(j)
#        ]);
#      endfor
#  endfor
 

  M = Elemento([-2 -2; -2 2; 2 2; 2 -2]);
  
  
  # Ploteo inicial.
  hold on;
  plot(figura.x, figura.y, 'dr');
  plot(M);
  #plot_malla(M);
  hold off;
  
  # Recorro la malla M para buscar elementos a subdividir.
#  for( j = 1 : size(M)(2) )
#    for( i = 1 : size(M)(1) )  
      
#      if( hay_interseccion(M{i,j}, figura) )
       if(hay_interseccion(M,figura))  
        M = subdividir(M, figura, 1, lim_subd);
        #M{i,j} = subdividir(M{i,j}, figura, 1, lim_subd);
        
      endif
     
#    endfor
#  endfor

endfunction


function C = hay_interseccion(E, figura)
  
  x_min = E(1,1);
  y_min = E(1,2);
  x_max = E(3,1);
  y_max = E(3,2);
  
  C = 0;
  i = 1;
  
  while( i < length(figura.x) && ! C )
   
   if(
      figura.x(i) > x_min &&
      figura.x(i) < x_max && 
      figura.y(i) > y_min &&
      figura.y(i) < y_max)
      
      C = 1;
      
    endif
    
    i++;
    
  endwhile

endfunction

# Subdivide recursivamente en elemento hasta sub_max.
function M = subdividir(E, figura, sub_actual, sub_max)
  M = {};
  
  if(sub_actual == sub_max)
    
    M = hijos(E); # hijos devuelve {cell}
  
  else

    H = hijos(E);
  
    for(j = 1:size(H)(2) )
      for(i = 1:size(H)(1))
      
      if( hay_interseccion(H{i,j}, figura) )
      
        H{i,j} = subdividir(H{i,j}, figura, sub_actual + 1, sub_max);
        
      endif

      endfor
    endfor
    
    M = H;
    
  endif
  
endfunction

# Dado un Elemento E, devuelve sus 4 hijos.
function M = hijos(E)
  
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
  
  
endfunction
