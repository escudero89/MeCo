#! /usr/bin/octave -qf

% Argumentos:
%% h : alto de la viga.
%% l : largo de la viga.
%% dx : paso.
%% E : modulo de elaticidad (mod. de young).
%% cond_contorno : condicion en los contornos (0: apoyo simple, 1 : apoyo empotrado , 2 : apoyo libre) [x0 xl]
%% val_contorno : valor de las condiciones en los contornos
%% @q : funcion de peso distribuido.
%% q0 : parametros para la funcion de carga distribuida

function [PHI] = viga_1d(l, dx, h, E, cond_contorno, val_contorno, q = @q_default, q0 = 1)

	%% Definimos un par de variables genericas
	xx = 0 : dx : l;

	% Inercia
	I = l * h^3 / 12;

	% Rigidez a la flexion
	EI = E * I;

	% Incognita y sistema matricial
	f = zeros(length(xx), 1);
	K = zeros(length(f));
	phi = f;

	% Establezco una variable begin para hacer juego con la end
	begin = 1;
	dx4 = dx^4;

	% Armo el sistema
	for i = 1 : length(f)

		% Evito ambos dos puntos extremos (notese que empiezo en la fila 3)
		if (i < length(f) - 3)

			pos = i + 2;

			K(pos, pos) = 6;

			K(pos, pos - 1) = 1;
			K(pos, pos - 2) = -4;

			K(pos, pos + 1) = -4;
			K(pos, pos + 2) = 1;

		end

		f(i) = q(xx(i), l, q0) * dx4 / (EI);

	end

	%% AHORA CON LAS CONDICIONES DE CONTORNO
	% Vamos con el caso mas simple, apoyo simple

	if (cond_contorno(begin) == 0)

		% Primera fila
		K(begin, begin) = 1;
		f(begin) = val_contorno(begin);

		% Segunda fila se determina usando el conocimiento del Momento
		pos = begin + 1;
		
		K(pos, pos - 1) = -2;
		K(pos, pos) = 5;
		K(pos, pos + 1) = -4;
		K(pos, pos + 2) = 1;

		f(pos) = q(xx(pos), l, q0) * dx4 / EI;

	end

	% El otro extremo
	if (cond_contorno(end) == 0)

		% Ultima fila
		K(end, end) = 1;
		f(end) = val_contorno(end);

		% Penultima fila se determina usando el conocimiento del Momento
		pos = length(f) - 1;
		
		K(pos, pos - 2) = 1;
		K(pos, pos - 1) = -4;
		K(pos, pos) = 5;
		K(pos, pos + 1) = -2;

		f(pos) = q(xx(pos), l, q0) * dx4 / EI;

	end
[K f]
pause;
	PHI = K \ f;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Funciones por default                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ret] = q_default(x, l = 1, q0 = 1)
	
	ret = q0 * (1 - x/l);

	return;
end