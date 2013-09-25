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
function [PHI] = conduccion_calor_no_estacionario_1d_BE_EJ2(phi0, Lx, dx, dt, t_f,
                            tipo_cond,	# array dirichlet(0), neumann(1)
                            val_cond,  # Matriz de condiciones (pueden variar en el tiempo) 		
                            k =@k_default,
                            c =@c_default,
                            phi_amb =@phi_amb_default,
                            Q = @Q_default
                            )

    ##  ------------------------------------------------------------------------
    ##  METODO: CRANK NICHOLSON, resolveremos A x = b    
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
    
    diagonal_central = diagonal_superior = diagonal_inferior = [];
    # GENERAMOS LA MATRIZ A
    for( i = 1 : length(cant_x) )
        diagonal_central =  [diagonal_central, (-1/dt - 2*k(cant_x(i))/dx2 + c(cant_x(i)))];
        diagonal_superior = [diagonal_superior, (k(cant_x(i))/dx2)];
        diagonal_inferior = [diagonal_inferior, (k(cant_x(i))/dx2)];
    endfor
    
    diagonal_central = diag(diagonal_central);
    diagonal_superior = diag(diagonal_superior(1:end-1),1);
    diagonal_inferior = diag(diagonal_inferior(2:end),-1);
    
    A = diagonal_central + diagonal_superior + diagonal_inferior;

    
    # AGREGAMOS CONDICIONES DE CONTORNO EN MATRIZ
    # En x = 0    
    if( tipo_cond(1) )  # Contorno Neumann en x = 0
        A(1,2) = 2 * k(cant_x(1))/dx2;
    else                # Contorno Dirichlet en x = 0
        A(1,:) = [ 1, zeros(1,length(cant_x)-1) ];
    endif
   
    # En x = Lx
    if( tipo_cond(2) )  # Contorno Neumann en x = l
        A(end,end-2) = 0;
        A(end,end-1) = 2 * k(cant_x(end))/dx2;
        A(end,end) = -1/dt - 2*k(cant_x(end))/dx2 + c(cant_x(end)) + 2*k(cant_x(end))/dx; ## AGREGADO  
    else                # Contorno Dirichlet en x = l
        A(end,:) = [zeros(1,length(cant_x)-1), 1 ];
    endif
    
    # FACTORIZAMOS MATRIZ para resolver dos sist triangulares.
    [L U P] = lu(A);
    
    # GENERAMOS EL TERMINO INDEPENDIENTE
    f = zeros(length(cant_x),1);

    # CICLO TEMPORAL (n)
    for n = 1 : t_iter - 1
            
        # AGREGAMOS CONDICIONES DE CONTORNO A TERMINO INDEPENDIENTE
        # En x = 0    
        if( tipo_cond(1) )  # Contorno Neumann en x = 0
            
            f(1) = c(cant_x(1)) * phi_amb(cant_x(1)) - ...
            Q(cant_t(n+1),cant_x(1)) ...
            - PHI(n,1)/dt - 2 * val_cond(n+1,1)/dx;
        
        else                # Contorno Dirichlet en x = 0
        
            f(1) = val_cond(n+1, 1);
        
        endif
       
        # En x = Lx
        if( tipo_cond(2) )  # Contorno Neumann en x = 0

            f(end) = c(cant_x(i)) * phi_amb(cant_x(i)) - ...
                   Q(cant_t(n+1),cant_x(i)) - ...
                   PHI(n,i)/dt;   

        else                # Contorno Dirichlet en x = 0

            f(end) = val_cond(n+1,2);

        endif
            
        # Actualizamos f
        for(i = 2 : (length(cant_x)-1) )
            
            f(i) = c(cant_x(i)) * phi_amb(cant_x(i)) - ...
                   Q(cant_t(n+1),cant_x(i)) - ...
                   PHI(n,i)/dt;
            
        endfor
        
        
        # Resolvemos sistema en dos pasos
        y = (P'*L) \ f;
        phi_nuevo = U\y;  
        
        # Almacenamos en la matriz PHI
        
        PHI(n+1,:) = phi_nuevo';
                               
    endfor
    
endfunction
 
 
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
	 ret = sin(2 * pi * x_i);
	return;
end

