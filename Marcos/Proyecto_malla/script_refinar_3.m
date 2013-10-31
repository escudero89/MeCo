clf;
clear all;

# Generamos puntos (circulo)
tita = 0:pi/800:2*pi;
rho = (sin(tita) .* sqrt(abs(cos(tita))))./(sin(tita) + 7/5) - 2*sin(tita) + 2;

figura.x = rho .* cos(tita);
figura.y = rho .* sin(tita);


# Generamos la malla.
malla_x = [-3:1:3];
malla_y = [-5:1:1];
lim_subd = 4;
#tol = 0.04;
tol = 0.01;
# Llamamos al metodo
tic
M = refinar_malla(figura, malla_x, malla_y, lim_subd, tol);
disp('Fin Refinado.');
toc
disp('Comenzando, ploteado...')
tic
plot_malla(M);
hold on;
#plot(figura.x,figura.y,'db');
disp('Fin ploteado.')
toc
hold off;
