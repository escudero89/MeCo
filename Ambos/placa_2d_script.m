1;

cant_x = 20;         % Cantidad de nodos en x
cant_y = 25;         % Cantidad de nodos en y
Lx = 100;             % Tamanho del rectangulo en el eje x
Ly = 100;          % Tamanho del rectangulo en el eje y
q = -1;              % Carga distribuida
D = 1;              % Rigidez a la flexion

cond_contorno = [0 1 1 0];  % Un array que indica si estamos ante soporte simple (0), empotrado (1), libre (2).
valor_cc_1 = 100 * ones(cant_y,1);
valor_cc_2 = 100 * ones(cant_x,1); 
valor_cc_3 = 100 * ones(cant_y,1);
valor_cc_4 = 100 * ones(cant_x,1);

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

