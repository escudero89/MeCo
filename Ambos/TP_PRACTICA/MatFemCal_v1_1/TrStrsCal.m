function S = TrStrsCal (nodes,dmat,displ)

%% TriStrCal Evaluates the stresses for a triangular element.
%
%  Parameters:
%
%    Input, nodes: contains the 2D coordinates nodes coordinates
%                  of the vertices and the Element thicknes.
%           dmat : constitutive matrix
%          displ : nodal displacement
%   
%    Output, S the element constant stress vector
%

  b(1) = nodes(2,2) - nodes(3,2);
  b(2) = nodes(3,2) - nodes(1,2);  
  b(3) = nodes(1,2) - nodes(2,2);

  c(1) = nodes(3,1) - nodes(2,1);
  c(2) = nodes(1,1) - nodes(3,1);
  c(3) = nodes(2,1) - nodes(1,1);

  area2 = abs(b(1)*c(2) - b(2)*c(1));
  area = area2 / 2;

  bmat = [b(1) ,b(2) ,b(3) ;
          c(1), c(2) ,c(3)];

  se = (dmat*bmat*displ)/area2;

  S = se ;

   
 
