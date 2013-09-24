function pltmsh(xnod,icone,ijob,type_line)

%
% pltmsh(xnod,icone,ijob,type_line)
%
% dibuja la malla, si ijob existe y no es 0 hace la
% malla de superficie
%
    
    if nargin < 4, type_line = 'w'; end
    
    if nargin < 3, ijob = 0; else ijob = 1; end
    
    [numel, nel] = size(icone);
    [numnp, ndm] = size(xnod);
    
    X = []; 
    Y = [];
    Z = [];
    
    if ndm == 2,

        for k=1:nel,

            X = [ X ; xnod(icone(:,k),1)' ];
            Y = [ Y ; xnod(icone(:,k),2)' ];

        end
        
        patch(X,Y,type_line)

    elseif ndm == 3,
    
        if ijob == 0,

            if nel == 8,
                inoca=[1 4 3 2 6 5 1 4 8 5 6 7 8 4 3 7 6 2 3 2 1];

            elseif nel == 4,
                inoca=[1 2 3 1 2 4 1 3 4 2 3 1];

            else
                error(' Bad type of element ')
            end

        else
            
            if nel == 3,
                inoca=[1 2 3 1];

            elseif nel == 4,
                inoca=[1 2 3 4,1];
                
            else
                error(' Bad type of element ')
            end

        end

        for k=1:length(inoca),
            nodos = icone(:,inoca(k));
            X = [ X ; xnod(nodos,1)' ];
            Y = [ Y ; xnod(nodos,2)' ];
            Z = [ Z ; xnod(nodos,3)' ];
        end

        fill3(X,Y,Z,type_line)
        
    else

        error(' Bad data in pltmsh [NDM] ');

    end
    
end