
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

//% MAT-fem
// 
// Clear memory and variables.
clear

// The variables are readed as a MAT-fem subroutine
// pstrs = 1 indicate Plane Stress; 0 indicate Plane Strain
// young =   Young Modulus
// poiss =   Poission Ratio
// thick =   thickness only valid for Plane Stress
// denss =   density
// coordinates = [ x , y ] coordinate matrix nnode x ndime (2)
// elements    = [ inode, jnode, knode ] element conectivities matrix
//               nelem x nnode; nnode = 3 for triangular elements and 
//               nnode = 4 for cuadrilateral elements
// fixnodes    = [node number, dimension, fixed value] matrix with 
//               dirichlet restrictions.
// pointload   = [node number, dimension, load value] matrix with 
//               nodal loads.
// SideLoad    = [node number i, node number j, x load, y load] matrix with 
//               line definition and uniform load applied in x and y
//               directions

file_name = input("Enter the file name :","s");

tic;
// Start clock
ttim = 0;
// Initialize time counter
mtlb_eval(file_name);
// Read input file

// Finds basics dimentions
// ! L.31: mtlb(coordinates) can be replaced by coordinates() or coordinates whether coordinates is an M-file or not
npnod = size(mtlb_double(mtlb(coordinates)),1);
// Number of nodes
nndof = 2*npnod;
// Number of total DOF
// ! L.33: mtlb(elements) can be replaced by elements() or elements whether elements is an M-file or not
nelem = size(mtlb_double(mtlb(elements)),1);
// Number of elements
// ! L.34: mtlb(elements) can be replaced by elements() or elements whether elements is an M-file or not
nnode = size(mtlb_double(mtlb(elements)),2);
// Number of nodes per element
neleq = nnode*2;
// Number of DOF per element

// !! L.37: Unknown function timing not converted, original calling sequence used
ttim = timing("Time needed to read the input file",ttim);
//Reporting time

// Dimension the global matrices.
StifMat = sparse([],[],[nndof,nndof]);
// Create the global stiffness matrix
force = sparse([],[],[nndof,1]);
// Create the global force vector

//  Material properties (Constant over the domain).
// ! L.44: mtlb(young) can be replaced by young() or young whether young is an M-file or not
// ! L.44: mtlb(poiss) can be replaced by poiss() or poiss whether poiss is an M-file or not
// ! L.44: mtlb(pstrs) can be replaced by pstrs() or pstrs whether pstrs is an M-file or not
// !! L.44: Unknown function constt not converted, original calling sequence used
dmat = constt(mtlb(young),mtlb(poiss),mtlb(pstrs));

// !! L.46: Unknown function timing not converted, original calling sequence used
ttim = timing("Time needed to  set initial values",ttim);
//Reporting time

//  Element cycle.
for ielem = 1:nelem

  // Recover element properties
  // ! L.52: mtlb(elements) can be replaced by elements() or elements whether elements is an M-file or not
  // !! L.52: Unknown function elements not converted, original calling sequence used
  lnods = elements(ielem,":");
  // Elem. conectivities
  // ! L.53: mtlb(coordinates) can be replaced by coordinates() or coordinates whether coordinates is an M-file or not
  // !! L.53: Unknown function coordinates not converted, original calling sequence used
  coord(1:nnode,1:length(coordinates(mtlb_e(lnods,1:nnode),":"))) = coordinates(mtlb_e(lnods,1:nnode),":");
  // Elem. coordinates

  // Evaluates the elemental stiffnes matrix and mass force vector.
  if nnode==3 then
    // ! L.57: mtlb(thick) can be replaced by thick() or thick whether thick is an M-file or not
    // ! L.57: mtlb(denss) can be replaced by denss() or denss whether denss is an M-file or not
    // !! L.57: Unknown function TrStif not converted, original calling sequence used
    [ElemMat,ElemFor] = TrStif(coord,dmat,mtlb(thick),mtlb(denss));  // 3 Nds Triangle
  else
    // ! L.59: mtlb(thick) can be replaced by thick() or thick whether thick is an M-file or not
    // ! L.59: mtlb(denss) can be replaced by denss() or denss whether denss is an M-file or not
    // !! L.59: Unknown function QdStif not converted, original calling sequence used
    [ElemMat,ElemFor] = QdStif(coord,dmat,mtlb(thick),mtlb(denss));  // 4 Nds Quad.
  end;

  // Finds the equation number list for the i-th element
  eqnum = [];
  // Clear the list
  for i = 1:nnode // Node cicle
   eqnum = [eqnum,mtlb_s(mtlb_double(mtlb_e(lnods,i))*2,1),mtlb_double(mtlb_e(lnods,i))*2]; // Build the equation 
  end;
  // number list

  // Assamble the force vector and the stiffnes matrix
  for i = 1:neleq
    force = mtlb_i(force,eqnum(i),mtlb_a(force(eqnum(i)),mtlb_double(mtlb_e(ElemFor,i))));
    for j = 1:neleq
    
      StifMat(eqnum(i),eqnum(j)) = StifMat(eqnum(i),eqnum(j))+mtlb_double(ElemMat(i,j));
    end;
  end;

end;
// End element cicle

// !! L.79: Unknown function timing not converted, original calling sequence used
ttim = timing("Time to assamble the global system",ttim);
//Reporting time

//  Add side forces to the force vector
// ! L.82: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not

for i = 1:size(mtlb_double(mtlb(sideload)),1)
  // ! L.83: mtlb(coordinates) can be replaced by coordinates() or coordinates whether coordinates is an M-file or not
  // ! L.83: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.83: Unknown function sideload not converted, original calling sequence used
  // !! L.83: Unknown function coordinates not converted, original calling sequence used
  // ! L.83: mtlb(coordinates) can be replaced by coordinates() or coordinates whether coordinates is an M-file or not
  // ! L.83: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.83: Unknown function sideload not converted, original calling sequence used
  // !! L.83: Unknown function coordinates not converted, original calling sequence used
  x = mtlb_s(mtlb_double(coordinates(sideload(i,1),":")),mtlb_double(coordinates(sideload(i,2),":")));
  // !! L.84: Matlab function transpose not yet converted, original calling sequence used
  l = sqrt(x*mtlb_double(transpose(x)));
  // Finds the lenght of the side
  // ! L.85: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.85: Unknown function sideload not converted, original calling sequence used
  ieqn = mtlb_double(sideload(i,1))*2;
  // Finds eq. number for the first node
  // ! L.86: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.86: Unknown function sideload not converted, original calling sequence used
  force = mtlb_i(force,mtlb_s(ieqn,1),mtlb_a(force(mtlb_s(ieqn,1)),(l*mtlb_double(sideload(i,3)))/2));
  // add x force 
  // ! L.87: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.87: Unknown function sideload not converted, original calling sequence used
  force = mtlb_i(force,ieqn,mtlb_a(force(ieqn),(l*mtlb_double(sideload(i,4)))/2));
  // add y force

  // ! L.89: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.89: Unknown function sideload not converted, original calling sequence used
  ieqn = mtlb_double(sideload(i,2))*2;
  // Finds eq. number for the second node
  // ! L.90: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.90: Unknown function sideload not converted, original calling sequence used
  force = mtlb_i(force,mtlb_s(ieqn,1),mtlb_a(force(mtlb_s(ieqn,1)),(l*mtlb_double(sideload(i,3)))/2));
  // add x force 
  // ! L.91: mtlb(sideload) can be replaced by sideload() or sideload whether sideload is an M-file or not
  // !! L.91: Unknown function sideload not converted, original calling sequence used
  force = mtlb_i(force,ieqn,mtlb_a(force(ieqn),(l*mtlb_double(sideload(i,4)))/2));
  // add y force
end;

//  Add point loads conditions to the force vector
// ! L.95: mtlb(pointload) can be replaced by pointload() or pointload whether pointload is an M-file or not

for i = 1:size(mtlb_double(mtlb(pointload)),1)
  // ! L.96: mtlb(pointload) can be replaced by pointload() or pointload whether pointload is an M-file or not
  // !! L.96: Unknown function pointload not converted, original calling sequence used
  // ! L.96: mtlb(pointload) can be replaced by pointload() or pointload whether pointload is an M-file or not
  // !! L.96: Unknown function pointload not converted, original calling sequence used
  ieqn = mtlb_a(mtlb_s(mtlb_double(pointload(i,1)),1)*2,mtlb_double(pointload(i,2)));
  // Finds eq. number
  // ! L.97: mtlb(pointload) can be replaced by pointload() or pointload whether pointload is an M-file or not
  // !! L.97: Unknown function pointload not converted, original calling sequence used
  force = mtlb_i(force,ieqn,mtlb_a(force(ieqn),mtlb_double(pointload(i,3))));
  // add the force
end;

// !! L.100: Unknown function timing not converted, original calling sequence used
ttim = timing("Time for apply side and point load",ttim);
//Reporting time

//  Applies the Dirichlet conditions and adjust the right hand side.
u = sparse([],[],[nndof,1]);
// ! L.104: mtlb(fixnodes) can be replaced by fixnodes() or fixnodes whether fixnodes is an M-file or not

for i = 1:size(mtlb_double(mtlb(fixnodes)),1)
  // ! L.105: mtlb(fixnodes) can be replaced by fixnodes() or fixnodes whether fixnodes is an M-file or not
  // !! L.105: Unknown function fixnodes not converted, original calling sequence used
  // ! L.105: mtlb(fixnodes) can be replaced by fixnodes() or fixnodes whether fixnodes is an M-file or not
  // !! L.105: Unknown function fixnodes not converted, original calling sequence used
  ieqn = mtlb_a(mtlb_s(mtlb_double(fixnodes(i,1)),1)*2,mtlb_double(fixnodes(i,2)));
  //Finds the equation number
  // ! L.106: mtlb(fixnodes) can be replaced by fixnodes() or fixnodes whether fixnodes is an M-file or not
  // !! L.106: Unknown function fixnodes not converted, original calling sequence used
  u = mtlb_i(u,ieqn,fixnodes(i,3));
  //and store the solution in u
  fix(1,i) = matrix(ieqn,1,-1);
  // and mark the eq as a fix value
end;
force = force-StifMat*u;
// adjust the rhs with the known values

//  Compute the solution by solving StifMat * u = force for the 
//  remaining unknown values of u.
// !! L.113: Matlab function setdiff not yet converted, original calling sequence used
FreeNodes = setdiff(1:nndof,fix);
// Finds the free node list and
// solve for it.
u = mtlb_i(u,FreeNodes,StifMat(FreeNodes,FreeNodes)\force(FreeNodes));

//  Compute the reactions on the fixed nodes as a R = StifMat * u - F
reaction = sparse([],[],[nndof,1]);
reaction = mtlb_i(reaction,fix,StifMat(fix,1:nndof)*u(1:nndof)-force(fix));

// !! L.121: Unknown function timing not converted, original calling sequence used
ttim = timing("Time  to solve the stifness matrix",ttim);
//Reporting time

// Compute the stresses
// ! L.124: mtlb(poiss) can be replaced by poiss() or poiss whether poiss is an M-file or not
// ! L.124: mtlb(thick) can be replaced by thick() or thick whether thick is an M-file or not
// ! L.124: mtlb(pstrs) can be replaced by pstrs() or pstrs whether pstrs is an M-file or not
// !! L.124: Unknown function Stress not converted, original calling sequence used
Strnod = Stress(dmat,mtlb(poiss),mtlb(thick),mtlb(pstrs),u);

// !! L.126: Unknown function timing not converted, original calling sequence used
ttim = timing("Time to  solve the  nodal stresses",ttim);
//Reporting time

// Graphic representation.
// !! L.129: Unknown function ToGiD not converted, original calling sequence used
ToGiD(file_name,u,reaction,Strnod);

// !! L.131: Unknown function timing not converted, original calling sequence used
ttim = timing("Time  used to write  the  solution",ttim);
//Reporting time
itim = toc();
//Close last tic
// L.133: No simple equivalent, so mtlb_fprintf() is called
mtlb_fprintf(1,"\n Total running time %12.6f \n",ttim);
//Reporting final time
