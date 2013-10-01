1;
clear all;
clc;


function [ret] = fuente(r, tita)

  ret = 1;

endfunction


cant_r = 20;          
cant_tita = 28;      
r1 = 0.01;             
r2 = 3;          
tita1 = 0;   
tita2 = 2*pi;       
Q = @fuente;       
k = 1 * ones(cant_r,cant_tita);

cond_contorno = [1 1 0 1];  # Un array que indica si estamos ante dirichlet (0) o neumann (1)
valor_cc_1 = 0 * ones(cant_tita,1);
valor_cc_2 = 0 * ones(cant_r,1); 
valor_cc_3 = 10 * ones(cant_tita,1);
valor_cc_4 = 0 * ones(cant_r,1);

conduccion_calor_corona(
    cant_r,         # Cantidad de nodos radiales
    cant_tita,      # Cantidad de nodos angulares
    r1,             # Tamanho del radio interior
    r2,             # Tamanho del radio exterior
    tita1,          # Tamanho del angulo inicial
    tita2,          # Tamanho del angulo final
    Q,              # Fuente, funcion
    k,              # La conductividad termica
    cond_contorno,  # Un array que indica si estamos ante dirichlet (0) o neumann (1)
    valor_cc_1,     # En borde r=r1 para todo tita
    valor_cc_2,     # En borde tita=tita2 para todo r
    valor_cc_3,     # En borde r=r2 para todo tita    
    valor_cc_4      # En borde tita=tita1 para todo r
    )