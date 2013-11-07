%////////////////////
% Guia 2 - Ejercicio 3
%////////////////////
%
% Ecuacion diferencial a Resolver:  y''+ y + 1 = 0,  
% Condiciones de Contorno:          y(0)=0,y'(1) + y(1) = 0
% Método de Ponderación:            Galerkin.
% Integracion:                      Numerica.
%////////////////////
function [psi N a] = ejercicio3(M, paso)

%       Parametros
if nargin < 2
    paso =   0.01;
end

% Cantidad de funciones de forma.    
    L = M;
% Dominio, para fines de graficacion e integracion
    x = -1:paso:1-paso;
    y = -1:paso:1-paso;
    [X, Y] = meshgrid(x,y);
% Funcion psi, que satisface el contorno.
    psi = (1-Y.^2) + (1-X.^2);
    
    %mesh(X,Y,psi);
    
% OBTENEMOS FUNCIONES DE FORMA
    N_temp = zeros(length(x), length(y));
    d2_N = N_temp;
    d1_N = N_temp;
    for m = 1 : M 
       % Generamos las funciones
        N{i}= sin(pi * X.^2 * m) .* sin(pi * Y.^2 * m);
       
       % Obtenemos las derivadas necesarias (numericamente, "diff")
        aux_d2x = diff(N{1},2); %TODO DERIVADA RESPECTO DE X
        aux_d2y = diff(N(m,:)); %TODO DERIVADA RESPECTO DE Y

        % Duplicamos primer y/o ultimo elemento...
        % (Se perdierden en la diferenciacion)
        
        d2_N(m,:) = [aux_d2(1), aux_d2, aux_d2(end)];
        d1_N(m,:) = [aux_d1, aux_d1(end)];
               
    end    
  
% ARMAMOS LA MATRIZ USANDO INTEGRACION NUMERICA ("trap")
    for l = 1 : L
        for m = 1 : M
            %(El end, equivale a evaluar el borde x=1)                     
            K(l,m) = paso * trapz( (d2_N(m,:) + N(m,:)) .* N(l,:)) ...
                     + (d1_N(m,end) + N(m,end))*N(l,end); 
        end
        f(l) = - paso * trapz(N(l,:));
  
    end
  
  % Resolvemos el sistema
  a = K\f';
  
  % Generamos la funcion solucion
  for m = 1 : M
    psi = psi + a(m)*N(m,:);
  end
    
  % Solución analítica
      analitica = (cos(x).*(sin(1)+cos(1))+sin(x).*(1+sin(1)-cos(1))...
                    -sin(1)-cos(1))./(sin(1)+cos(1));
                
      plot(x,analitica);
      hold on
  % Aproximacion
      plot(x,psi,'r');
      hold off
  
  ret = psi;
  
end
  