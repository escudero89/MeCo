clf;
clear all;

# Generamos puntos (circulo)
tita = 0:pi/90:2*pi;
rho = ones(1,length(tita));
figura.x = rho .* cos(tita);
figura.y = rho .* sin(tita);

# Generamos la malla.
malla_x = [-1.5:1.5/3:1.5];
malla_y = [-1.5:1.5/3:1.5];
lim_subd = 3;
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
