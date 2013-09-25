1;
clear all;
clf;
close;

Lx = 1;
dx = 0.1;
dt = 1000;
t_f = dt*15;
tipo_cond = [1 1];
val_cond = [0 0];

phi_0 = 0 .* (0:dx:Lx)';

%[PHI_1] = conduccion_calor_no_estacionario_1d_2( 1, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

[PHI_2] = conduccion_calor_no_estacionario_1d_2( 2, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

%[PHI_3] = conduccion_calor_no_estacionario_1d_2( 3, phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond );

cant_N = 10;
N = cant_N * floor(size(PHI_2)(1) / cant_N);

for i = 1 : length(0:dt:t_f) 

%subplot (1, 2, 1)
plot(0:dx:Lx, PHI_2);
grid;
xlabel('x');
ylabel('phi');
title('Fordward Euler');
%axis('equal');
 
%subplot (1, 2, 2)
%plot(0:dx:Lx, PHI_2(i,:));
%grid;
%xlabel('x');
%ylabel('phi');
%title('Backward Euler');
%axis('equal');

i
pause;
endfor

%subplot (1, 3, 3)
%plot(0:dx:Lx, PHI_3(1:cant_N:N,:));
%grid;
%xlabel('x');
%ylabel('phi');
%title('Crank-Nicholson');
%axis('equal');
