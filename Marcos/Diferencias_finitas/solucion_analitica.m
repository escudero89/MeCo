##------------------------------------------------------------------------------
## CONDUCCION DEL CALOR ESTACIONARIO
## Solucion analitica de conduccion de calor estacionario 1d
##
## function [ T ] = conduccionCalor_estacionario_1d (N ,L, c, k, Tamb, neumann_1 = 10, neumann_2 = 0 )
##
## Parametros:
## N : Cantidad de puntos.
## L : Largo de la varilla.
##
## Valores fijos:
## c : 1
## k : 1
## Tamb : 0
## neumann_1 = 10: condicion neumann x=0
## neumann_2 = 0 : condicion neumann x=L
##
## Devuelve:
## Campo de temperaturas T.
##
## Author: Marcos <marcosyedro@gmail.com>
## Created: 2013-08-25
##------------------------------------------------------------------------------

function [ T x] = solucion_analitica(N, L)
#DISCRETIZAMOS DOMINIO
h = L/N;
x = [0:h:L-h];
T = 4 * x .^ 2 - 4 * x - 8 + 0.90 * cos(x) - 6 * sin(x);

% disp("Temperaturas T")
% T

% plot(x, T);
% xlabel("Coordenada x de la varilla");
% ylabel("Temperatura");

endfunction