function plot_malla(M, etiquetado = 0)
  
  if(isempty(M))
    return;
  else
    
    for( i = 1 : size(M)(1) )
      for( j = 1 : size(M)(2) )
        
        if(! iscell(M{i,j}))
          if(etiquetado)
            dx = abs(M{i,j}(1,1) - M{i,j}(4,1));
            dy = abs(M{i,j}(1,2) - M{i,j}(2,2));
      
            x_center = dx/3 + M{i,j}(1,1);
            y_center = dy/2 + M{i,j}(1,2);
          
            x_c = x_center;
            y_c = y_center;
            
            label = strcat("E=", num2str(i),",", num2str(j));
            plot(M{i,j});
            text(x_c, y_c, label);
           
          elseif
           
            plot(M{i,j});
           
          endif
        
        else

          plot_malla(M{i,j}, etiquetado);

        endif
      endfor
    endfor
    
  endif
  
endfunction