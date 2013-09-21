% Recibe
%% lim_x : [inicio_x fin_x]
%% dx : paso en x
%% lim_y : [inicio_y fin_y]
%% dy : paso en y
%% object : los puntos que conforman el objeto: [x ; y ; z]
%% normals : las normales a cada punto del objeto: [nx ; ny ; nz]

%% TODO 2D por ahora
function [ret] = malla(lim_x, dx, lim_y, dy, object, normals)

	% Establezco algunas variables para utilizar
	begin = 1;

	xx = lim_x(begin) : dx : lim_x(end);
	yy = lim_y(begin) : dy : lim_y(end);

	x0 = xx(begin);
	y0 = yy(begin);

	% Cantidad de celdas a lo largo de los ejes
	Lx = length(xx) - 1; 
	Ly = length(yy) - 1;

	% Creo mi malla
	[xnode, inode] = qq3d(xx', yy');

	% Creo un vector para guardar el estado de cada celda
	tracked = zeros(Lx * Ly, 1);

	% Para guardar en que celda esta cada punto
	object_idx = zeros(size(object)(1), 1);

	% Voy recorriendo cada punto del objeto
	for p = 1 : size(object)(1)

		celda_x = ceil((object(p, 1) - x0) / dx);
		celda_y = ceil((object(p, 2) - y0) / dy);

		% Etiqueto el punto y marco el estado en la celda
		object_idx(p) = celda_x + (celda_y - 1) * Lx;

		tracked(object_idx(p)) = 1;

	end

	original_tracked = tracked;
	original_object_idx = object_idx;

	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 1);
	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 2);
	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 3);
	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 4);
	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 5);
	[xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, 6);

	for t = 1 : length(original_tracked)
		
		if (original_tracked(t) > 0)
			continue;
		elseif (t < length(original_tracked) && original_tracked(t + 1) != 0)
			elegidos = original_object_idx == t + 1;

			% Saco un promedio de todos los puntos de la celda
			avg_celda = [sum(xnode(inode(t, :)', 1) / 4) sum(xnode(inode(t, :)', 2) / 4)];

			avg_next = [sum(object(elegidos, 1)) sum(object(elegidos, 2))] / length(nonzeros(elegidos));
			nrm_next = [sum(normals(elegidos, 1)) sum(normals(elegidos, 2))];
			
			% Hago el producto
			if (dot((avg_next - avg_celda), nrm_next) < 0)
				tracked(t) = -1;
				tracked(find(original_tracked == -2)) = -1;

				% Reseteamos original tracked a como estaba
				original_tracked(find(original_tracked == -2)) = 0;
			end

		else
			% Le pongo un marcador tipo buffer
			original_tracked(t) = -2;
		end

	end

	% Una vez llegado al final, terminamos de arreglarlo que tenga -2
	tracked(find(original_tracked == -2)) = -1;
	
	view2d_by_ele(xnode, inode, tracked);

end

%% Recibe una celda con puntos, y retorna la misma subdividida

function [ xnode, inode_celda, inode_end, state, object_idx ] ...
	= subdividir(xnode, inode, inode_celda, celda, ptos, object_idx, depth = 1)

	% Seleccionamos los nodos para esa celda y la cantidad total
	xnode_celda = xnode(inode(celda, :), :);
	xnode_total = size(xnode)(1);	

	% Creamos las nuevas celdas (en sentido antihorario desde el origen)
	c1_node = [
		.5 * (xnode_celda(2, 1) + xnode_celda(1, 1)) , xnode_celda(1, 2) ;
		.5 * (xnode_celda(3, 1) + xnode_celda(1, 1)) , .5 * (xnode_celda(3, 2) + xnode_celda(1, 2));
		xnode_celda(1,1) , .5 * (xnode_celda(4, 2) + xnode_celda(1, 2)) ;
	];
	
	c2_node = [
		xnode_celda(2, 1) , .5 * (xnode_celda(2, 2) + xnode_celda(3, 2)) ;
	];

	c3_node = [
		c1_node(2, 1) , xnode_celda(4, 2)
	];

	xnode = [ xnode ; c1_node ; c2_node ; c3_node ];

	% inode = [1 2 4 3] por ejemplo
	% Tiene cuatro aristas, reemplazamos las cuatro por las nuevas aristas

	inode_end = [ 
		xnode_total+1 , inode_celda(2) , xnode_total+4 , xnode_total+2 ;
		xnode_total+3 , xnode_total+2 , xnode_total+5 , inode_celda(4) ;
		xnode_total+2 , xnode_total+4 , inode_celda(3) , xnode_total+5 ; 
		];

	inode_celda = [ inode_celda(1) , xnode_total+1 , xnode_total+2 , xnode_total+3 ];
	
	[state1, object_idx] = hay_puntos(xnode(inode_celda(:), :)  , celda, celda , ptos , object_idx , depth);
	[state2, object_idx] = hay_puntos(xnode(inode_end(1, :), :) , celda, length(inode)+1 , ptos , object_idx , depth);
	[state3, object_idx] = hay_puntos(xnode(inode_end(2, :), :) , celda, length(inode)+2 , ptos , object_idx , depth);
	[state4, object_idx] = hay_puntos(xnode(inode_end(3, :), :) , celda, length(inode)+3 , ptos , object_idx , depth);
	
	state = [state1 ; state2 ; state3 ; state4];

end

% Le paso una celda y puntos, y me retorna el estado (si hay puntos en esa celda)
function [state, object_idx] = hay_puntos(xnode_celda, celda_padre, celda, object, object_idx, depth)

	state = depth;

	% Va a retornar todos los puntos en la celda buscada
	ptos = object(find(object_idx == celda_padre), :);

	for p = ptos'

		if ( p(1) >= xnode_celda(1, 1) && p(1) <= xnode_celda(2, 1) 
			&&
		     p(2) >= xnode_celda(1, 2) && p(2) <= xnode_celda(4, 2) ),

		    state = depth + 1;

		    for k = 1 : length(object)
		   		if (object(k, 1) == p(1) && object(k, 2) == p(2))
		   			object_idx(k) = celda;
		   		end
		    end

		end

	end

end

% Para hacer recursiva la division
function [xnode, inode, tracked, object_idx] = r_dividir(xnode, inode, tracked, object, object_idx, depth)

	for c = 1 : length(tracked)

		if (tracked(c) == depth)		

			[ xnode, inode_celda, inode_end, state, object_idx ] ...
				= subdividir(xnode, inode, inode(c, :), c, object, object_idx, depth);

			inode(c, :) = inode_celda;

			inode = [ inode ; inode_end ];

			% Reviso los que antes estaban marcados
			tracked(c) = state(1);

			tracked = [ tracked ; state(2:end) ];

		end

	end

	return;

end

