1;
clear all;
clf('reset');
close;
global TOL = eps;

# Generamos puntos (Circulo)
	paso = pi/12;
	tita = 0:paso:2*pi-paso;
	rho = (sin(tita) .* sqrt(abs(cos(tita))))./(sin(tita) + 7/5) - 2*sin(tita) + 2;
	figura_x = rho .* cos(tita);
	figura_y = rho .* sin(tita);

# Armamos vector de Segmentos
	segmentos_next = ...
		[ figura_x'(2:end) figura_y'(2:end) ; figura_x'(1) figura_y'(1) ];

	segmentos = ...
		[ figura_x' figura_y' segmentos_next ];


# Agregamos indice a todos los elementos
	idx_segmentos = [ 1 : size(segmentos, 1) ]';
	segmentos = [segmentos idx_segmentos];

# Establecemos los limites de la malla
	lim_x = [-5:10:5];
	lim_y = [-5:10:5];

# Establecemos profundidad maxima
	max_profundidad = 4;

# Generamos Arbol de elementos
	tic
	M = generar_malla(lim_x, lim_y, segmentos, max_profundidad);
	disp('Generacion de malla: ');
	toc


	if (1) # ¿Ploteo?
		tic
		figure(1);
		clf;
		plot_malla(M, 0);
		hold on;
		plot([figura_x , figura_x(1)], [figura_y , figura_y(1)])
		hold off;
		disp('Tiempo de ploteo 1: ');
		toc
	endif


# Transformamos Arbol de elementos en malla de nodos
	tic
	[xnod, inode, state, state_matrix] = transformar_malla(M, lim_x, lim_y, max_profundidad);
	disp('Transformacion de malla: ');
	toc

# Dibujamos malla de nodos
	if(1) # ¿Ploteo?
		tic
		figure(2)
		clf;
		pltmsh(xnod, inode, [], state);
		hold on;
		plot([figura_x , figura_x(1)], [figura_y , figura_y(1)])
		hold off;
		disp('Tiempo de ploteo 2: ');
		toc
	endif


# Aplicamos diferencias finitas
	tic
	# Conductividad
	k = 1;

	# Condicion Dirichlet
	dirichlet = 0;
	
	# Fuente de calor (negativo aporta calor)
	function [ret] = Q(x, y)
		ret = -1;
	endfunction

	figure(3);
	clf;
	[ret] = aplicar_df_calor_2d(xnod, inode, state_matrix, k, @Q, dirichlet);

	disp('Metodo de diferencias finitas y ploteo 3: ');
	toc

return
