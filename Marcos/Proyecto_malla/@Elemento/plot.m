function h = plot(E)
   h = 1;
   if(numel(E) == 1)
      Puntos = get(E,"puntos");
      #Plotear 1 elemento
      if( isempty(Puntos) )
          
        line([E.p1(1) E.p2(1)],[E.p1(2) E.p2(2)])
        line([E.p2(1) E.p3(1)],[E.p2(2) E.p3(2)])
        line([E.p3(1) E.p4(1)],[E.p3(2) E.p4(2)])
        line([E.p4(1) E.p1(1)],[E.p4(2) E.p1(2)])
        
        xlim('auto')
        ylim('auto')
        
        limite_x = xlim();
        limite_y = ylim();
        
        xlim([limite_x(1) - 1, limite_x(2) + 1]);
        ylim([limite_y(1) - 1, limite_y(2) + 1]);
        
      else
      
        x = [E.p1(1) E.p2(1) E.p3(1) E.p4(1)];
        y = [E.p1(2) E.p2(2) E.p3(2) E.p4(2)];
        patch(x,y,'r');
      
      
      endif
   else(numel(E) > 1)
      error("Solo es posible graficar un elemento a la vez");
   endif

endfunction
