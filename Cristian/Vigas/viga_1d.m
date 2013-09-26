#! /usr/bin/octave -qf

% Argumentos:
%% h : alto de la viga.
%% l : largo de la viga.
%% dx : paso.
%% E : modulo de elaticidad (mod. de young).
%% cond_contorno : condicion en los contornos 
%%% u(x0) , u(xl) 					[col 1] u
%%% du/dx (x0) , du/dx (xl) 		[col 2] 
%%% d2u/dx2 (x0) , d2u/dx2 (xl) 	[col 3] M
%%% d3u/dx3 (x0) , d3u/dx3 (xl) 	[col 4] Q
%% Si vale 0 no lo considero, si vale 1 si.
%% val_contorno : valor de las condiciones en los contornos (notese que son 8 valores)
%% @q : funcion de peso distribuido.
%% q0 : parametros para la funcion de carga distribuida

% Retorna:
%% u : Puntos de deflexion "u"
%% M : momento flector en cada punto
%% Q : esfuerzo cortante debido a la flexion

function [u, M, Q] = viga_1d(l, dx, h, E, cond_contorno, val_contorno, q = @q_default, q0 = 1, k = @k_default)

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
	dx2 = dx^2;
	dx4 = dx^4;

	% Armo el sistema
	for i = 1 : length(f)

		% Evito ambos dos puntos extremos (notese que empiezo en la fila 3)
		if (i < length(f) - 3)

			pos = i + 2;

			K(pos, pos) = 6;

			K(pos, pos - 1) = -4;
			K(pos, pos - 2) = 1;

			K(pos, pos + 1) = -4;
			K(pos, pos + 2) = 1;

		end

		f(i) = q(xx(i), l, q0) * dx4 / (EI);

	end

	%% AHORA CON LAS CONDICIONES DE CONTORNO
	% En el caso de que conozcamos el valor de u(x0)

	if (cond_contorno(begin, 1))

		% Primera fila
		K(begin, begin) = 1;
		f(begin) = val_contorno(begin, 1);

		% Segunda fila se determina usando el conocimiento del Momento
		pos = begin + 1;
		
		if (cond_contorno(begin, 2)) % du/dx

			K(pos, pos - 1) = -4;
			K(pos, pos) = 7;
			K(pos, pos + 1) = -4;
			K(pos, pos + 2) = 1;

			% @TODO revisar los f(pos), que pueden ser agilizados (mirar linea 62)
			f(pos) = ( q(xx(pos), l, q0) * dx4 / EI ) - ( 2 * dx * val_contorno(begin, 2) );

		elseif (cond_contorno(begin, 3)) % d2u/dx2 [M]

			K(pos, pos - 1) = -2;
			K(pos, pos) = 5;
			K(pos, pos + 1) = -4;
			K(pos, pos + 2) = 1;

			f(pos) = dx2 * ( q(xx(pos), l, q0) * dx2 / EI - val_contorno(begin, 3) );
		
		else % Sin ninguno de los datos no puedo trabajar

			disp ('--------------------------------------------------------------------');
			disp ('ERROR: No se pasaron los datos requeridos: du/dx, d2u/dx2, o d3u/dx3');
			disp ('--------------------------------------------------------------------');
			return;

		end

	% En el caso de que conozcamos el valor de u''(x0) y u'''(x0) (soporte simple)
	elseif (cond_contorno(begin, 3) && cond_contorno(begin, 4))

		% Primera fila
		K(begin, begin) = -6 + k(xx(begin)) * dx4/EI;
		K(begin, begin+1) = 4;

		f(begin) += 2 * dx2 * (3 * val_contorno(begin, 3) - val_contorno(begin, 4) * dx);

		% Segunda fila 
		pos = begin + 1;

		K(pos, pos - 1) = -2;
		K(pos, pos) = 5 + k(xx(pos)) * dx4/EI;
		K(pos, pos + 1) = -4;
		K(pos, pos + 2) = 1;

		f(pos) += -val_contorno(begin, 3) * dx2;

	end

	% El otro extremo u(xl)
	if (cond_contorno(end, 1))

		% Ultima fila
		K(end, end) = 1;
		f(end) = val_contorno(end, 1);

		% Penultima fila se determina usando el conocimiento del Momento o de u', lo que conozca
		pos = length(f) - 1;

		if (cond_contorno(end, 2)) % du/dx

			K(pos, pos - 2) = 1;
			K(pos, pos - 1) = -4;
			K(pos, pos) = 7;
			K(pos, pos + 1) = -4;

			f(pos) = ( q(xx(pos), l, q0) * dx4 / EI ) - ( 2 * dx * val_contorno(end, 2) );

		elseif (cond_contorno(end, 3)) % d2u/dx2 [M]
			
			K(pos, pos - 2) = 1;
			K(pos, pos - 1) = -4;
			K(pos, pos) = 5;
			K(pos, pos + 1) = -2;

			f(pos) = dx2 * ( q(xx(pos), l, q0) * dx2 / EI - val_contorno(end, 3) );

		else % Sin ninguno de los datos no puedo trabajar

			disp ('ERROR: No se pasaron los datos requeridos: du/dx o d2u/dx');
			return;

		end

	% En el caso de que conozcamos el valor de u''(xL) y u'''(xL) (soporte simple)
	elseif (cond_contorno(end, 3) && cond_contorno(end, 4))

		% Primera fila
		K(end, end) = 2 + k(xx(end)) * dx4/EI;
		K(end, end-1) = -4;

		f(end) += 2 * dx2 * (val_contorno(end, 3) - val_contorno(end, 4) * dx);

		% Segunda fila 
		pos = length(f) - 1;

		K(pos, pos - 2) = 1;
		K(pos, pos - 1) = -4;
		K(pos, pos) = 5 + k(xx(pos)) * dx4/EI;
		K(pos, pos + 1) = -2;

		f(pos) += -val_contorno(end, 3) * dx2;

	end

	u = K \ f;

	%% ESTO ES PARA TENER A CONSIDERACION EL MOMENTO y el ESFUERZO CORTANTE

	M = EI / dx2 * ones(length(u), 1);

	% Extremo M(x0) [d2u/dx2]
	if (cond_contorno(begin, 3))
		M(begin) = val_contorno(begin, 3);
	else
		% Aproximacion por cuatro puntos (d2u/dx2) [error dx2] (es *, no = {no asigna})
		M(begin) *= 2 * u(begin) - 5 * u(begin+1) + 4 * u(begin+2) - 1	* u(begin+3);
	end

	% Extremo M(xl)
	if (cond_contorno(end, 3))
		M(end) = val_contorno(end, 3);
	else
		M(end) *= 2 * u(end) - 5 * u(end-1) + 4 * u(end-2) - 1	* u(end-3);
	end

	% Los extremos no los conocemos
	for i = 2 : length(u) - 1
		M(i) *= u(i-1) - 2 * u(i) + u(i+1);
	end

	%% ESFUERZO CORTANTE

	Q = 1 / (2 * dx) * ones(length(u), 1);

	% Extremo Q(x0) [d3u/dx3]
	if (cond_contorno(begin, 4))
		Q(begin) = val_contorno(begin, 4);
	else
		% Aproximacion usando 3 puntos para la primera derivada [error dx2] (es *, no = {no asigna})
		Q(begin) *= -3 * M(begin) + 4 * M(begin+1) - M(begin+2);
	end

	% Extremo Q(xl)
	if (cond_contorno(end, 4))
		Q(end) = val_contorno(end, 4);
	else
		Q(end) *= 3 * M(end) - 4 * M(end-1) + M(end-2);
	end

	% Resto de puntos
	for i = 2 : length(u) - 1
		Q(i) *= M(i+1) - M(i-1);
	end

	return;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Funciones por default                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ret] = q_default(x, l = 1, q0 = 1)
	
	ret = 1 * (1 - x/l);

	return;
end

function [ret] = k_default(x)
	
	ret = 0;

	return;
end