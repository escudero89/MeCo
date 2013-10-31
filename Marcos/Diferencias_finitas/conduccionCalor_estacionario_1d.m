##------------------------------------------------------------------------------
## CONDUCCION DEL CALOR ESTACIONARIO
## Simula conduccion de calor estacionario utilizando diferencias finitas
##
## function [ T ] = conduccionCalor_estacionario_1d (N ,L, c, k, Tamb, neumann_1 = 10, neumann_2 = 0 )
##
## Parametros:
## N : Cantidad de puntos.
## L : Largo de la varilla.
## c : Calor específico del material de la varila.
## k : Constante de conductividad.
## Tamb : Temperatura ambiente.
## neumann_1 = 10: condicion neumann x=0
## neumann_2 = 0 : condicion neumann x=L
##
## Devuelve:
## Campo de temperaturas T.
##
## Author: Marcos <marcosyedro@gmail.com>
## Created: 2013-08-25
##------------------------------------------------------------------------------



function [ T x] = conduccionCalor_estacionario_1d (N ,L, c, k, Tamb,
												neumann_1 = 10,
												neumann_2 = 0 )


#DISCRETIZAMOS DOMINIO
h = L/N;
x = [0:h:L-h];

#ARMAMOS SISTEMA DE ECUACIONES
# Matriz
M  = diag( ((-2 * k)/(h^2) + c) .* ones(N+2,1) ); # Armamos diagonal
M += diag( (k/h^2) .* ones(N+1,1), 1 ); # Armamos diagonal: +1
M += diag( (k/h^2) .* ones(N+1,1), -1 );# Armamos diagonal: -1

% disp("Matriz M")
% M

#Agregamos dos ecuaciones, por las condiciones de contorno
contorno_1 = [1 0 -1 zeros(1,N-1)];
contorno_2 = [zeros(1, N-1) -1 0 1];
M(1,:)   = contorno_1;
M(N+2,:) = contorno_2;

% disp("Matriz M con cond contorno")
% M

#Termino independiente 
b = (-Q(x)' + c * Tamb );
% disp("Termino independiente")
% b

#Condición Neumann
b = [neumann_1 * 2 * h/k ; b ; neumann_2 * 2 * h/k];
% disp("Termino independiente con cond contorno")
% b

## RESULTADOS Y GRAFICOS
T = M\b;

% disp("Temperaturas T")
% T

% plot(x, T(2 : length(T)-1) );
% xlabel("Coordenada x de la varilla");
% ylabel("Temperatura");

endfunction