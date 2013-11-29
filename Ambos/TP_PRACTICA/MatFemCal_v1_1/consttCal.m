function D = constt (kx,ky)

%% constt Evaluates the constitutive matrix.
%
%  Parameters:
%
%    Input, kx: X conductivity.
%           ky: Y conductivity.

%   
%    Output, D the element constitutive matrix
%

   
   D = [kx,0;0,ky];

   
 
