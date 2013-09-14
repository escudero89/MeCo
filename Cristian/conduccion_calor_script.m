1;
clear all;
clf;
close;

Lx = 1;
dx = 0.1;
t_f = 1;
dt = 0.005;
tipo_cond = [1 1];
val_cond = [-1 10];
phi_0 = zeros(length(0:dx:Lx), 1);

[PHI_1] = conduccion_calor_no_estacionario_1d( 1, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

[PHI_2] = conduccion_calor_no_estacionario_1d( 2, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

cant_N = 10;
N = cant_N * floor(size(PHI_1)(1) / cant_N);

subplot (1, 2, 1)
plot(0:dx:Lx, PHI_1(1:cant_N:N,:));
grid;
xlabel('x');
ylabel('phi');
title('Fordward Euler');
 
subplot (1, 2, 2)
plot(0:dx:Lx, PHI_2(1:cant_N:N,:));
grid;
xlabel('x');
ylabel('phi');
title('Backward Euler');
