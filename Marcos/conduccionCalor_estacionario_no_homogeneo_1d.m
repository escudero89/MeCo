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

function [ phi ] = conduccionCalor_estacionario_no_homogeneo_1d (cant_x, Lx, 
                             dirich_1=1, dirich_2=0, neumman_1=-1, neumman_2=-1, 
                             Q=@Q_default, k=@k_default, c=@c_default,
                             phi_amb=@phi_amb_default)

    dx = Lx/cant_x;
    x = 0:dx:Lx-dx;
#    x=[0 0.05 0.15 0.35 0.5 0.75 1];
    

  ## SI DIRICHLET
    
    h1 = [];
    h2 = [];
    alpha = [];
  
    
    # Creamos vectores h1, h2 y alpha (que vincula h1 y h2).
    for( i = 2 : length(x) - 1 )
        h1 = [h1, x(i - 1)-x(i )];                
        h2 = [h2, x(i + 1)-x(i)];
        alpha = [alpha,  abs( h2(i-1)/h1(i-1) ) ];
    endfor

    # Armamos tri-diagonal de la matriz. 
    diagonal = [];

    
    for( i=2:length(x)-1 )
        diagonal(i-1, :) = [ (2 * k( x(i) ) ) / ( h1(i-1)^2 * ( 1 + alpha(i-1) ) ) ,
                        (-2 * k( x(i) ) / ( h1(i-1)^2) )  + c( x(i) ) ,
                        (2 * k( x(i) ) /  ( h1(i-1)^2 * alpha(i-1) * ( 1 + alpha(i-1) ) ) ) 
                        ];                
    endfor

    #Agregamos condiciones de contorno Dirichlet en la diagonal
    diagonal = [[0 1 0]; diagonal ];
    diagonal = [diagonal; [0 1 0] ];

    # Armamos Matriz, convirtiendo el vector tridiagonal en Matriz.
    K  = diag( diagonal(:,2) );                #(diagonal prinicpal)
    K += diag( diagonal(2:end, 1), -1);        #(diagonal inferior)
    K += diag( diagonal(1:end-1, 3), +1);      #(diagonal superior)
    
    K
    pause

    # Armamos termino independiente f
    f(1) = dirich_1;    
    for(i = 2:length(x) - 1)    
        f(i) = -Q( x(i) ) + c( x(i) ) * phi_amb( x(i) );
    endfor
    f( length(x) ) = dirich_2;
    
    f
    pause
    # Resolvemos sistema.
    phi = K\f';


  ## PLOTEO
    plot(x,phi);
    
    
endfunction



function [ Q_x ] = Q_default(x)
    Q_x = - 10 * x * (x+1);
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
