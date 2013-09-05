function [ y ] = Q(x)
	
	for i= 1:length(x)
		y(i) = 1 - 4*(x(i) - 1/2)^2;
	endfor
	
endfunction