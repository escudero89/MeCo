%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = Titulo del problema
%
%  Material Properties
%
  young =        2100000.00000 ;
  poiss =              0.20000 ;
  denss = 0.00 ;
  pstrs =  1 ;
  thick =              0.50000 ;
%
% Coordinates
%
global coordinates
coordinates = [
         0.00000   ,         1.00000  ;
         0.28571   ,         1.00000  ;
         0.00000   ,         0.66667  ;
         0.39959   ,         0.73231  ;
         0.26805   ,         0.50191  ;
         0.57143   ,         1.00000  ;
         0.00000   ,         0.33333  ;
         0.55805   ,         0.48511  ;
         0.71429   ,         0.74019  ;
         0.42857   ,         0.25981  ;
         0.85714   ,         1.00000  ;
         0.00000   ,         0.00000  ;
         0.85714   ,         0.48038  ;
         0.71429   ,         0.25981  ;
         1.00000   ,         0.74019  ;
         0.28571   ,         0.00000  ;
         1.14286   ,         1.00000  ;
         0.57143   ,         0.00000  ;
         1.00000   ,         0.25981  ;
         1.15623   ,         0.48511  ;
         1.28571   ,         0.74019  ;
         0.85714   ,         0.00000  ;
         1.42857   ,         1.00000  ;
         1.28571   ,         0.25981  ;
         1.14286   ,         0.00000  ;
         1.44623   ,         0.50191  ;
         1.60240   ,         0.73483  ;
         1.71429   ,         1.00000  ;
         1.42857   ,         0.00000  ;
         1.60240   ,         0.26588  ;
         1.73961   ,         0.50020  ;
         1.71429   ,         0.00000  ;
         2.00000   ,         1.00000  ;
         2.00000   ,         0.66667  ;
         2.00000   ,         0.33333  ;
         2.00000   ,         0.00000  ] ; 
%
% Elements
%
global elements
elements = [
      6   ,      2   ,      4   ; 
     12   ,     16   ,      7   ; 
     25   ,     29   ,     24   ; 
     28   ,     23   ,     27   ; 
     32   ,     36   ,     35   ; 
     18   ,     22   ,     14   ; 
     17   ,     11   ,     15   ; 
     29   ,     32   ,     30   ; 
     23   ,     17   ,     21   ; 
      2   ,      1   ,      3   ; 
     16   ,     18   ,     10   ; 
     22   ,     25   ,     19   ; 
     33   ,     28   ,     34   ; 
     11   ,      6   ,      9   ; 
      4   ,      2   ,      3   ; 
     15   ,     11   ,      9   ; 
     15   ,      9   ,     13   ; 
     13   ,      9   ,      8   ; 
     15   ,     13   ,     20   ; 
     19   ,     25   ,     24   ; 
     19   ,     24   ,     20   ; 
     20   ,     24   ,     26   ; 
     19   ,     20   ,     13   ; 
     19   ,     13   ,     14   ; 
     14   ,     13   ,      8   ; 
     14   ,      8   ,     10   ; 
     10   ,      8   ,      5   ; 
     19   ,     14   ,     22   ; 
     14   ,     10   ,     18   ; 
      5   ,      8   ,      4   ; 
      4   ,      8   ,      9   ; 
      4   ,      9   ,      6   ; 
      5   ,      4   ,      3   ; 
     10   ,      5   ,      7   ; 
     26   ,     24   ,     30   ; 
     26   ,     30   ,     31   ; 
     30   ,     24   ,     29   ; 
     20   ,     26   ,     21   ; 
     20   ,     21   ,     15   ; 
     15   ,     21   ,     17   ; 
     21   ,     26   ,     27   ; 
     27   ,     26   ,     31   ; 
     21   ,     27   ,     23   ; 
     27   ,     31   ,     34   ; 
     31   ,     30   ,     35   ; 
     30   ,     32   ,     35   ; 
     28   ,     27   ,     34   ; 
     16   ,     10   ,      7   ; 
     34   ,     31   ,     35   ; 
      5   ,      3   ,      7   ] ; 
%
% Fixed Nodes
%
fixnodes = [
     12  , 1 ,    0.00000  ;
     12  , 2 ,    0.00000  ;
     16  , 1 ,    0.00000  ;
     16  , 2 ,    0.00000  ;
     18  , 1 ,    0.00000  ;
     18  , 2 ,    0.00000  ;
     22  , 1 ,    0.00000  ;
     22  , 2 ,    0.00000  ;
     25  , 1 ,    0.00000  ;
     25  , 2 ,    0.00000  ;
     29  , 1 ,    0.00000  ;
     29  , 2 ,    0.00000  ;
     32  , 1 ,    0.00000  ;
     32  , 2 ,    0.00000  ;
     36  , 1 ,    0.00000  ;
     36  , 2 ,    0.00000  ] ;
%
% Point loads
%
pointload = [
      5  , 1 , -100.00000  ;
      5  , 2 ,    0.00000  ;
     33  , 1 ,   60.00000  ;
     33  , 2 ,    0.00000  ] ;
%
%Uniform Side loads
%
sideload = [
      6  ,      2  ,    0.00000  ,  -40.00000  ;
     28  ,     23  ,    0.00000  ,  -40.00000  ;
     17  ,     11  ,    0.00000  ,  -40.00000  ;
     23  ,     17  ,    0.00000  ,  -40.00000  ;
      2  ,      1  ,    0.00000  ,  -40.00000  ;
     33  ,     28  ,    0.00000  ,  -40.00000  ;
     11  ,      6  ,    0.00000  ,  -40.00000  ];

