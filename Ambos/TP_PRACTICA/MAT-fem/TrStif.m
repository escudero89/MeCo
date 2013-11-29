function [M,F] = TrStif ( nodes,dmat,thick,denss)

%% TrStif Evaluates the stiffness matrix for a triangular element.
%
%  Parameters:
%
%    Input, nodes: contains the 2D coordinates nodes coordinates
%                  of the vertices and the Element thickness.
%           dmat : constitutive matrix
%           denss and thick : density and thickness
%   
%    Output, M the element local stiffness matrix
%            F the element local force vector


  b(1) = nodes(2,2) - nodes(3,2);
  b(2) = nodes(3,2) - nodes(1,2);  
  b(3) = nodes(1,2) - nodes(2,2);

  c(1) = nodes(3,1) - nodes(2,1);
  c(2) = nodes(1,1) - nodes(3,1);
  c(3) = nodes(2,1) - nodes(1,1);

  area2 = abs(b(1)*c(2) - b(2)*c(1));
  area = area2 / 2;

  bmat = [b(1),  0 ,b(2),  0 ,b(3),  0 ;
            0 ,c(1),  0 ,c(2),  0 ,c(3);
          c(1),b(1),c(2),b(2),c(3),b(3)];

  bmat = bmat / area2;

  M = (transpose(bmat)*dmat*bmat)*area*thick;

  force = area*denss*thick/3;

  F = [0,-force,0,-force,0,-force];
