1;

cant_x = 14;         # Cantidad de nodos en x
cant_y = 15;         # Cantidad de nodos en y
Lx = 3;             # Tamanho del rectangulo en el eje x
Ly = 3;          # Tamanho del rectangulo en el eje y
Q = @Q_2d;              # Fuente
k = 1;              # La conductividad termica
C = 0;              # El calor especifico
phi_amb = 0;        # El valor de phi del ambiente

cond_contorno = [0 1 1 0];  # Un array que indica si estamos ante dirichlet (0) o neumann (1)
valor_cc_1 = 100 * ones(cant_y,1);
valor_cc_2 = 0 * ones(cant_x,1); 
valor_cc_3 = 0 * ones(cant_y,1);
valor_cc_4 = 100 * ones(cant_x,1);

[ phi ] = conduccionCalor_estacionario_2d (
    cant_x,         # Cantidad de nodos en x
    cant_y,         # Cantidad de nodos en y
    Lx,             # Tamanho del rectangulo en el eje x
    Ly,             # Tamanho del rectangulo en el eje y
    Q,              # Fuente
    k,              # La conductividad termica
    C,              # El calor especifico
    phi_amb,        # El valor de phi del ambiente
    cond_contorno,  # Un array que indica si estamos ante dirichlet (0) o neumann (1)
    valor_cc_1,
    valor_cc_2,
    valor_cc_3,
    valor_cc_4
    )