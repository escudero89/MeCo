  function E = set (p, varargin)
       E = p;
       if (length (varargin) < 2 )
         error ("set: Error, tenes que poner puntos.");
       endif
       
       while (length (varargin) > 1)
         prop = varargin{1};
         val = varargin{2};
         varargin(1:2) = [];
         
         if (ischar (prop) && isvector (val))
           
           switch (prop)
             case "p1"
               E.p1 = val;
             case "p2"
               E.p2 = val;
             case "p3"
               E.p3 = val;
             case "p4"
               E.p4 = val;
             otherwise
               error ("get: Punto invalido, elija p1 p2 p3 o p4 %s", f);
           endswitch
           
         else
           error ("set: usar en la forma set(E1, 'p1', [1 1],  'p2', [2 2])  ");
         endif
         
       endwhile
       
     endfunction