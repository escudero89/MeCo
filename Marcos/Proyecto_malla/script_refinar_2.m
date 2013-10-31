clf;
clear all;

# Generamos puntos (TRIANGULO)
paso = 0.01;

x1 = -1:paso:1;
y1 = 1 + (x1 * 0);

x2 = -1:paso:0;
y2 = -x2;

x3 = 0:paso:1;
y3 = x3;


figura.x = [x1 x2 x3];
figura.y = [y1 y2 y3];

# Generamos la malla.
malla_x = [-1.5:1.5/3:1.5];
malla_y = [-1.5:1.5/3:1.5];
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
