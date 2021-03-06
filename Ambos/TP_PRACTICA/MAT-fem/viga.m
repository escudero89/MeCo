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
         0.50000   ,         1.00000  ;
         0.00000   ,         0.50000  ;
         0.70833   ,         0.51116  ;
         1.00000   ,         1.00000  ;
         0.00000   ,         0.00000  ;
         0.50000   ,         0.00000  ;
         1.25000   ,         0.56699  ;
         1.00000   ,         0.00000  ;
         1.50000   ,         1.00000  ;
         1.75000   ,         0.56699  ;
         1.50000   ,         0.00000  ;
         2.00000   ,         1.00000  ;
         2.00000   ,         0.00000  ;
         2.25000   ,         0.56699  ;
         2.50000   ,         1.00000  ;
         2.50000   ,         0.00000  ;
         2.75000   ,         0.56699  ;
         3.00000   ,         1.00000  ;
         3.00000   ,         0.00000  ;
         3.25000   ,         0.56699  ;
         3.50000   ,         1.00000  ;
         3.50000   ,         0.00000  ;
         3.75000   ,         0.43301  ;
         4.00000   ,         1.00000  ;
         4.00000   ,         0.00000  ;
         4.25000   ,         0.43301  ;
         4.50000   ,         1.00000  ;
         4.50000   ,         0.00000  ;
         4.75000   ,         0.43301  ;
         5.00000   ,         1.00000  ;
         5.00000   ,         0.00000  ;
         5.25000   ,         0.43301  ;
         5.50000   ,         1.00000  ;
         5.50000   ,         0.00000  ;
         5.75000   ,         0.43301  ;
         6.00000   ,         1.00000  ;
         6.00000   ,         0.00000  ;
         6.29167   ,         0.48884  ;
         6.50000   ,         1.00000  ;
         6.50000   ,         0.00000  ;
         7.00000   ,         1.00000  ;
         7.00000   ,         0.50000  ;
         7.00000   ,         0.00000  ] ; 
%
% Elements
%
global elements
elements = [
     26   ,     29   ,     27   ; 
     26   ,     27   ,     24   ; 
     24   ,     27   ,     25   ; 
      6   ,      7   ,      3   ; 
     19   ,     16   ,     18   ; 
     19   ,     18   ,     21   ; 
     21   ,     18   ,     20   ; 
     19   ,     21   ,     22   ; 
     22   ,     21   ,     24   ; 
     18   ,     16   ,     15   ; 
     18   ,     15   ,     17   ; 
     15   ,     16   ,     13   ; 
     15   ,     13   ,     11   ; 
     11   ,     13   ,     10   ; 
     11   ,     10   ,      8   ; 
      8   ,     10   ,      5   ; 
      8   ,      5   ,      4   ; 
      4   ,      5   ,      2   ; 
      4   ,      2   ,      3   ; 
     11   ,      8   ,     12   ; 
     42   ,     40   ,     43   ; 
     27   ,     29   ,     30   ; 
     27   ,     30   ,     28   ; 
     30   ,     29   ,     32   ; 
     30   ,     32   ,     33   ; 
     33   ,     32   ,     35   ; 
     33   ,     35   ,     36   ; 
     36   ,     35   ,     38   ; 
     36   ,     38   ,     39   ; 
     39   ,     38   ,     41   ; 
     30   ,     33   ,     31   ; 
     33   ,     36   ,     34   ; 
     36   ,     39   ,     37   ; 
     39   ,     41   ,     43   ; 
     31   ,     28   ,     30   ; 
     14   ,     17   ,     15   ; 
     37   ,     34   ,     36   ; 
      9   ,     12   ,      8   ; 
     25   ,     22   ,     24   ; 
     44   ,     43   ,     41   ; 
      1   ,      3   ,      2   ; 
     20   ,     23   ,     21   ; 
      7   ,      9   ,      4   ; 
     40   ,     37   ,     39   ; 
     26   ,     24   ,     23   ; 
     23   ,     24   ,     21   ; 
     17   ,     20   ,     18   ; 
     28   ,     25   ,     27   ; 
      8   ,      4   ,      9   ; 
     12   ,     14   ,     11   ; 
     34   ,     31   ,     33   ; 
     15   ,     11   ,     14   ; 
      7   ,      4   ,      3   ; 
     40   ,     39   ,     43   ] ; 
%
% Fixed Nodes
%
fixnodes = [
      1  , 1 ,    0.00000  ;
      1  , 2 ,    0.00000  ;
      3  , 1 ,    0.00000  ;
      3  , 2 ,    0.00000  ;
      6  , 1 ,    0.00000  ;
      6  , 2 ,    0.00000  ] ;
%
% Point loads
%
pointload = [
     42  , 1 ,    0.00000  ;
     42  , 2 ,   40.00000  ] ;
%
%Uniform Side loads
%
sideload = [
     19  ,     16  ,    0.00000  ,  -40.00000  ;
     22  ,     19  ,    0.00000  ,  -40.00000  ;
     16  ,     13  ,    0.00000  ,  -40.00000  ;
     13  ,     10  ,    0.00000  ,  -40.00000  ;
     10  ,      5  ,    0.00000  ,  -40.00000  ;
      5  ,      2  ,    0.00000  ,  -40.00000  ;
     42  ,     40  ,    0.00000  ,  -40.00000  ;
     31  ,     28  ,    0.00000  ,  -40.00000  ;
     37  ,     34  ,    0.00000  ,  -40.00000  ;
     25  ,     22  ,    0.00000  ,  -40.00000  ;
      2  ,      1  ,    0.00000  ,  -40.00000  ;
     40  ,     37  ,    0.00000  ,  -40.00000  ;
     28  ,     25  ,    0.00000  ,  -40.00000  ;
     34  ,     31  ,    0.00000  ,  -40.00000  ];

