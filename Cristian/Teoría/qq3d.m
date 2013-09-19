function [xnod, icone] = qq3d(x1,x2,x3)
%
%   Obtiene una malla como producto cartesiano entre tres
%   vectores de nodos "x1" , "x2" y "x3".
%   x1(N1,1:ndm) x2(N2,1:ndm) y x3(N3,1:ndm)
%   Si x3 no existe hace una malla 2d, en este caso x1 y x2 tienen
%   2 coordenadas
%
%   Entiende que la malla esta alineada con los ejes cartesianos

    % Cantidad de nodos
    ndm = 2;
    N3  = 1;

    if nargin == 3, ndm=3; end % Si pasamos tres argumentos, 3d

    %% Lo que hacemos aca es transformar los vectores columnas en matrices con ceros en las otras dos columnas

    [N1, m1] = size(x1);
    if (m1 != 1), error([' Ver dimension del vector x1, m1 = ' num2str(m1)]);end

    [N2, m2] = size(x2);
    if (m2 != 1), error([' Ver dimension del vector x2, m2 = ' num2str(m2)]);end

    x1 = [x1, zeros(N1, ndm-1)];
    x2 = [zeros(N2, 1), x2, zeros(N2, ndm-2)];

    if ndm == 3,

        [N3, m3] = size(x3);
        if (m3 != 1), error([' Ver dimension del vector x3, m3 = ' num2str(m3)]);end

        x3 = [zeros(N3, ndm-1), x3];

    end

    % En x2d guardo a todos los puntos que conforman la malla, como columnas
    x2d  = [];
    xnod = [];

    for k = 1 : N2,
        x2d = [x2d ; [x1(:, 1), x1(:, 2)] + ones(N1, 1) * [x2(k, 1), x2(k, 2)] ];
    end

    n2d = length(x2d(:,1));

    % En el caso especial 3d, xnod no es igual a x2d (hacemos un tratamiento similar al de arriba)
    if  ndm == 3,
        
        for k = 1 : N3,
            xnod = [xnod ;
                x2d(:, 1) + ones(n2d, 1) * x3(k, 1), ...
                x2d(:, 2) + ones(n2d, 1) * x3(k, 2), ...
                ones(n2d, 1) * x3(k, 3) ];
        end

    else

        xnod = x2d;

    end

    % Guardamos aca en cada fila los puntos que conforman las aristas
    % Ejemplo, inode = [1 2 5 4], es decir, la primera arista contiene esos 
    % puntos (en sentido antihorario)
    icone = [];
    ico2d = [];

    ico = [ (1 : N1-1)' , (2 : N1)' , (2 : N1)' + N1 , (1 : N1-1)' + N1 ];

    for k = 1 : N2-1,
    	ip = (k-1) * N1;
    	ico2d = [ ico2d; ico+ip ];
    end
    
    % Nuevamente, para el caso 3d aparte
    if  ndm == 3,

        for k = 1 : N3-1,
            ip = (k-1)*n2d;
            icone = [icone ;[ ip+ico2d ip+n2d+ico2d ]];
        end

    else

        icone = ico2d;

    end
    
    return;
end