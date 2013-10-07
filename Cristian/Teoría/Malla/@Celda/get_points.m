% Retorno los cuatro puntos que contiene la celda como matrix [P1 ; P2 ; P3 ; P4]
function p = get_points(c)

	p = [ 
		get(get_args(c.arista1, 1)) ;
		get(get_args(c.arista2, 1)) ;
		get(get_args(c.arista3, 1)) ;
		get(get_args(c.arista4, 1)) 
		];

endfunction