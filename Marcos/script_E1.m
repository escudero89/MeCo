    1;
    clear all
    clf
    clc


    disp("Parametros: ")
    Lx = 1

    dx = 0.1
    
    f = 0.5;
    phi0 = sin(f * pi * (0:dx:Lx))
    
    # phi0 = zeros( 1, length(0:dx:Lx) )

    #phi0(1,1) = 0

    dt = 0.5 * dx^2

    t_f = 1

    tipo_cond = [0 0]	# array dirichlet(0), neumann(1)

    # Matriz de condiciones (pueden variar en el tiempo
    val_cond = [1 * ones( length(0: dt : t_f ), 1 ), 0 * ones( length(0: dt : t_f ), 1 ) ];


    function [ret] = k_default(t_i, x_i=0)
	    ret = 1;
	    return;
    end

    function [ret] = c_default(t_i, x_i=0)
	    ret = 0;
	    return;
    end

    function [ret] = phi_amb_default(t_i, x_i=0)
	    ret = 0;
	    return;
    end

    function [ret] = Q_default(t_i, x_i)
	    ret = 0;
	    return;
    end


    pause

    cd EsquemasTemporales;

    [PHI_1] = conduccion_calor_no_estacionario_1d_FE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de val_condes (pueden variar en el tiempo) 		
                            @k_default,
                            @c_default,
                            @phi_amb_default,
                            @Q_default
                            );
    figure(1);
    plot(0:dx:Lx,PHI_1)
    xlabel('x');
    ylabel('phi');
    title('Forward Euler');

    
    [PHI_2] = conduccion_calor_no_estacionario_1d_BE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de val_condes (pueden variar en el tiempo) 		
                            k =@k_default,
                            c =@c_default,
                            phi_amb =@phi_amb_default,
                            Q = @Q_default
                            );
    figure(2);
    plot(0:dx:Lx,PHI_2)
    xlabel('x');
    ylabel('phi');
    title('Backward Euler');
    

    [PHI_3] = conduccion_calor_no_estacionario_1d_CN(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de val_condes (pueden variar en el tiempo) 		
                            k =@k_default,
                            c =@c_default,
                            phi_amb =@phi_amb_default,
                            Q = @Q_default
                            );
    figure(3);
    plot(0:dx:Lx,PHI_3)
    xlabel('x');
    ylabel('phi');
    title('Crank Nicholson');           
    
    
    cd ..
