1;

clf;
clear all;

# Generamos puntos (circulo)
tita = 0:0.05:2*pi;
rho = ones(1,length(tita));
figura.x = rho .* cos(tita);
figura.y = rho .* sin(tita);

# Generamos la malla.
malla_x = [-1.5:1.5:1.5];
malla_y = [-1.5:1.5:1.5];
lim_subd = 6;
tol = 0;

# Llamamos al metodo
M = refinar_malla(figura, malla_x, malla_y, lim_subd, tol);
plot_malla(M);
#E = Elemento([5,5; 5,6; 6,6; 6,5]);
#plot(E);
#pause
#plot_malla(hijos(E));
