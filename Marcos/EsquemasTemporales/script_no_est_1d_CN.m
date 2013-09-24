1;

hold off
clear all
clc
disp("Parametros: ")
Lx = 1
dx = 0.2
phi0 = zeros( 1, length(0:dx:Lx) )
phi0(1,1) = 0
dt = 0.5 * dx^2
t_f = 0.5
tipo_cond = [1 0]	# array dirichlet(0), neumann(1)
# Matriz de condiciones (pueden variar en el tiempo
val_cond = [5 * ones( length(0: dt : t_f ), 1 ), 0 * ones( length(0: dt : t_f ), 1 ) ];
pause

[PHI] = conduccion_calor_no_estacionario_1d_FE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond  # Matriz de val_condes (pueden variar en el tiempo) 		
                            );
                            
    color = ['1' '2' '3' '4' '5' '6'];
    for i = 1 : size(PHI)(1)                            
        plot(0:dx:Lx, PHI(i,:), color( mod(i,6) + 1 ) )
        xlabel('x');
        ylabel('phi');
        title('Crank Nicholson');
        hold on;
    endfor
    
        hold off;
