#! /usr/bin/octave -qf
1;
clear all;

phi_0 = 10;
phi_L = 10;

L = 10;

delta_x = 0.1;
puntos = L/delta_x;

x = 0 : delta_x : L;

color = ['rgbcmykrgbcmykrgbcmyk'];
pos = 0;

clf;
% c_k es c/k
for c_k = [0.001 0.01 0.1 1 10 100 1000 1000]

	pos += 1;

	K = diag(ones(puntos, 1), 1) + diag(ones(puntos, 1), -1);

	center = - ( 2 + delta_x^2 * c_k);
	K += diag(ones(puntos + 1, 1) * center);

	f = [-phi_0 zeros(1, puntos - 1) -phi_L]';

	phi = K \ f;

	plot(x, phi, color(pos));
	ylim([0, 10]);

	hold on;

	pause;

end

hold off;