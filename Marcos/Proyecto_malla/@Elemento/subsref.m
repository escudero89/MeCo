function b = subsref (a, s)    
       
       if (isempty (s))
         error ("Elemento: missing index");
       endif
       
       switch (s(1).type)
         case "()"
           
           ind = s(1).subs;
           
           if (numel (ind) < 2)
             ind{2} = 0;
           endif

           if (numel (ind) > 2)
             error ("Elemento: Maximo 2 indices");
           else
           
           switch (ind{1})
             case 1
               
               if( ind{2} == 1)
               	b = a.p1(1);
               elseif(ind{2} == 2)
               	b = a.p1(2);
               else
               	b = a.p1;
               endif
               
             case 2
               if( ind{2} == 1)
               	b = a.p2(1);
               elseif(ind{2} == 2)
               	b = a.p2(2);
               else
               	b = a.p2;
               endif
               
             case 3
                if( ind{2} == 1)
               	b = a.p3(1);
               elseif(ind{2} == 2)
               	b = a.p3(2);
               else
               	b = a.p3;
               endif
               
             case 4
                if( ind{2} == 1)
               	b = a.p4(1);
               elseif(ind{2} == 2)
               	b = a.p4(2);
               else
               	b = a.p4;
               endif
               
             otherwise
               error ("get: Indice invalido, elija 1 2 3 o 4 %s");
           endswitch
         
         endif
         
         endswitch                 
         
     endfunction