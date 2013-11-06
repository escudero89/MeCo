1;

# Generamos puntos (circulo)

paso = pi/20;
rho = 0.8;

tita = 0:paso:2*pi-paso;
rho = ones(1,length(tita));
figura_x = rho .* cos(tita) + 0.3;
figura_y = rho .* sin(tita) + 0.3;
	
segmentos_next = ...
	[ figura_x'(2:end) figura_y'(2:end) ; figura_x'(1) figura_y'(1) ];

segmentos = ...
	[ figura_x' figura_y' segmentos_next ] ;

tic
M = generar_malla([-2:1:2], [-2:1:2], segmentos);
toc
tic

plot_malla(M, 1);
hold on;
plot(figura_x,figura_y)
hold off;
toc
