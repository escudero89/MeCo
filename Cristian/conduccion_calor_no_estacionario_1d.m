function [PHI] = conduccion_calor_no_estacionario_1d(
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

	PHI = phi_0;
	phi = phi_0;
	phi_n = phi_0; % Esta usamos para guardar la variable phi sin sobreescribir

	begin = 1; % Begin, para utilizarlo junto con end

	% Para la grafica
	colors = ['rgbcmyrgbcmyrgbcmyrgbcmyrgbcmyrgbcmyrgbcmyrgbcmyrgbcmy'];
	color = 1;

% FORWARD EULER
	
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
		PHI = [PHI ; phi];

	end

end

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
	ret = 0;
	return;
end
