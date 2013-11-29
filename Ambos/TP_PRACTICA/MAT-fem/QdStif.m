function [M,F] = QdStif ( nodes,dmat,thick,denss)

%% QdStif Evaluates the stiffness matrix for a quadrilateral element.
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

    fform = @(s,t)[(1-s-t+s*t)/4,(1+s-t-s*t)/4,(1+s+t+s*t)/4,(1-s+t-s*t)/4];
    deriv = @(s,t)[(-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4 ;
                   (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4 ];

    pospg = [ -0.577350269189626E+00 , 0.577350269189626E+00 ];
    pespg = [  1.0E+00 , 1.0E+00];
    M = zeros(8,8);
    fy = zeros(1,4);
    
    for i=1 : 2
       for j=1 : 2
          lcffm = fform(pospg(i),pospg(j)) ;    % FF at gauss point
          lcder = deriv(pospg(i),pospg(j)) ;    % FF Local derivatives
          xjacm = lcder*nodes ;                 % Jacobian matrix
          ctder = xjacm\lcder ;                 % FF Cartesian derivates
          darea = det(xjacm)*pespg(i)*pespg(j)*thick;
          
          bmat = [];
          for inode = 1 : 4
            bmat = [ bmat , [ctder(1,inode),            0 ;
                                         0 ,ctder(2,inode);
                            ctder(2,inode),ctder(1,inode) ] ] ;
          end
          
          M = M + (transpose(bmat)*dmat*bmat)*darea;
          
          fy = fy + lcffm*denss*darea;
          
       end
    end
   
    F = [ 0, -fy(1), 0, -fy(2), 0, -fy(3), 0, -fy(4)];

