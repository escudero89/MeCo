% Recibe
%% x : un vector con todas las coordenadas en x
%% y : un vector con todas las coordenadas en y

function [ret] = malla(x, y)

	[xnode, inode] = qq3d(x', y');

	pltmsh(xnode, inode);

end