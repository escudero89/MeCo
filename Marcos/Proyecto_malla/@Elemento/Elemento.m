     ## -*- texinfo -*-
     ## @deftypefn  {Function File} {} polynomial ()
     ## @deftypefnx {Function File} {} polynomial (@var{a})
     ## Create a polynomial object representing the polynomial
     ##
    ## @example
     ## a0 + a1 * x + a2 * x^2 + @dots{} + an * x^n
     ## @end example
     ##
     ## @noindent
     ## from a vector of coefficients [a0 a1 a2 @dots{} an].
     ## @end deftypefn
     ## 
     
     function E = Elemento (VecElem, c_puntos = []) 
       # Contructor por defecto (nargin == 0)
       if (nargin == 0)
         E.p1 = [0 0];
         E.p2 = [0 0];
         E.p3 = [0 0];
         E.p4 = [0 0];
         E.puntos = [];
         E = class (E, "Elemento");
       
       #Constructor por copia (nargin == 1)
       elseif (nargin <= 2)
         if (strcmp (class (VecElem), "Elemento")) 
           E = VecElem;
           #Constructor normal, chequeamos formato: VecElem = [x1 y1; x2 y2; x3 y3; x4 y4];
         elseif (rows(VecElem) == 4 && columns(VecElem) == 2)
           E.p1 = VecElem(1,:);
           E.p2 = VecElem(2,:);
           E.p3 = VecElem(3,:);
           E.p4 = VecElem(4,:);
           E.puntos = c_puntos;
                      
           E = class (E, "Elemento");
           # Formato incorrecto
         else
           error ("La clase Elemento espera como entrada este formato: \n     E = Elemento (VecElem)   \n VecElem = [x1 y1; x2 y2; x3 y3; x4 y4];");
         endif
       else
         print_usage ();
       endif