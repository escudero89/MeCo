##------------------------------------------------------------------------------
## CONDUCCION DEL CALOR NO ESTACIONARIO 1D MALLA UNIFORME
## Simula conduccion de calor NO estacionario utilizando diferencias finitas
##------------------------------------------------------------------------------
##
## 
##  PROTOTIPO:
##
## [PHI] = conduccion_calor_no_estacionario_1d(phi0, Lx, dx, dt, t_f,
##                            tipo_cond,	
##                            val_cond, 
##                            k = @k_default,
##                            c = @c_default,
##                            phi_amb= @phi_amb_default,
##                            Q = @Q_default
##                            );
##
##
## PARAMETROS:
##
## phi0: Vector FILA con temperaturas en tiempo t=0
## Lx : Largo de la varilla
## dx : Delta entre puntos
## dt : Delta entre tiempos
## t_f: Tiempo final
## tipo_cond:  Array dirichlet(0), neumann(1). Ej: [0 1]
## val_cond: Matriz de val_condes (pueden variar en el tiempo) 		
## k : Funcion de conductividad termica. Dependiente de x y t.
## c : Funcion de calor especifico. Dependiente de x y t.
## phi_amb: Funcion de temperatura ambiente. Dependiente de x y t.
## Q : funcion de la fuente de calor. Si es positiva, provee calor. Dependiente de x y t.
##
##
## RESULTADO:
##
## PHI: Campos de temperaturas phi (filas) en cada instante de tiempo.
##
##
##------------------------------------------------------------------------------
## conduccion_calor_no_estacionario_1d.m
## Author: Marcos <marcosyedro@gmail.com>
## Created: 2013-09-13
##------------------------------------------------------------------------------
function [PHI] = conduccion_calor_no_estacionario_1d_FE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de condiciones (pueden variar en el tiempo) 		
                            k = @k_default,
                            c = @c_default,
                            phi_amb= @phi_amb_default,
                            Q = @Q_default
                            )

    dx2 = dx^2;

    cant_x = 0 : dx :  Lx;    
    cant_t = 0 : dt : t_f;
    
    t_iter = length(cant_t);
    
   PHI = zeros(t_iter, length(cant_x) );
    
    # Asignamos temperaturas a tiempo 0
    PHI(1,:) = phi0;
    
    ##  ------------------------------------------------------------------------
    ##  METODO: FORWARD EULER     
    ##  ------------------------------------------------------------------------
    
    # CICLO TEMPORAL (n)
    for n = 1 : t_iter - 1
    
        # ASIGNAMOS CONDICION DE CONTORNO EN x = 0
        i = 1;

        if( tipo_cond(1) )  # Si val_cond de Neumann en x = 0
            # Creamos nodo ficticio PHI(n, i-1)
            
            #TODO REEMPLAZAR k(n,i) por k(cant_t(n), cant_x(i))
            #     HACER LO MISMO CON c phi_amb, etc.
            
            nodo_ficticio = val_cond(n, 1)/k( cant_t(n), cant_x(i) ) * 2*dx + PHI(n, i+1); 
            
            # Calculamos la ecuacion general con el nodo ficticio
            PHI(n+1,i) = -(PHI(n, i) * (-1/dt + 2*k( cant_t(n), cant_x(i) )/dx2 - ...
                         c(cant_t(n), cant_x(i)) ) - ...
                         k(cant_t(n),cant_x(i)) * ( nodo_ficticio + PHI(n, i+1) ) / dx2 + ...
                         c(cant_t(n),cant_x(i)) * phi_amb(cant_t(n),cant_x(i)) - Q(cant_t(n),cant_x(i)) ...
                         )*dt;
                              
        else                # Si condicion de Dirichlet en x = 0
            
            PHI(n+1, i) = val_cond(n, 1);
        
        endif
        
        # ASIGNAMOS CONDICION DE CONTORNO EN x = Lx
        i = length(cant_x);

        if( tipo_cond(2) )  # Si condicion de Neumann en x = Lx
            # Creamos nodo ficticio PHI(n, Lx + 1)
            
            nodo_ficticio = -val_cond(n, 2)/k(cant_t(n),cant_x(i)) * 2*dx + PHI(n, i-1); 
            
            # Calculamos la ecuacion general con el nodo ficticio
            PHI(n+1,i) = -(PHI(n, i) * (-1/dt + 2*k(cant_t(n),cant_x(i))/dx2 - ...
             c(cant_t(n),cant_x(i)) ) - ...
                               k(cant_t(n),cant_x(i)) * ( nodo_ficticio + PHI(n, i-1) ) / dx2 + ...
                               c(cant_t(n),cant_x(i)) * phi_amb(cant_t(n),cant_x(i)) ...
                                - Q(cant_t(n),cant_x(i)) ...
                              )*dt;
                              
        else                # Si condicion de Dirichlet en x = Lx
            PHI(n+1, end) = val_cond(n, 2);
        
        endif
                
        #Ciclo espacial (x)
        for i = 2 : (length(cant_x) - 1)
            
            PHI(n+1,i) = -(PHI(n, i) * (-1/dt + 2*k(cant_t(n),cant_x(i))/dx2 - ...
                         c(cant_t(n),cant_x(i)) ) ...
                         -k(cant_t(n),cant_x(i)) * ( PHI(n, i-1) + PHI(n, i+1) )/dx2 ...
                         + c(cant_t(n),cant_x(i)) * phi_amb(cant_t(n),cant_x(i)) - ...
                         Q(cant_t(n),cant_x(i)) )*dt;
            
        endfor

    endfor
    
##  ------------------------------------------------------------------------
##  METODO: BACKWARD EULER     
##  ------------------------------------------------------------------------
           
 
endfunction
 
 
 function [ret] = k_default(t_i, x_i)
	ret = 1;
	return;
end

function [ret] = c_default(t_i, x_i)
	ret = 0;
	return;
end

function [ret] = phi_amb_default(t_i, x_i)
	ret = 0;
	return;
end

function [ret] = Q_default(t_i, x_i)
	ret = 1;
	return;
end

