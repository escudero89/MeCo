function D = constt (young,poiss,pstrs)

%% constt Evaluates the constitutive matrix.
%
%  Parameters:
%
%    Input, Young: Young modulus.
%           poiss: Poisson ratio
%          pstrs : flag for Plane Stress
%   
%    Output, D the element constitutive matrix
%

%  Plane Sress
   if (pstrs==1)
       aux1 = young/(1-poiss^2);
       aux2 = poiss*aux1;
       aux3 = young/2/(1+poiss);
%  Plane Strain
   else
       aux1 = young*(1-poiss)/(1+poiss)/(1-2*poiss);
       aux2 = aux1*poiss/(1-poiss);
       aux3 = young/2/(1+poiss);
       thick= 1.0;
   end
   
   D = [aux1,aux2,0;aux2,aux1,0;0,0,aux3];

   
 
