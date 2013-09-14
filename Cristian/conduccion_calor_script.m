1;
clear all;
clf;
close;

tipo_df = 1;
Lx = 1;
dx = 0.1;
t_f = 1;
dt = 0.005;
tipo_cond = [1 0];
val_cond = [-1 0];
phi_0 = zeros(1, length(0:dx:Lx));

[PHI] = conduccion_calor_no_estacionario_1d( tipo_df, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

cant_N = 10;
N = cant_N * floor(size(PHI)(1) / cant_N);

plot(0:dx:Lx, PHI(1:cant_N:N,:));
grid;
xlabel('x');
ylabel('phi');