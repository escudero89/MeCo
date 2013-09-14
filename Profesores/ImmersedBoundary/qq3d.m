function [xnod,icone]=qq3d(x1,x2,x3)
%
%   Obtiene una malla como producto cartesiano entre tres
%   vectores de nodos "x1" , "x2" y "x3".
%   x1(N1,1:ndm) x2(N2,1:ndm) y x3(N3,1:ndm)
%   Si x3 no existe hace una malla 2d, en este caso x1 y x2 tienen
%   2 coordenadas
%
%   Si x1, x2 y eventualmente x3 tienen solo una columna entiende que
%   la malla esta alineada con los ejes cartesianos
%
%           [xnod,icone] = qq3d(x1,x2,x3)
%

ndm = 2;
N3  = 1;
if nargin>2, ndm=3; end

[N1,m1] = size(x1);
if (m1~=ndm)&(m1~=1), error(' Ver dimension del vector x1  ');end
[N2,m2] = size(x2);
if (m2~=ndm)&(m2~=1), error(' Ver dimension del vector x2  ');end

if m1==1,
    x1 = [x1,zeros(N1,ndm-1)];
end

if m2==1,
    x2 = [zeros(N2,1),x2,zeros(N2,ndm-2)];
end

if ndm==3,
    [N3,m3] = size(x3);
    if (m3~=ndm)&(m3~=1), error(' Ver dimension del vector x3  ');end
    if m3==1,
        x3 = [zeros(N3,ndm-1),x3];
    end    
end


xnod = [];
x2d  = [];

if m1==1 & m2==1,
    for k=1:N2,
        x2d = [x2d ; [x1(:,1),x1(:,2)]+ ones(N1,1)*[x2(k,1),x2(k,2)] ];
    end
else
    for k=1:N2,
        x2d = [x2d ; [x1(:,1)-x1(1,1),x1(:,2)-x1(1,2)]+ ones(N1,1)*[x2(k,1),x2(k,2)] ];
    end
end

n2d=length(x2d(:,1));

if  ndm==3,
    for k=1:N3,
        xnod = [xnod ;
            x2d(:,1)+ones(n2d,1)*x3(k,1), ...
            x2d(:,2)+ones(n2d,1)*x3(k,2), ...
            ones(n2d,1)*x3(k,3) ];
    end
else
    xnod = x2d;
end

icone = [];
ico2d = [];
ico = [(1:N1-1)' (2:N1)' (2:N1)'+N1 (1:N1-1)'+N1];
for k=1:N2-1,
    ip = (k-1)*N1;
    ico2d=[ico2d; ico+ip];
end

if  ndm==3,
    for k=1:N3-1,
        ip = (k-1)*n2d;
        icone = [icone ;[ ip+ico2d ip+n2d+ico2d ]];
    end
else
    icone = ico2d;
end