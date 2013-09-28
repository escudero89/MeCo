1;

cant_x = 30;         % Cantidad de nodos en x
cant_y = 30;         % Cantidad de nodos en y
Lx = 1;             % Tamanho del rectangulo en el eje x
Ly = 1;          % Tamanho del rectangulo en el eje y
q = -1;              % Carga distribuida
D = 1;              % Rigidez a la flexion

cond_contorno = [1 1 1 1];  % Un array que indica si estamos ante soporte simple (0), empotrado (1), libre (2).
%cond_contorno = [0 0 0 0];  % Un array que indica si estamos ante soporte simple (0), empotrado (1), libre (2).
valor_cc_1 = 0 * ones(cant_y,1);
valor_cc_2 = 0 * ones(cant_x,1); 
valor_cc_3 = 0 * ones(cant_y,1);
valor_cc_4 = 0 * ones(cant_x,1);

[ phi ] = placa_2d (
    cant_x,         % Cantidad de nodos en x
    cant_y,         % Cantidad de nodos en y
    Lx,             % Tamanho del rectangulo en el eje x
    Ly,             % Tamanho del rectangulo en el eje y
    q,              % Carga distribuida
    D,              % Rigidez a la flexion
    cond_contorno,  % Un array que indica si estamos ante soporte simple (0), empotrado (1), libre (2).
    valor_cc_1,         
    valor_cc_2,
    valor_cc_3,
    valor_cc_4
    )

