1;
clear all;
clf;
close;

global TOL = eps;

# Generamos puntos (circulo)

paso = pi/30;
rho = 0.8;

tita = 0:paso:2*pi-paso;
rho = ones(1,length(tita));
figura_x = rho .* cos(tita) + 0.3;
figura_y = rho .* sin(tita) + 0.3;

%figura_x = [0 1.01 -1];

%figura_y = [-1 1.01 0];

	
segmentos_next = ...
	[ figura_x'(2:end) figura_y'(2:end) ; figura_x'(1) figura_y'(1) ];

segmentos = ...
	[ figura_x' figura_y' segmentos_next ];

% Le agrego un indice a todos los elementos
idx_segmentos = [ 1 : size(segmentos, 1) ]';

segmentos = [segmentos idx_segmentos];

tic
M = generar_malla([-2:4:2], [-2:4:2], segmentos, 4);
toc

transformar_malla(M);

return

tic
plot_malla(M, 0);
hold on;
plot([figura_x , figura_x(1)], [figura_y , figura_y(1)])
hold off;
toc