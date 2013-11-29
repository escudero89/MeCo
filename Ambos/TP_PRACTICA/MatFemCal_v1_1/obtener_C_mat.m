% Las entradas vienen en este formato
%
% coord =
% 
%    40.0000   54.2857
%    40.0000   51.4286
%    42.5981   52.8571
% 
% 
% dmat =
% 
%     63     0
%      0    63
% 
% 
% heat =
% 
%      0

function Elem_C_Mat = obtener_C_mat(nodes, rho, cp)

  b(1) = nodes(2,2) - nodes(3,2);
  b(2) = nodes(3,2) - nodes(1,2);  
  b(3) = nodes(1,2) - nodes(2,2);

  c(1) = nodes(3,1) - nodes(2,1);
  c(2) = nodes(1,1) - nodes(3,1);
  c(3) = nodes(2,1) - nodes(1,1);

  area2 = abs(b(1)*c(2) - b(2)*c(1));
  
  cmat = [ 2 1 1 ; 1 2 1 ; 1 1 2];

  Elem_C_Mat = rho * cp * area2 / 24 * cmat;

end