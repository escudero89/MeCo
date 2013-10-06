% Recibe un vector (xyz) o (x, y, z)
% Los valores que no seteas quedan como antes
function s = set (p, varargin)
    
    s = p;
    default = get(p);

    if (length(varargin) < 1 || length(varargin) > 3)
        error('puntos::set () : incorrecto numero de argumentos.');
    elseif (length(varargin) == 1)
        nuevas_coordenadas = varargin{1};
    elseif (length(varargin) == 2)
        nuevas_coordenadas = [ varargin{1} , varargin{2} , default(3) ];
    else
        nuevas_coordenadas = [ varargin{1} , varargin{2} , varargin{3} ];
    end

    if (length(nuevas_coordenadas) == 1)
        s.point = [ nuevas_coordenadas(1), default(2) , default(3) ];

    elseif (length(nuevas_coordenadas) == 2)
        s.point = [
            nuevas_coordenadas(1),
            nuevas_coordenadas(2),
            nuevas_coordenadas(3)
        ];

    else
        s.point = [
            nuevas_coordenadas(1),
            nuevas_coordenadas(2),
            default(3)
        ];

    end

endfunction
