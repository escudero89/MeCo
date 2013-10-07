## -*- texinfo -*-
## @deftypefn  {Function File} {} Celda ()
## @deftypefnx {Function File} {} Celda (@var{origen}, @var{dx}, @var{dy}, @var{state})
## Crea uan celda rectangular a partir de un punto de origen, y una distancia dx (hacia izq) y dy (hacia arriba).
## En el proceso crea las cuatro aristas que le corresponden. Solo sirve para celdas rectangulares.
## El STATE indica el estado de la celda (interior, exterior, etc).
## @end deftypefn

function c = Celda (origen, dx, dy, state = 0)

     if (strcmp (class (origen), 'Punto'))
          base = origen;
     else
          base = Punto([origen(1), origen(2)]);
     end

     % Creamos manualmente las normales, apuntando hacia afuera del rectangulo
     n1 = [0 -1];
     n2 = [1 0];
     n3 = [0 1];
     n4 = [-1 0];

     c.arista1 = Arista(base, sum(base, dx, 0), n1, 1);
     c.arista2 = Arista(sum(base, dx, 0), sum(base, dx, dy), n2, 2);
     c.arista3 = Arista(sum(base, dx, dy), sum(base, 0, dy), n3, 3);
     c.arista4 = Arista(sum(base, 0, dy), base, n4, 4);

     c.state = state;

     c = class (c, 'Celda');

endfunction