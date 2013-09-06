#! /usr/bin/octave -qf
1;
clear all;

% Lo hice de forma analitica (a lo de armar las matrices)

% Datos

puntos = [0, 0.05, 0.15, 0.35, 0.5, 0.75, 1];
%puntos = [0 : 0.2 : 1];

phi = zeros(length(puntos) - 2, 1);
phi_0 = 1;
phi_L = 0;

f = phi;
K = zeros(length(phi));

Q = -10 .* puntos .* (puntos + 1);

for kP = 1 : length(phi)

    pos = kP + 1;

    h = puntos(pos) - puntos(pos - 1);
    r = (puntos(pos + 1) - puntos(pos)) / h;

    %%%%%%%%%%%%%%%%%%%%%%%% hasta aca uso pos

    M_abc = [1 1 1 ; -1 0 r ; .5 0 r*r/2];

    f_abc = [0 0 1/h^2]';

    abc = M_abc \ f_abc;

    % Ahora que tengo los coeficientes, voy armando la matriz para resolver las incognitas
    f(kP) = -Q(pos)';

    K(kP, kP) = abc(2) + 1;

    if (kP == length(phi))
        f(kP) -= abc(3) * phi_L;
    else
        K(kP, kP + 1) = abc(3);
    end

    % Si estoy en la primera fila
    if (kP == 1)
        f(kP) -= abc(1) * phi_0;
    else 
        K(kP, kP - 1) = abc(1);
    end

end

phi = K\f;
plot(puntos, [phi_0 ; phi ; phi_L]);

puntos = [0 : 0.01 : 1];
hold on;
plot(puntos, (-21 * cos(1)/sin(1)) * sin(puntos) + 21 * cos(puntos) + 10 * puntos.^2 + 10 * puntos - 20, 'r');
hold off;