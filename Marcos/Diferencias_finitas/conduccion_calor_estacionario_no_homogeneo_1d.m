##------------------------------------------------------------------------------
## CONDUCCION DEL CALOR ESTACIONARIO 1D MALLA NO UNIFORME
## Simula conduccion de calor estacionario utilizando diferencias finitas
## Permite la utilizacion de una malla NO UNIFORME.
##
## function [ phi ] = conduccionCalor_estacionario_no_homogeneo_1d (cant_x, Lx, 
##                             dirich_1=0, dirich_2=1, neumman_1=-1, neumman_2=-1, 
##                             Q=@Q_default, k=@k_default, c=@c_default,
##                             phi_amb=@phi_amb_default)
##
##
## Parametros:
## cant_x : Cantidad de puntos.
## Lx : Largo de la varilla.
## dirich_1 = 0: condicion Dirichlet x=0
## dirich_2 = 1: condicion Dirichlet x=L
## neumann_1:
## neumann_2:
## Q(x): Fuente o sumidero de calor
## k(x) : Constante de conductividad.
## c(x) : Calor específico del material de la varila.
## phi_amb(x) : Temperatura ambiente.
##
##
## Devuelve:
## Campo de temperaturas phi.
##
#### conduccionCalor_estacionario_no_homogeneo_1d
## Author: Marcos <marcosyedro@gmail.com>
## Created: 2013-09-06
##------------------------------------------------------------------------------

function [ phi ] = conduccion_calor_estacionario_no_homogeneo_1d (cant_x, Lx, 
                             tipo_cond =[0 0], val_cond =[1 0],
                             Q=@Q_default, k=@k_default, c=@c_default,
                             phi_amb=@phi_amb_default)

#   MALLA A UTILIZAR
#   dx = Lx/cant_x;
#   x = 0:dx:Lx;
#   x=[0 0.05 0.15 0.35 0.5 0.75 1];
    x=[0 0.05 0.1 0.15 0.2 0.35 0.45 0.5 0.6 0.75 0.9 1];

    # Creamos vectores h1, h2 y alpha (que vincula h1 y h2).
    h1 = [];
    h2 = [];
    alpha = [];

    for( i = 2 : length(x) - 1 )
        h1 = [h1, -x(i - 1) + x(i)];                
        h2 = [h2, x(i + 1) - x(i)];
        alpha = [alpha,  abs( h2(i-1)/h1(i-1) ) ];
    endfor  
    
    # Armamos tri-diagonal de la matriz. 
    diagonal = [];
    for( i=2:length(x)-1 )
        diagonal(i-1, :) = [ (2 * k( x(i) ) ) / ( h1(i-1)^2 * ( 1 + alpha(i-1) ) ) ,
                        (-2 * k( x(i) ) / ( alpha(i-1) * h1(i-1)^2) )  + c( x(i) ) ,
                        (2 * k( x(i) ) /  ( h1(i-1)^2 * alpha(i-1) * ( 1 + alpha(i-1) ) ) ) 
                        ];
    endfor

    if( tipo_cond(1) )  #Neumann en x = o

        h2_end = h1(1);
        h1_ficticio = h2_end;
        alpha_ficticio = h2/h1;
        
        factor_i = -2*k(x(1))/h2_end^2 + c(x(1));
        factor_i_mas_1 = 2*k(x(1))/h2_end^2;
        diagonal = [[0 factor_i factor_i_mas_1]; diagonal ];

        f(1) = -Q(x(1)) + c(x(1)) * phi_amb(x(1)) - 2 * val_cond(1)/h2_end;
        
#        factor_i = (2 * k(x(1)) * alpha_ficticio - 2 * k(x(1)) + h1_ficticio^2 * c(x(1)))/h1_ficticio^2 ...
#                    - 2 * k(x(i))/(h1_ficticio^2 * alpha_ficticio);
#        factor_i_mas_1 = 2 * k(x(1))/(h1_ficticio^2 * alpha_ficticio);
#       f(1) =  - Q(x(1)) + c(x(1)) * phi_amb(x(1)) - (2 * val_cond(1))/(h1_ficticio * alpha_ficticio);    

    else                #Dirichlet en x = 0

        diagonal = [[0 1 0]; diagonal ];
        f(1) = val_cond(1);    

    endif

    if( tipo_cond(2) )  #Neumann en x = Lx
        h1_end = h2(end);
        h2_ficticio = h1_end;
        alpha_ficticio = h2_ficticio/h1_end;

        factor_i = -2 * k(x(end))/h1_end^2 +c(x(end));
        factor_i_menos_1 = 2 * k(x(end))/h1_end^2;
        diagonal = [diagonal; [factor_i_menos_1 factor_i 0] ];

        f(length(x)) = -Q(x(end)) + c(x(end)) * phi_amb(x(end)) + 2 * val_cond(2)/h1_end;    
        
    else                #Dirichlet en x = Lx
        diagonal = [diagonal; [0 1 0] ];
        f( length(x) ) = val_cond(2);        
    endif

    # Armamos Matriz, convirtiendo el vector tridiagonal en Matriz.
    K  = diag( diagonal(:,2) );                #(diagonal prinicpal)
    K += diag( diagonal(2:end, 1), -1);        #(diagonal inferior)
    K += diag( diagonal(1:end-1, 3), +1);      #(diagonal superior)

    # Armamos termino independiente f
    for(i = 2:length(x) - 1)    
        f(i) = -Q( x(i) ) + c( x(i) ) * phi_amb( x(i) );
    endfor    

    # Resolvemos sistema.
    phi = K\f';

    # PLOTEO
    plot(x,phi);
    hold on;
    x2 = 0:0.1:1 ;   
    plot(x2, solucion_analitica(x2),'r');
    hold off;
    
endfunction



function [ Q_x ] = Q_default(x)
    Q_x = 1;# - 10 * x * (x+1);
endfunction

function [ k_x ] = k_default(x)
    k_x = 1;
endfunction

function [ c_x ] = c_default(x)
    c_x = 1;
endfunction

function [ phi_amb_x ] = phi_amb_default(x)
    phi_amb_x = 0;
endfunction

function [ T ] = solucion_analitica(x)
    k = -21 * cos(1)/sin(1);    
    T = k * sin(x) + 21 * cos(x) + 10 * x.^2 + 10*x - 20;
endfunction
