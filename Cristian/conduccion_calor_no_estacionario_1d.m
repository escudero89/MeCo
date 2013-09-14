function [PHI] = conduccion_calor_no_estacionario_1d(
	tipo_df,
	phi_0,
	Lx,
	dx,
	t_f,
	dt,
	tipo_cond,	% array dirichlet(0), neumann(1)
	val_cond,		
	k = @k_default,
	c = @c_default,
	phi_amb= @phi_amb_default,
	Q = @Q_default
 	)

	% FORWARD EULER
	if (tipo_df == 1)
 		PHI = fordward_euler(phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond, k, c, phi_amb, Q);
	
 	% BACKWARD EULER
 	elseif (tipo_df == 2)
 		PHI = backward_euler(phi_0, Lx, dx, t_f, dt, tipo_cond, val_cond, k, c, phi_amb, Q);
	end


	return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PHI] = fordward_euler(
	phi_0,
	Lx,
	dx,
	t_f,
	dt,
	tipo_cond,	% array dirichlet(0), neumann(1)
	val_cond,		
	k = @k_default,
	c = @c_default,
	phi_amb= @phi_amb_default,
	Q = @Q_default
 	)
	
	% VARIABLES GENERICAS

	xx = 0 : dx : Lx;
	tt = 0 : dt : t_f;

	% Redefino para usar h en vez de dx
	h = dx;
	h2 = h^2;

	PHI = phi_0';
	phi = phi_0;
	phi_n = phi_0; % Esta usamos para guardar la variable phi sin sobreescribir

	begin = 1; % Begin, para utilizarlo junto con end

	% Verificamos que sea estable
	v = 0;
	dt_critico = h2 / (v * h + k(xx(begin), tt(begin)))

	if (dt >= dt_critico)
		disp (['Problemas de inestabilidad, dt=' num2str(dt) ', dt_critico=' num2str(dt_critico)]);
	end

	% Avanzamos en todos los pasos del tiempo
	for t = tt

		% Bordes caso especial, revisamos la condicion que tengamos, dirichlet 0, neumann 1
		if (tipo_cond(begin) == 0) 

			phi_n(begin) = val_cond(begin);

		elseif (tipo_cond(begin) == 1)
			
			k_0 = k(xx(begin), t);
			c_0 = c(xx(begin), t);
			phi_amb_0 = phi_amb(xx(begin), t);
			Q_0 = Q(xx(begin), t);

			temp = 2*h/k_0 * val_cond(begin) + phi(begin + 1);

			% Reemplazo el nodo ficticio phi_(-1) por temp
			phi_n(begin) = dt*(Q_0 + phi(begin) * (1/dt - c_0) + k_0/h2*(temp - 2*phi(begin) + phi(begin+1) + c_0*phi_amb_0));

		end

		% Extremo final
		if (tipo_cond(end) == 0)

			phi_n(end) = val_cond(end);

		elseif (tipo_cond(end) == 1)
		
			k_f = k(xx(end), t);
			c_f = c(xx(end), t);
			phi_amb_f = phi_amb(xx(end), t);
			Q_f = Q(xx(end), t);

			temp = -2*h/k_f * val_cond(end) + phi(end - 1);

			% Reemplazo el nodo ficticio phi_(L+1) por temp
			phi_n(end) = dt*(Q_f + phi(end) * (1/dt - c_f) + k_f/h2*(phi(end-1) - 2*phi(end) + temp + c_f*phi_amb_f));

		end

		% No cubrimos los extremos
		for i = 2 : length(xx) - 1
			
			k_i = k(xx(i), t);
			c_i = c(xx(i), t);
			phi_amb_i = phi_amb(xx(i), t);
			Q_i = Q(xx(i), t);

			phi_n(i) = dt*(Q_i + phi(i) * (1/dt - c_i) + k_i/h2*(phi(i-1) - 2*phi(i) + phi(i+1) + c_i*phi_amb_i));

		end

		phi = phi_n;

		% Guardamos los phis como filas en la matriz
		PHI = [PHI ; phi'];

	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PHI] = backward_euler(
	phi_0,
	Lx,
	dx,
	t_f,
	dt,
	tipo_cond,	% array dirichlet(0), neumann(1)
	val_cond,		
	k = @k_default,
	c = @c_default,
	phi_amb= @phi_amb_default,
	Q = @Q_default
 	)
	
	% VARIABLES GENERICAS

	xx = 0 : dx : Lx;
	tt = 0 : dt : t_f;

	% Redefino para usar h en vez de dx
	h = dx;
	h2 = h^2;

	% Sea como fuere, voy a trabajar con length(phi_0) - 2 incognitas, dado que conozco los extremos
	PHI = phi_0';
	phi = phi_0;

	begin = 1; % Begin, para utilizarlo junto con end

	% No verificamos estabilidad, no es necesario

	% Para agilizar, guardamos los vectores de k, c, phi_amb y Q
	k_vec = phi;
	c_vec = k_vec;
	phi_amb_vec = k_vec;
	Q_vec = k_vec;

	% Es una variable que ayuda a agilizar
	K_old = zeros(length(phi));
	K_inv = K_old;

	% Avanzamos en todos los pasos del tiempo
	for t = tt

		% Lo definimos aca para reinicializarlo en cada dt
		f = phi_0 * 0;
		K = zeros(length(phi));

		for i = begin : length(f)
			
			% Usamos el n+1, por eso + d_t
			k_vec(i) = k(xx(i), t + dt);
			c_vec(i) = c(xx(i), t + dt);
			phi_amb_vec(i) = phi_amb(xx(i), t + dt);
			Q_vec(i) = Q(xx(i), t + dt);

			% Armamos la matriz base K, y calculamos su inversa, para acelerar
			K(i, i) = h2 / k_vec(i) * (1/dt + c_vec(i)) + 2;

		end

		% Armo f de forma vectorizada
		f = h2 ./ k_vec .* (Q_vec + phi / dt + c_vec .* phi_amb_vec);

		% La parte de arriba y la de abajo de la diagonal
		K += diag(ones(length(phi) - 1, 1) * -1, 1) + diag(ones(length(phi) - 1, 1) * -1, -1);

		% Revisamos los extremos
		if (tipo_cond(begin) == 0)
			K(begin, begin) = 1;
			K(begin, begin + 1) = 0;
			f(begin) = val_cond(begin);

		% Antes las condiciones de neumann, en los extremos aparece un -2 en vez de un -1
		elseif (tipo_cond(begin) == 1)
			K(begin, begin + 1) = -2;
			f(begin) += 2 * h / k_vec(i) * val_cond(begin);
		end

		% Otro extremo
		if (tipo_cond(end) == 0)
			K(end, end) = 1;
			K(end, end - 1) = 0;
			f(end) = val_cond(end);

		elseif (tipo_cond(end) == 1)
			K(end, end - 1) = -2;
			f(end) += - 2 * h / k_vec(i) * val_cond(end);
		end

		% Solo sacamos la inversa si esta vario
		if (sum(sum(K_old != K)) > 0)
			K_old = K;
			K_inv = inv(K);
		end

		phi = K_inv * f;
		
		% Guardamos los phis como filas en la matriz
		PHI = [PHI ; phi'];


	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Funciones por default                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ret] = k_default(x_i, t_i)
	ret = 1;
	return;
end

function [ret] = c_default(x_i, t_i)
	ret = 0;
	return;
end

function [ret] = phi_amb_default(x_i, t_i)
	ret = 0;
	return;
end

function [ret] = Q_default(x_i, t_i)
	ret = 1;
	return;
end