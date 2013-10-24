#! /usr/bin/octave -qf
1;
clear all;
clf;
close;

%%%%%%%%%%%%%% MI PLOTEADOR
function miplot(expression,symbol,range,extra='')
  ## we should be a little smarter about this
  t = linspace(min(range),max(range),400);
  x = zeros(size(t));
  j = 1;
  for i = t
    x(j) = to_double(subs(expression,symbol,vpa(t(j))));
    j++;
  endfor

  plot(t,x,extra);
endfunction

% Definimos un par de variables globales
L = M = 2;

%%% COLOCACION PUNTUAL 
x = [1/(M + 1) : 1/(M + 1) : 1 - 1/(M + 1)];

K = zeros(L, M);
f = zeros(L, 1);

for l = 1 : size(K, 1)
	for m = 1 : size(K, 2)
		K(l, m) = sin(pi * m * x(l));		
	end

	f(l) = -x(l) + sin(pi/2 * x(l));
end

a_cp = K \ f;

% Empezamos con todos los calculos simbolicos
symbols;

x = sym('x');

% Calculamos la analitica
phi_an= 1 + Sin(pi/2 * x);

%% Seguimos con CP
psi = x + 1;

phi_cp = phi_ga = psi;

for m = 1 : M

	Nm = Sin(pi * m * x);
	phi_cp += a_cp(m) * Nm;
	phi_ga += a_ga(m) * Nm;

end

splot(phi_cp, x, [0 : 1]);
hold on;

miplot(phi_an, x, [0 : 1], 'r');

miplot(phi_ga, x, [0 : 1], 'g');
hold off;