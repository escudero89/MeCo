% Se lo paso en forma de filas a los puntos
% Devuelve si hubo interseccion (0 no hubo, 1 unica, 2 coincidente) y dos puntos
% el segundo punto es [0 0] al menos que sea coincidente (devuelve rango)
function [hay_inter, punto_inter] = hay_interseccion(P1,P2,A1,A2)

    hay_inter = 0;
    punto_inter = [0 0 0 0];

    K = [(P2 - P1)' , (A1 - A2)'];
    f = [(A1 - P1)'];

    % Sistema compatible determinado
    if (abs(det(K)) > 0.001)

        t = K \ f;

        if (sum(t >= 0) == 2 && sum(t <= 1) == 2)
            
            punto_inter = [ P1 + (P2 - P1) * t(1) , 0 , 0 ];
            hay_inter = 1;

        endif

    % Sistema compat. indeterminado o incompatible @TODO
    else
        
        % Son coincidentes (necesito el 0 para el producto cruz con 3 dim)
        if !(sum((cross([A2 - P1 , 0], [P2 - P1 , 0]))(1:2)) < eps)
            
            hay_inter = 2;

            punto_inter = [];

            P = [P1 ; P2 ; A1 ; A2];
            P_sum = [sum(P1), sum(P2), sum(A1), sum(A2)];
            
            [temp max_P] = max(P_sum);
            [temp min_P] = min(P_sum);

            idx = 1:4;

            for i = idx
                % Estoy en uno de los dos puntos que no son min ni max
                if (i != max_P && i!= min_P)

                    punto_inter = [punto_inter , P(i, :)];

                endif

            endfor

        endif

    endif

#{

    clf;
    hold on;
    line([P1(1), P2(1)], [P1(2), P2(2)]);
    line([A1(1), A2(1)], [A1(2), A2(2)]);
    plot(punto_inter(:, 1), punto_inter(:, 2), 'xm');
    hold off;
#}
endfunction
