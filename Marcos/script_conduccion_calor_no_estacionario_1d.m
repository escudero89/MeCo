    1;
    clear all
    clf
    clc


    disp("Parametros: ")
    Lx = 1

    dx = 0.2

    phi0 = zeros( 1, length(0:dx:Lx) )

    phi0(1,1) = 0

    dt = 0.5 * dx^2

    t_f = 0.5

    tipo_cond = [0 0]	# array dirichlet(0), neumann(1)

    # Matriz de condiciones (pueden variar en el tiempo
    val_cond = [0 * ones( length(0: dt : t_f ), 1 ), 0 * ones( length(0: dt : t_f ), 1 ) ];

    pause

    cd EsquemasTemporales;

    [PHI_1] = conduccion_calor_no_estacionario_1d_FE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond  # Matriz de val_condes (pueden variar en el tiempo) 		
                            #k =@k_default,
                            #c =@c_default,
                            #phi_amb =@phi_amb_default,
                            #Q = @Q_default
                            );
    figure(1);
    plot(0:dx:Lx,PHI_1)
    xlabel('x');
    ylabel('phi');
    title('Forward Euler');

    
    [PHI_2] = conduccion_calor_no_estacionario_1d_BE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond  # Matriz de val_condes (pueden variar en el tiempo) 		
                            #k =@k_default,
                            #c =@c_default,
                            #phi_amb =@phi_amb_default,
                            #Q = @Q_default
                            );
    figure(2);
    plot(0:dx:Lx,PHI_1)
    xlabel('x');
    ylabel('phi');
    title('Backward Euler');
    

    [PHI_3] = conduccion_calor_no_estacionario_1d_CN(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond  # Matriz de val_condes (pueden variar en el tiempo) 		
                            #k =@k_default,
                            #c =@c_default,
                            #phi_amb =@phi_amb_default,
                            #Q = @Q_default
                            );
    figure(3);
    plot(0:dx:Lx,PHI_1)
    xlabel('x');
    ylabel('phi');
    title('Crank Nicholson');           
    
    
    cd ..
