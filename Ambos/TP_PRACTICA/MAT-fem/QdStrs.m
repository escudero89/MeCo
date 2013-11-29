function S = QdStif (nodes,dmat,displ,poiss,thick,pstrs)

%% QdStif Evaluates the stresses for a quadrilateral element.
%
%  Parameters:
%
%    Input, nodes: contains the 2D coordinates nodes coordinates
%                  of the vertices and the Element thickness.
%           dmat : constitutive matrix
%          displ : nodal displacement
%          poiss : Poisson ratio
%          thick : density 
%          pstrs : flag for Plane Stress
%   
%    Output, S the element constant stress vector
%

    fform = @(s,t)[(1-s-t+s*t)/4,(1+s-t-s*t)/4,(1+s+t+s*t)/4,(1-s+t-s*t)/4];
    deriv = @(s,t)[(-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4 ;
                   (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4 ];

    pospg = [ -0.577350269189626E+00 , 0.577350269189626E+00 ];
    pespg = [  1.0E+00 , 1.0E+00];

    strsg = [];
    extrap = [];
    order = [ 1 , 4 ; 2 , 3 ]; % Align the g-pts. with the element corners
    
    for i=1 : 2
       for j=1 : 2
          lcder = deriv(pospg(i),pospg(j)) ;    % FF Local derivatives
          xjacm = lcder*nodes ;                 % Jacobian matrix
          ctder = xjacm\lcder ;                 % FF Cartesian derivates
          
          bmat = [];
          for inode = 1 : 4
            bmat = [ bmat , [ctder(1,inode),            0 ;
                                         0 ,ctder(2,inode);
                            ctder(2,inode),ctder(1,inode) ] ] ;
          end
          
          strsg(:,order(i,j)) = (dmat*bmat*displ) ;
          
          a = 1/pospg(i);
          b = 1/pospg(j);
 
         extrap(order(i,j),:) = fform(a,b) ;
       end
    end
   
    se = transpose(extrap*transpose(strsg));

%  Plane Stress
  if (pstrs==1)
       S = se ;
%  Plane Strain
   else                
       S = [se(1,:) ; se(2,:) ; -poiss*(se(1,:)+se(2,:)) ; se(3,:)];
   end
