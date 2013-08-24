#! /usr/bin/octave -qf
1;
clear all;

% Valores de ejemplo
E = 2 * exp(11)
v = 0.1

L_x = 1;
L_y = 1;

% tamanho del delta_x/y y los ejes
N = 100;
Delta = 1 / N;

axis_X = 0 : Delta : L_x;
axis_Y = 0 : Delta : L_y;

[XX, YY] = meshgrid(axis_X, axis_Y);

% Tensor de tensiones (lo defino antes de ponerme a trabajar con symbolos)
D_33 = [1 v 0 ; v 1 0 ; 0 0 (1-v)/2];
D = E / (1 - v^2) * D_33;

% Declaro variables simbolicas (octave-symbolic)
symbols
x = sym('x');
y = sym('y');

u = -0.1 * Sin(pi * x / L_x) * Cos(pi * y / (2 * L_y));
v = -0.1 * Sin(pi * x / (2 * L_x)) * Cos(pi * y / L_y);

% Tensor de deformacion:
e_xx = differentiate(u, x);
e_yy = differentiate(v, y);
e_xy = differentiate(u, y) + differentiate(v, x);

% Dado a que en symbolic, no puedo definir matrices que tenga syms dentro, hago:
t_xx = D(1, 1) * e_xx + D(1, 2) * e_yy + D(1, 3) * e_xy;
t_yy = D(2, 1) * e_xx + D(2, 2) * e_yy + D(2, 3) * e_xy;
t_xy = D(3, 1) * e_xx + D(3, 2) * e_yy + D(3, 3) * e_xy;

% Fuerzas opuestas en las direcciones x / y
b_x = -1 * ( differentiate(t_xx, x) + differentiate(t_xy, y) )
b_y = -1 * ( differentiate(t_xy, x) + differentiate(t_yy, y) )

% No se bien como graficarlo aun
e_graph = [];
t_graph = [];

for xx = axis_X 
	for yy = axis_Y
		
		e_xx_solved = sym2poly(subs(e_xx, {x, y}, {xx, yy}));
		e_yy_solved = sym2poly(subs(e_yy, {x, y}, {xx, yy}));
		e_xy_solved = sym2poly(subs(e_xy, {x, y}, {xx, yy}));

		e_graph = [e_graph ; e_xx_solved e_yy_solved e_xy_solved];

		%%

		t_xx_solved = sym2poly(subs(t_xx, {x, y}, {xx, yy}));
		t_yy_solved = sym2poly(subs(t_yy, {x, y}, {xx, yy}));
		t_xy_solved = sym2poly(subs(t_xy, {x, y}, {xx, yy}));

		t_graph = [t_graph ; t_xx_solved t_yy_solved t_xy_solved];

	end
end