## -*- texinfo -*-
## @deftypefn  {Function File} {} Objeto ()
## @deftypefnx {Function File} {} Objeto (@var{P1}, @var{P2}, @var{N})
## El objeto recibe un vectores columnas de elementos, de la forma
## 
## @example
## [x1, y1] ; [x2, y2] ; [n1, n2]
## @end example
## @end deftypefn

function O = Objeto (P1, P2, N)

	if ((size(P1, 1) != size(P2, 1)) || (size(P1, 1) != size(N, 1)))
		error ('Objeto : error al crear el Objeto, tamanhos de los vectores difieren');
	end

	elementos = {};

	% Recorremos el objeto, y asignamos una etiqueta a medida que lo vamos componiendo
	for k = 1 : size(P1, 1)

		elementos{k} = {
			k, % etiqueta
			Punto(P1(k, :)),
			Punto(P2(k, :)),
			Punto(N(k, :))
		};

	end

	O.elementos = elementos;

	O = class (O, 'Objeto');

endfunction



		