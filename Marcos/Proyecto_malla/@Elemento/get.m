function e_struct = get (E_class, atributo)
       if (nargin == 1)
         e_struct.p1 = E_class.p1;
         e_struct.p2 = E_class.p2;
         e_struct.p3 = E_class.p3;
         e_struct.p4 = E_class.p4;
         e_struct.puntos = E_class.puntos;
         
       elseif (nargin == 2)
         if (ischar (atributo))
           switch (atributo)
             case "p1"
               e_struct = E_class.p1;
             case "p2"
               e_struct = E_class.p2;
             case "p3"
               e_struct = E_class.p3;
             case "p4"
               e_struct = E_class.p4;
             case "puntos"
               e_struct = E_class.puntos;
             otherwise
               error ("get: Punto invalido, elija p1 p2 p3 o p4 %s", f);
           endswitch
         else
           error ("get: El segundo argumento deber ser un string: p1 p2 p3 p4 o puntos");
         endif
       else
         print_usage ();
       endif
     endfunction