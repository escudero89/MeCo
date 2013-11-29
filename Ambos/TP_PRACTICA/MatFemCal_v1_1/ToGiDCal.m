function ToGiDCal (file_name,u,reaction,Strnod)

%% Stress Evaluates the stresses at the gauss point and smooth the values
%         to the nodes.
%
%  Parameters:
%
%    Input,  u        : Nodal displacements
%            reaction : Reactions on fixed nodes
%            Strnod   : Nodal Stresses
%   
%    Output, none
%
  global coordinates;
  global elements;
 
  nelem  = size(elements,1);           % Number of elements
  nnode  = size(elements,2);           % Number of nodes per element
  npnod  = size(coordinates,1);        % Number of nodes

  if (nnode == 3)
    eletyp = 'Triangle';
  else
    eletyp = 'Quadrilateral';
  end

  msh_file = strcat(file_name,'.flavia.msh');
  res_file = strcat(file_name,'.flavia.res');
  
  fid = fopen(msh_file,'w');
  fprintf(fid,'### \n');
  fprintf(fid,'# MAT_FEM  V.1.0 \n');
  fprintf(fid,'# \n');
  fprintf(fid,['MESH dimension %3.0f   Elemtype %s   Nnode %2.0f \n \n'],2,eletyp,nnode);
  fprintf(fid,['coordinates \n']);
  for i = 1 : npnod
    fprintf(fid,['%6.0f %12.5d %12.5d \n'],i,coordinates(i,:));
  end
  fprintf(fid,['end coordinates \n \n']);
  fprintf(fid,['elements \n']);
  if (nnode == 3)
    for i = 1 : nelem
      fprintf(fid,['%6.0f %6.0f %6.0f %6.0f   1 \n'],i,elements(i,:));
    end
  else
    for i = 1 : nelem
      fprintf(fid,['%6.0f %6.0f %6.0f %6.0f %6.0f  1 \n'],i,elements(i,:));
    end
  end 
  fprintf(fid,['end elements \n \n']);
 
  status = fclose(fid);
  
  u        = full(u);
  reaction = full(reaction);
  
  fid = fopen(res_file,'w');
  fprintf(fid,'Gid Post Results File 1.0 \n');
  fprintf(fid,'### \n');
  fprintf(fid,'# MAT_FEM  V.1.0 \n');
  fprintf(fid,'# \n');
  fprintf(fid,['Result "Temperatures" "Load Analysis"  1  Scalar OnNodes \n']);
  fprintf(fid,['ComponentNames "Temperature" \n']);
  fprintf(fid,['Values \n']);
  for i = 1 : npnod
    fprintf(fid,['%6.0i %13.5d \n'],i,u(i));
  end
  fprintf(fid,['End Values \n']);
  fprintf(fid,'# \n');
  fprintf(fid,['Result "ReactiveFluxes" "Load Analysis"  1  Scalar OnNodes \n']);
  fprintf(fid,['ComponentNames "Fx" \n']);
  fprintf(fid,['Values \n']);
  for i = 1 : npnod
    fprintf(fid,['%6.0f %12.5d \n'],i,reaction(i));
  end
  fprintf(fid,['End Values \n']);
  fprintf(fid,'# \n');
  fprintf(fid,['Result "Fluxes" "Load Analysis"  1  Vector OnNodes \n']);
  fprintf(fid,['ComponentNames "Fx", "Fy", "Fz" \n']);
  fprintf(fid,['Values \n']);
  
  for i = 1 : npnod
    fprintf(fid,['%6.0f %12.5d %12.5d  0.0 \n'],i,Strnod(i,:));
  end

  fprintf(fid,['End Values \n']);
  status = fclose(fid);





