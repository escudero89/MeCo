[PHI] = function conduccion_calor_no_estacionario_1d(phi0, Lx, dx, dt, 
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            cond,		
                            k = @k_default,
                            c = @c_default,
                            phi_amb= @phi_amb_default,
                            Q = @Q_default,
                            )

    t_iter = 10;
    cant_x = 0 : dx : Lx;    
    
    

    for t = 1:t_iter

        for i = 1 : length(cant_x)
            
            PHI(t,i)

        endfor

    endfor

 
 
 
endfunction
 
