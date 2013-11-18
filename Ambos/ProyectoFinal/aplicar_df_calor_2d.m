%%%%%
%% M es una malla de puntos
%% k = [ kx ky ];

function [ret] = aplicar_df_calor_2d(xnod, inode, state_matrix, k, Q = @Q_default, dirichlet = 1)

	[M, dx, dy] = obtener_malla(xnod, inode, state_matrix);
	dx
	dy

	Ceros = zeros(size(M));

	% Si le pasamos un solo k, toma k = [kx ky] con kx = ky = k
	if (length(k) == 1)
		k = [k k];
	end
	
	%% arriba , centro, derecho
	molecula_comp = [ k(2)/dy^2 , -2*(k(1)/dx^2 + k(2)/dy^2) , k(1)/dx^2 ] 

	% Matriz de diferencia finitas
	KK = zeros(prod(size(M)));
	ff = KK(:, 1);

	KK_pos = 1;

	for j = 1 : size(M, 2)
		for i = 1 : size(M, 1)

			Z = Ceros;

			% Estamos en el interior
			if (M(i, j) == 1)

				Z(i, j) = molecula_comp(2);

				Z(i - 1, j) = molecula_comp(1);
				Z(i + 1, j) = molecula_comp(1);
				
				Z(i, j - 1) = molecula_comp(3);
				Z(i, j + 1) = molecula_comp(3);

				ff(KK_pos) = Q(1,1);

			% Borde o afuera
			else

				Z(i, j) = 1;

				ff(KK_pos) = dirichlet;

			% Afuera
			end
		
			% Reshapear mi Z para que quede como fila
			KK(KK_pos, :) = reshape(Z, 1, prod(size(M)));

			KK_pos += 1;

		end
	end

	ret = KK\ff;
%csvwrite('filename.cvs',[KK ff]);
	paso_y = 1/(size(state_matrix, 1) * 2);
	paso_x = 1/(size(state_matrix, 2) * 2);

	[xx , yy] = meshgrid(0 : paso_x : 1 - paso_x, 0 : paso_y : 1 - paso_y);

	mesh(xx, yy, reshape(ret, size(state_matrix, 1)*2, size(state_matrix, 2)*2));
%	r = symrcm(KK);
% hacer lo mismo en el vector solucion derp y en el f
%	ret = KK(r, r) \ ff;

endfunction


function [M, dx, dy] = obtener_malla(xnod, inode, state_matrix)

	puntos_ele1 = xnod(inode(1, :), :);

	dx = puntos_ele1(3, 1) - puntos_ele1(1, 1);
	dy = puntos_ele1(3, 2) - puntos_ele1(1, 2);

	dx = dx / 2;
	dy = dy / 2;
	
	M = zeros(size(state_matrix)*2);

	for i = 1 : size(state_matrix, 1)
		for j = 1 : size(state_matrix, 2)

			l = 2 * i-1;
			m = 2 * j-1;

			M(l, m) = state_matrix(i, j);
			M(l + 1, m) = state_matrix(i, j);
			M(l, m + 1) = state_matrix(i, j);
			M(l + 1, m + 1) = state_matrix(i, j);
			
		end
	end

endfunction

function [ret] = Q_default(x, y)

	ret = -1;

endfunction