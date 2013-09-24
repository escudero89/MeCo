function plot_malla(M)
  
  if(isempty(M))
    return;
  else
    
    for( i = 1 : size(M)(1) )
      for( j = 1 : size(M)(2) )
        
        if(! iscell(M{i,j}))
          #dx = abs(M{1,1}(1,1) - M{1,1}(4,1));
          #dy = abs(M{1,1}(1,2) - M{1,1}(2,2));
    
          #x_center = dx/3 + M{1,1}(1,1);
          #y_center = dy/2 + M{1,1}(1,2);
        
          #x_c = x_center + (i-1) * dx;
          #y_c = y_center + (j-1) * dy;
          
          #label = strcat("E=", num2str(i),",", num2str(j));
          plot(M{i,j});
          #text(x_c, y_c, label);
        
        else

          plot_malla(M{i,j});

        endif
      endfor
    endfor
    
  endif
  
endfunction