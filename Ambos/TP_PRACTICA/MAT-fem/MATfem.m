%% MAT-fem
%
% Clear memory and variables.
  clear
  
% The variables are read as a MAT-fem subroutine
% pstrs = 1 indicate Plane Stress; 0 indicate Plane Strain
% young =   Young Modulus
% poiss =   Poission Ratio
% thick =   thickness only valid for Plane Stress
% denss =   density
% coordinates = [ x , y ] coordinate matrix nnode x ndime (2)
% elements    = [ inode, jnode, knode ] element connectivity  matrix
%               nelem x nnode; nnode = 3 for triangular elements and 
%               nnode = 4 for quadrilateral elements
% fixnodes    = [node number, dimension, fixed value] matrix with 
%               Dirichlet restrictions.
% pointload   = [node number, dimension, load value] matrix with 
%               nodal loads.
% SideLoad    = [node number i, node number j, x load, y load] matrix with 
%               line definition and uniform load applied in x and y
%               directions

  file_name = input('Enter the file name :','s');

  tic;                   % Start clock
  ttim = 0;              % Initialize time counter
  eval (file_name);      % Read input file

% Finds basics dimensions
  npnod  = size(coordinates,1);        % Number of nodes
  nndof  = 2*npnod;                    % Number of total DOF
  nelem  = size(elements,1);           % Number of elements
  nnode  = size(elements,2);           % Number of nodes per element
  neleq  = nnode*2;                    % Number of DOF per element

  ttim = timing('Time needed to read the input file',ttim); %Reporting time

% Dimension the global matrices.
  StifMat = sparse ( nndof , nndof );  % Create the global stiffness matrix
  force   = sparse ( nndof , 1 );      % Create the global force vector

%  Material properties (Constant over the domain).
  dmat = constt(young,poiss,pstrs);

  ttim = timing('Time needed to  set initial values',ttim); %Reporting time

%  Element loop.
  for ielem = 1 : nelem

% Recover element properties
    lnods = elements(ielem,:);                        % Elem. connectivity
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:); % Elem. coordinates
 
% Evaluates the elemental stiffness matrix and mass force vector.
    if (nnode == 3)
      [ElemMat,ElemFor] = TrStif(coord,dmat ,thick,denss); % 3 Nds Triangle
    else 
      [ElemMat,ElemFor] = QdStif(coord,dmat ,thick,denss); % 4 Nds Quad.
    end
    
% Finds the equation number list for the i-th element
    eqnum = [];                                  % Clear the list
    for i =1 : nnode                             % Node cicle
      eqnum = [eqnum,lnods(i)*2-1,lnods(i)*2];   % Build the equation 
    end                                          % number list

% Assemble the force vector and the stiffness matrix
    for i = 1 : neleq
      force(eqnum(i)) = force(eqnum(i)) + ElemFor(i);
      for j = 1 : neleq
         StifMat(eqnum(i),eqnum(j)) = StifMat(eqnum(i),eqnum(j)) + ...
                                      ElemMat(i,j);
      end
    end

  end  % End element loop

  ttim = timing('Time to assamble the global system',ttim); %Reporting time

%  Add side forces to the force vector
  for i = 1 : size(sideload,1)
      x=coordinates(sideload(i,1),:)-coordinates(sideload(i,2),:);
      l = sqrt(x*transpose(x));       % Finds the length of the side
      ieqn = sideload(i,1)*2;         % Finds eq. number for the first node
     force(ieqn-1) = force(ieqn-1) + l*sideload(i,3)/2;   % add x force 
     force(ieqn  ) = force(ieqn  ) + l*sideload(i,4)/2;   % add y force

     ieqn = sideload(i,2)*2;         % Finds eq. number for the second node
     force(ieqn-1) = force(ieqn-1) + l*sideload(i,3)/2;   % add x force 
     force(ieqn  ) = force(ieqn  ) + l*sideload(i,4)/2;   % add y force
  end

%  Add point loads conditions to the force vector
  for i = 1 : size(pointload,1)
    ieqn = (pointload(i,1)-1)*2 + pointload(i,2);       % Finds eq. number
    force(ieqn) = force(ieqn) + pointload(i,3);         % add the force
  end

  ttim = timing('Time for apply side and point load',ttim); %Reporting time

 %  Applies the Dirichlet conditions and adjust the right hand side.
  u = sparse ( nndof, 1 );
  for i = 1 : size(fixnodes,1)
    ieqn = (fixnodes(i,1)-1)*2 + fixnodes(i,2);  %Finds the equation number
    u(ieqn) = fixnodes(i,3);                   %and store the solution in u
    fix(i) = ieqn;                         % and mark the eq as a fix value
  end
  force = force - StifMat * u;       % adjust the rhs with the known values

%  Compute the solution by solving StifMat * u = force for the 
%  remaining unknown values of u.
  FreeNodes = setdiff ( 1:nndof, fix ); % Finds the free node list and
                                        % solve for it.
  u(FreeNodes) = StifMat(FreeNodes,FreeNodes) \ force(FreeNodes);

%  Compute the reactions on the fixed nodes as a R = StifMat * u - F
  reaction = sparse(nndof,1);
  reaction(fix) = StifMat(fix,1:nndof) * u(1:nndof) - force(fix);
  
  ttim = timing('Time  to solve the stifness matrix',ttim); %Reporting time

% Compute the stresses
  Strnod = Stress(dmat,poiss,thick,pstrs,u);

  ttim = timing('Time to  solve the  nodal stresses',ttim); %Reporting time
  
% Graphic representation.
  ToGiD (file_name,u,reaction,Strnod);

  ttim = timing('Time  used to write  the  solution',ttim); %Reporting time
  itim = toc;                                               %Close last tic
  fprintf(1,'\n Total running time %12.6f \n',ttim);  %Reporting final time
