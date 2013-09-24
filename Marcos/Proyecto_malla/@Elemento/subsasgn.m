function a = subsasgn (a, s, val)    
       
       if (isempty (s))
         error ("Elemento: missing index");
       endif
       
       switch (s(1).type)
         case "()"
           
           ind = s(1).subs;
           
          
           if(!isscalar(val) && numel(ind) == 2 )
                 error("Error entre nro indices y tipo de elemento a asignar")
             endif
           	
           	 	
            if (numel (ind) < 2)
             ind{2} = 0;
             
             if(numel(val)!=2)
                 error("Si pasa solo un indice, el elemento a asignar debe ser un vector.")
             endif
             
           endif
           

           if (numel (ind) > 2)
             error ("Elemento: Maximo 2 indices");
           else
           
           switch (ind{1})
             case 1
               
               if( ind{2} == 1)
               	a.p1(1) = val(1);
               elseif(ind{2} == 2)
               	a.p1(2) = val(1);
               else
               	a.p1 = val;
               endif
               
             case 2
               if( ind{2} == 1)
               	a.p2(1)=val(1);
               elseif(ind{2} == 2)
               	a.p2(2)=val(1);
               else
               	a.p2=val;
               endif
               
             case 3
                if( ind{2} == 1)
               	a.p3(1)=val(1);
               elseif(ind{2} == 2)
               	a.p3(2)=val(1);
               else
               	a.p3=val;
               endif
               
             case 4
                if( ind{2} == 1)
               	a.p4(1)=val(1);
               elseif(ind{2} == 2)
               	a.p4(2)=val(1);
               else
               	a.p4=val;
               endif
               
             otherwise
               error ("get: Indice invalido, elija 1 2 3 o 4 %s");
           endswitch
         
         endif
         
         endswitch                 
         
     endfunction