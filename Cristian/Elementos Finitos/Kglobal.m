function [KK] = Kglobal(K, inode, onlynode = [])

	KK = zeros(max(max(inode))*2); 

	for j = 1 : size(inode, 1)
		for k = 1 : 4

			for z = 1 : 4
				
				KK_range = inode(j, k) * 2 - 1 : inode(j, k) * 2;
				ZZ_range = inode(j, z) * 2 - 1 : inode(j, z) * 2;

				K_range = k * 2 - 1 : k * 2;
				Z_range = z * 2 - 1 : z * 2;

				KK(KK_range, ZZ_range) += K(Z_range, K_range); 
			
			end
		end
	end

	% Si le pasamos un vector de nodos a utilizar solamente
	% como onlynode = [3 4 6]
	% o un onlynode = [3 4 6 ; 1 2 5] [ filas ; columnas ]
	if (!isempty(onlynode))
		idx = 1 : size(onlynode, 2); 

		if (size(onlynode, 1) == 1)

			v(idx * 2 - 1) = onlynode * 2 - 1; 
			v(idx * 2) = onlynode * 2;

			KK = KK(v, v);

		else

			v(:, idx * 2 - 1) = onlynode * 2 - 1; 
			v(:, idx * 2) = onlynode * 2;
			
			KK = KK(v(1, :), v(2, :));

		end
	end

endfunction
