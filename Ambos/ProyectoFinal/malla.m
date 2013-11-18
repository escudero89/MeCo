1;
clear all;
clf;
close;

global TOL = eps;

# Generamos puntos (circulo)
paso = pi/6;
rho = 0.8;
tita = 0:paso:2*pi-paso;
rho = ones(1,length(tita));
figura_x = rho .* cos(tita) + 0.3;
figura_y = rho .* sin(tita) + 0.3;


# Corazon
tita = 0:paso:2*pi;
rho = (sin(tita) .* sqrt(abs(cos(tita))))./(sin(tita) + 7/5) - 2*sin(tita) + 2;
%figura_x = rho .* cos(tita);
%figura_y = rho .* sin(tita);


%tolerancia = 0.1;
%figura_x = [-1 1 1 -1];
%figura_y = [-1 -1 1 1];

	
segmentos_next = ...
	[ figura_x'(2:end) figura_y'(2:end) ; figura_x'(1) figura_y'(1) ];

segmentos = ...
	[ figura_x' figura_y' segmentos_next ];



% Le agrego un indice a todos los elementos
idx_segmentos = [ 1 : size(segmentos, 1) ]';

segmentos = [segmentos idx_segmentos];

lim_x = [-10:20:10];
lim_y = [-10:20:10];
max_profundidad = 10;

tic
M = generar_malla(lim_x, lim_y, segmentos, max_profundidad);
toc

tic
%plot_malla(M, 1);
%hold on;
%plot([figura_x , figura_x(1)], [figura_y , figura_y(1)])
%hold off;
toc

pause;

tic
[xnod, inode, state, state_matrix] = transformar_malla(M, lim_x, lim_y, max_profundidad);
toc

tic
pltmsh(xnod, inode, [], state);
hold on;
plot([figura_x , figura_x(1)], [figura_y , figura_y(1)])
hold off;
toc

return
