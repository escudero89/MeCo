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
function [PHI] = conduccion_calor_no_estacionario_1d_BE(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de condiciones (pueden variar en el tiempo) 		
                            k = 1, #@k_default,
                            c = 0, #@c_default,
                            phi_amb = 0, # @phi_amb_default,
                            Q = @Q_default
                            )

    ##  ------------------------------------------------------------------------
    ##  METODO: BACKWARD EULER, resolveremos A x = b    
    ##  ------------------------------------------------------------------------

    
    # Algunas declaraciones generales
    dx2 = dx^2;
    cant_x = 0 : dx :  Lx;    
    cant_t = 0 : dt : t_f;
    t_iter = length(cant_t);
    
    # Creamos matriz solucion PHI
    PHI = zeros(t_iter, length(cant_x) );
    
    # Asignamos temperaturas a tiempo 0
    PHI(1,:) = phi0;
    
    # GENERAMOS LA MATRIZ A
    diagonal_central =  diag( (-1/dt - 2 * k/dx2 + c) * ones(1, length(cant_x) ) );
    diagonal_superior = diag( (k/dx2) * ones(1,length(cant_x)-1), +1 );
    diagonal_inferior = diag( (k/dx2) * ones(1,length(cant_x)-1), -1 );
    A = diagonal_central + diagonal_superior + diagonal_inferior;

    # GENERAMOS EL TERMINO INDEPENDIENTE
    f = zeros(length(cant_x),1);
    # AGREGAMOS CONDICIONES DE CONTORNO
    # En x = 0    
    if( tipo_cond(1) )  # Contorno Neumann en x = 0
    
        A(1,2) = 2 * k/dx2;
        f(1) = c * phi_amb - Q(cant_t(1),cant_x(1)) - PHI(1,1)/dt -2 * val_cond(1)/dx; 
    
    else                # Contorno Dirichlet en x = 0
    
        A(1,:) = [ 1, zeros(1,length(cant_x)-1) ];
        f(1) = val_cond(1);
    
    endif
   
    # En x = Lx
    if( tipo_cond(2) )  # Contorno Neumann en x = 0
    
        A(end,end-1) = 2 * k/dx2;
        f(end) = c * phi_amb - Q(cant_t(1),cant_x(end)) - PHI(1,end)/dt + 2 * val_cond(2)/dx; 
    
    else                # Contorno Dirichlet en x = 0
    
        A(end,:) = [zeros(1,length(cant_x)-1), 1 ];
        f(end) = val_cond(2);
    
    endif
    
    # FACTORIZAMOS MATRIZ para resolver dos sist triangulares.
    [L U P] = lu(A);
    
    # CICLO TEMPORAL (n)
    for n = 1 : t_iter - 1
        
        # Recalculamos Q para c/ instante de tiempo
        Q_vec = [];
        for(i=2:length(cant_x)-1)
            Q_vec = [Q_vec Q(cant_t(n),cant_x(i))];
        endfor
        
        # Actualizamos f
        f(2:end-1) = c * phi_amb * ones(length(Q_vec),1) - Q_vec' - PHI(n,2:end-1)'/dt;
        
        # Resolvemos sistema en dos pasos
        y = (P'*L) \ f;
        phi_nuevo = U\y;  
        
        # Almacenamos en la matriz PHI
        PHI(n+1,:) = phi_nuevo';
                               
    endfor
    
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

