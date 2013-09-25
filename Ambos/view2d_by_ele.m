% Le pasas el numero de puntos, aristas, y el estado de cada celda (compuesta por aristas)
% Dibuja una grafica con los resultados
function view2d_by_ele(xnode, inode, state)

    nen = size(inode, 2);

    if (length(state) < length(inode)), 
    	error ([' Distinta cantidad entre inode [' num2str(length(inode)) '] y state [' num2str(length(state)) ']']); 
    end

    for ele = 1 : size(inode, 1)

        nodes = inode(ele,:);

        Xs = xnode(nodes,:);
        Xs = [Xs; Xs(1, :)];

        Us = state(ele, 1) * ones(nen + 1, 1);

        patch(Xs(:,1), Xs(:,2), Us(:,1));

    end

end