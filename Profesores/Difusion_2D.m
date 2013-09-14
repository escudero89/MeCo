function [T,K,b] = Difusion_2D(Lx,Ly,dx,dy)

% RESOLVEREMOS EL PROBLEMA DE CONDUCCION DEL CALOR EN UN
% RECIENTO RECTANGULAR (2D) CON DIMENSIONES Lx Ly CON LOS SIGUIENTES DATOS:

% La ecuacion a resolver es (d2Tdx2 + d2Tdy2) = Q o bien
% Laplaciano(T) = Q
% T: temperatura valor del campo a calcular.
% Q: fuente o sumidero de calor.
% Temperatura impuesta en todo el contorno.
% Usamos un esquema de segundo orden con un espaciamiento homogeneo en la 
% direccion 'x' y en la direccion 'y'

% Determinamos el espaciamiento de la malla en ambas direcciones
% Lx : dimension espacial en direccion "x", Ly: en direccion "y"
% (Nx) Cantidad de nodos en la direccion x
% (Ny) Cantidad de nodos en la direccion y
% (Nx-2) Cantidad de nodos en la direccion x interiores
% (Ny-2) Cantidad de nodos en la direccion y interiores

    Nx = 0:dx:Lx; NX = length(Nx);
    Ny = 0:dy:Ly; NY = length(Ny);

    d2x= dx*dx;
    d2y= dy*dy;

% Alocamos espacio de almacenamiento en memoria de la matriz de coeficientes y del vector
% del lado derecho.

    N = (NX)*(NY);
    K = zeros(N,N);
    b = zeros(N,1);

    condDir=0; % condicion Dirichlet impuesta en toda la frontera
    Q = -10; % fuente uniformemente distribuida en todo el dominio
% A los efectos de obtener un menor ancho de banda de la matriz, es conveniente recorrerla
% en la direccion de la menor longitud. 


% Esquema para construir la matriz del sistema
    if (NX >= NY)
        for i=1:NX
            for j=1:NY
                p =(i-1)*(NY)+j; % numero de nodo recorriendo en direccion y, basdo en
                                 % los indices (i,j)

% Imponemos las condiciones de borde para este problema. Son condiciones de borde Dirichlet.
%                                          Norte (p+1)
%                                             |
% Esquema Utilizado     Oeste (p-NY) ----- Centro ----- Este (p+NY)
%                                             |
%                                          Sur (p-1)
                if ((i == 1) || (i == NX) || (j == 1) || (j == NY))
                    K(p,p) = 1;  % Matriz
                    b(p) = condDir;  % Contorno
                else
                    A = -2*(d2x+d2y);
                    K(p,p) = A;
                    K(p,p+1) = d2x;
                    K(p,p-1) = d2x;
                    K(p,p+NY) = d2y;
                    K(p,p-NY) = d2y;
                    b(p) = Q*(d2x*d2y);
                end
            end
        end
        T = K\b;     
        res = reshape(T,NY,NX); % reparto en el vector T en una matriz
    else
        for i=1:NY
            for j=1:NX
                p =(i-1)*(NX)+j; % numero de nodo recorriendo en direccion x, basdo en
                                 % los indices (i,j)
                
% Imponemos las condiciones de borde para este problema. Son condiciones de borde Dirichlet.
%                                       Norte (p+NX)
%                                            |
% Esquema Utilizado     Oeste (p-1) ----- Centro ----- Este (p+1)
%                                            |
%                                        Sur (p-NX)
                if ((i == 1) || (i == NY) || (j == 1) || (j == NX))
                    K(p,p) = 1;  % Matriz
                    b(p) = condDir;  % Contorno
                else
                    A = -2*(d2x+d2y);
                    K(p,p) = A;
                    K(p,p+1) = d2y;
                    K(p,p-1) = d2y;
                    K(p,p+NX) = d2x;
                    K(p,p-NX) = d2x;
                    b(p) = Q*(d2x*d2y);
                end
            end
        end
        T = K\b;
        res = reshape(T,NX,NY); % reparto en el vector T en una matriz
    end

    % VISUALIZACION
    [nx,ny] = meshgrid(Nx,Ny);
    figure(1)
    mesh(nx,ny,res)
    figure(2)
    h = surf(nx,ny,res);
    set(h,'AmbientStrength',0.5,'DiffuseStrength',0.5,'SpecularStrength',0.8,'SpecularExponent',10)
    material([0.5,0.5,0.8,10])
    figure(3)
    h = surf(nx,ny,res); shading interp
    view(-45,45)
    lightangle(-45,30); lighting phong
end

