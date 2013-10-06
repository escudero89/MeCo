## -*- texinfo -*-
## @deftypefn  {Function File} {} Punto (@var{xyz})
## @deftypefnx {Function File} {} Punto (@var{x}, @var{y}, @var{z} = 0)
## Crea un punto que contiene las posiciones (X, Y, Z).
## Puede recibir otro PUNTO como argumento. No es necesario especificar Z (default = 0).
## @end deftypefn

function p = Punto (xyz)
     
     if (strcmp (class (xyz), 'Punto'))
          p = xyz;

     elseif (length(xyz) == 3)
          p.point = [xyz(1) xyz(2) xyz(3)];

     elseif (length(xyz) == 2)
          p.point = [xyz(1) xyz(2) 0];

     else
          % Si falla avisamos
          print_usage ();
     end

     p = class (p, 'Punto');

endfunction