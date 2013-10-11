1;
clear all;
clf;
close;

dx = 1;
dy = 1;

lim_x = [0 8];
lim_y = [0 8];

% P1, P2, N
objeto = [
	%3.0 , 3.0 , 5.0 , 3.0 , 0 , -1 ;
	%5.0 , 3.0 , 5.0 , 5.0 , 1 , 0 ;
	%5.0 , 5.0 , 3.0 , 5.0 , 0 , 1 ;
	%3.0 , 5.0 , 3.0 , 4.0 , -1 , 0 ;
	%3.0 , 4.0 , 3.0 , 3.0 , -1 , 0 ;
	3.4 , 2.5 , 6.2 , 2.5 , 0 , -1 ;
	6.2 , 2.5 , 6.2 , 6.5 , 1 , 0 ;
	6.2 , 6.5 , 3.4 , 6.5 , 0 , 1 ;	
	3.4 , 6.5 , 2.3 , 4.0 , -1 , 1 ;
	2.3 , 4.0 , 3.4 , 2.5 , -1 , -1 ;
];

tic;
O = Objeto(objeto(:, 1:2), objeto(:, 3:4), objeto(:, 5:6));

M = Malla(lim_x, lim_y, dx, dy, O);
toc;
print_malla(M);
hold on; plot(objeto(:,1),objeto(:,2),'xr'); 
         plot(objeto(:,3),objeto(:,4),'xr'); hold off;
