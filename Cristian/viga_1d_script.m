1;

l = 1;
dx = 0.05;
h = 0.01;
E = 1e03;

cond_contorno = [0 0];
val_contorno = [0 0];

[ret] = viga_1d(l, dx, h, E, cond_contorno, val_contorno);

plot(0:dx:l, ret);