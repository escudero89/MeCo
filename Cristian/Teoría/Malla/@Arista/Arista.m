## -*- texinfo -*-
## @deftypefn  {Function File} {} Arista ()
## @deftypefnx {Function File} {} Arista (@var{P1}, @var{P2}, @var{N} = [0 0], @var{etiqueta} = 0)
## Crea una arista compuesta de dos Puntos (x1, y1) y (x2, y2) [caso 2D implementado].
## Ademas, puede asignarsele una normal (que se normaliza) y una etiqueta
## @end deftypefn

function a = Arista (P1, P2, N = [0 0], etiqueta = 0)

     if (strcmp (class (P1), 'Punto'))
          a.p1 = P1;          
     else
          a.p1 = Punto([P1(1), P1(2)]);
     end

     if (strcmp (class (P2), 'Punto'))
          a.p2 = P2;          
     else
          a.p2 = Punto([P2(1), P2(2)]);
     end

     if (strcmp (class (N), 'Punto'))
          a.normal = N;          
     else
          a.normal = Punto([N(1), N(2)]);
     end

     a.tag = etiqueta;
     
     a = class (a, 'Arista');

endfunction