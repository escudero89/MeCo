%////////////////////
% Guia 2 - Ejercicio 2
%////////////////////
%
%Aproximar funcion: phi(x) = 1 + sin(pi/2 * x)
%Intervalo:         0 <= x <= 1
%Método de int:     Colocación puntual
%////////////////////
function [ret] = ejercicio1(M)

%       Parametros
% Cantidad de funciones de forma.
    %M = 5;
    L = M;
% Dominio, solo para fines de graficacion
    x = 0:0.01:1;
% Funcion psi, que satisface el contorno.
    psi = x + 1;
% Funciones de forma
    N = zeros(M,length(x));
    for m = 1 : M 
       N(m,:)= sin(pi * x' * m);
    end
  
% Puntos de colocación
    for l = 1 : L
      puntos(l) = ((1/L)*l) - 1/(2*L);
    end
  % Armamos la matriz
    for l = 1 : L
        for m = 1 : M
          K(l,m) = sin(pi * puntos(l) * m);

        end
        f(l) = sin(pi/2 * puntos(l)) - puntos(l);
    end
  
  % Resolvemos el sistema
  a = K\f';
  
  % Generamos la funcion solucion
  for m = 1 : M
    psi = psi + a(m)*N(m,:);
  end
  
  % Original
      plot(x,1+sin(x*pi/2));
      hold on
  % Aproximacion
      plot(x,psi,'r');
      hold off
  
  ret = psi;
  
end