1;

hold off
clear all
clc
disp("Parametros: ")
Lx = 1
dx = 0.25
phi0 = zeros( 1, length(0:dx:Lx) )
phi0(1,1) = 0
dt = 0.5 * dx^2
t_f = 1
tipo_cond = [0 1]	# array dirichlet(0), neumann(1)
# Matriz de condiciones (pueden variar en el tiempo
val_cond = [0 * ones( length(0: dt : (t_f - dt) ), 1 ), 0.5 * ones( length(0: dt : (t_f - dt) ), 1 ) ]
pause

# k = @k_default;
# c = @c_default;
# phi_amb= @phi_amb_default;
# Q = @Q_default;

[PHI] = conduccion_calor_no_estacionario_1d(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond  # Matriz de val_condes (pueden variar en el tiempo) 		
                            #k = @k_default,
                            #c = @c_default,
                            #phi_amb= @phi_amb_default,
                            #Q = @Q_default
                            );
                            
    color = ['1' '2' '3' '4' '5' '6'];
    for i = 1 : size(PHI)(1)                            
        plot(0:dx:Lx, PHI(i,:), color( mod(i,6) + 1 ) )
        xlabel('x');
        ylabel('phi');
        title('Fordward Euler');
        hold on;
    endfor
    
        hold off;
