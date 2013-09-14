%
%  IMMERSED BOUNDARY 
%  script 1 para refinar borde sobre malla de fondo
%  
%  contorno --> circulo centrado en (0,0) de radio 1
%

tol = 1e-3;

% generacion de la malla de fondo
x1=(-2:0.1:2)';x2=(-2:0.1:2)';
[xnod,icone] = qq3d(x1,x2);

% calculamos la distancia de cada nodo al origen
radius=sqrt(xnod(:,1).^2+xnod(:,2).^2);

numel = size(icone,1);
mark = zeros(numel,1);

for iele=1:numel,
    nodes = icone(iele,:);
    nodes = [nodes,nodes(1)];
    for inod=1:4
        n1 = nodes(inod);
        n2 = nodes(inod+1);
        r1 = radius(n1);
        r2 = radius(n2);
        if (r1-1)*(r2-1)<=tol,
            mark(iele)=1;
        end
    end
end

if 1
    figure(1)
    theta=(0:1:360)'*pi/180;
    view2d_by_ele(xnod,icone,mark);axis equal
    hold on
    plot(cos(theta),sin(theta),'y.')
end

% refinar lo marcado
ipt = find(mark==1);
for k=1:length(ipt)
    iele = ipt(k);
    nodes = icone(iele,:);
    xele = xnod(nodes,:);
    xele(5,:) = 0.5*(xele(1,:)+xele(2,:));
    xele(6,:) = 0.5*(xele(2,:)+xele(3,:));
    xele(7,:) = 0.5*(xele(3,:)+xele(4,:));
    xele(8,:) = 0.5*(xele(4,:)+xele(1,:));
    xele(9,:) = 0.25*sum(xele(1:4,:));
    numnp = size(xnod,1);
    numel = size(icone,1);
    xnod=[xnod;xele(5:9,:)];
    nodes = [nodes,numnp+(1:5)];
    % elemento original cambiado
    icone(ipt(k),1:4)=nodes([1,5,9,8]);
    % 3 elementos agregados
    icone(numel+1,1:4)=nodes([5,2,6,9]);
    icone(numel+2,1:4)=nodes([8,9,7,4]);
    icone(numel+3,1:4)=nodes([9,6,3,7]);
end

if 1
    theta=(0:1:360)'*pi/180;
    figure(2)
    pltmsh(xnod,icone);axis equal
    hold on
    plot(cos(theta),sin(theta),'y.')
end

