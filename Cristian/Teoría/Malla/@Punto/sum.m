% Recibe un punto y un dx, dy, dz que lo modifican
function s = sum (p, dx, dy = 0, dz = 0)
    
    default = get(p);

    default(1) += dx;
    default(2) += dy;
    default(3) += dz;

    s = Punto([default(1), default(2), default(3)]);

endfunction