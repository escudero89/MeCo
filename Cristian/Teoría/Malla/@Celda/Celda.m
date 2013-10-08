## -*- texinfo -*-
## @deftypefn  {Function File} {} Celda ()
## @deftypefnx {Function File} {} Celda (@var{origen}, @var{dx}, @var{dy}, @var{state})
## Crea uan celda rectangular a partir de un punto de origen, y una distancia dx (hacia izq) y dy (hacia arriba).
## En el proceso crea las cuatro aristas que le corresponden. Solo sirve para celdas rectangulares.
## El STATE indica el estado de la celda (interior, exterior, etc).
## @end deftypefn

function C = Celda (origen, dx, dy, state = 1)

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

     C.arista1 = Arista(base, sum(base, dx, 0), n1, 1);
     C.arista2 = Arista(sum(base, dx, 0), sum(base, dx, dy), n2, 2);
     C.arista3 = Arista(sum(base, dx, dy), sum(base, 0, dy), n3, 3);
     C.arista4 = Arista(sum(base, 0, dy), base, n4, 4);

     % Guardo el valor del punto central de la celda
     C.punto_central = Punto(sum(base, dx/2, dy/2));

     C.state = state;

     % Aca guardaremos la etiqueta de la arista del objeto mas cercana, y la distancia a ella
     C.arista_mas_cercana = [];

     % Y aca guardo a sus hijos (si tiene)
     C.hijos = {};

     C = class (C, 'Celda');

endfunction