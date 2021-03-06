1;


clear all;
clf;
close;


function [ H ] = hijos_marcos(E, idx_mod, segmentos)

    cabecera = [E.cabecera(1), idx_mod, E.cabecera(3)+1];

    % p7 -- p6 -- p5
    % ||    ||    ||
    % p8 -- p9 -- p4
    % ||    ||    ||
    % p1 -- p2 -- p3

    #Calculamos hijos

    p1 = E.puntos(1, :);
    p3 = E.puntos(2, :);  
    p5 = E.puntos(3, :);
    p7 = E.puntos(4, :);

    p2 = [ (p1(1)+p3(1))/2 , p1(2) ];
    p4 = [ p3(1), (p1(2)+p7(2))/2 ];
    p6 = [ (p1(1)+p3(1))/2 , p5(2) ];
    p8 = [ p1(1) , p4(2) ];
    p9 = [ p2(1) , p4(2) ];

    vecinos = []; #@TODO funcion que calcula vecinos

    E1 = struct("cabecera", cabecera + [0 1 0],
                "puntos", [p1 ; p2 ; p9 ; p8],
                "matriz_intersecciones", [],
                "vecinos", vecinos);

    E2 = struct("cabecera", cabecera + [0 2 0],
                "puntos", [p2 ; p3 ; p4 ; p9],
                "matriz_intersecciones", [],
                "vecinos", vecinos);

    E3 = struct("cabecera", cabecera + [0 3 0],
                "puntos", [p9 ; p4 ; p5 ; p6],
                "matriz_intersecciones", [],
                "vecinos", vecinos);

    E4 = struct("cabecera", cabecera + [0 4 0],
                "puntos", [p8 ; p9 ; p6 ; p7],
                "matriz_intersecciones", [],
                "vecinos", vecinos);

    H = { E1 , E2, E3, E4 };

    H = actualizar_intersecciones(H, E.matriz_intersecciones, segmentos);

    return;

endfunction


# MIP = Matriz Intersecciones Padre
function [H] = actualizar_intersecciones(H, MIP, segmentos)

    global TOL; 

    puntos_en_cruz = [
        H{1}.puntos(2,:) ;
        H{3}.puntos(2,:) ;
        H{3}.puntos(4,:) ;
        H{1}.puntos(4,:) ];

    elemento_ganador = [ 1 2 ; 2 3 ; 4 3 ; 1 4 ];

    idx_segmentos_sin_calcular = [];

    # Calcular Intersecciones Aristas Exteriores

    for i = 1 : size(MIP,1)
        # Si es un segmento interior.
        if( sum(MIP(i,2:5)) == 0 )

            %~ [hay_inter_1, punto_inter_1] = ...
                %~ hay_interseccion(segmentos(MIP(i,1))(1),segmentos(MIP(1))(2),
                                    %~ puntos_en_cruz(1), puntos_en_cruz(3));
                                    %~ 
            %~ [hay_inter_2, punto_inter_2] = ...
                            %~ hay_interseccion(segmentos(MIP(i,1))(1),segmentos(MIP(1))(2),
                                    %~ puntos_en_cruz(4), puntos_en_cruz(2));

            idx_segmentos_sin_calcular = [ idx_segmentos_sin_calcular , MIP(i,1) ];
        
        else # Si es un segmento que intersecta

            for j = 2:5 # Recorremos Aristas

                pos = j * 4 - 2; # vincula intersecciones de la arista j

                if(MIP(i,j) == 1) #Interseccion simple

                    # Va a depender de la orientacion, 1 o 2 => x o y
                    x_y = mod(j,2) + 1;
                    
                    pto_inter = [ MIP(i, pos) , MIP(i, pos + 1) ];

                    # Si esta del lado menor coord... (puede estar en ambos)
                    if (pto_inter(x_y) <= puntos_en_cruz(j-1, x_y) + TOL)

                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif
                    
                    # Si esta del lado mayor coord... (puede estar en ambos)
                    if (pto_inter(x_y) >= puntos_en_cruz(j-1, x_y) - TOL)

                        H{elemento_ganador(j - 1, 2)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 2)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif

                elseif(MIP(i,j) == 2) #Interseccion Coincidente
                    ## @TODO se puede optimizar reduciendo el numero de casos
                    
                    # Va a depender de la orientacion, 1 o 2 => x o y
                    x_y = mod(j,2) + 1;
                    
                    pto_inter_1 = [ MIP(i, pos) , MIP(i, pos + 1) ];
                    pto_inter_2 = [ MIP(i, pos + 2) , MIP(i, pos + 3) ];

                    # Si estan ambos extremos del lado menor... (puede estar en ambos)
                    if (pto_inter_1(x_y) <= (puntos_en_cruz(j-1, x_y) + TOL) &&
                        pto_inter_2(x_y) <= (puntos_en_cruz(j-1, x_y) + TOL) )

                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];
                        
                    endif
                    
                    # Si ambos extremos estan del lado mayor... (puede estar en ambos)
                    if (pto_inter(x_y) >= (puntos_en_cruz(j-1, x_y) - TOL) &&
                        pto_inter(x_y) >= (puntos_en_cruz(j-1, x_y) - TOL))

                        H{elemento_ganador(j - 1, 2)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 2)}.matriz_intersecciones ;
                            MIP(i, :)
                        ];

                    endif

                    # Si los extremos estan en distintos lados
                    if ( (pto_inter_1(x_y) - puntos_en_cruz(j-1, x_y)) * 
                         (pto_inter_2(x_y) - puntos_en_cruz(j-1, x_y)) < 0) 

                        nuevo_MIP = MIP(i, :);
                        
                        if (pto_inter_1(x_y)  >= puntos_en_cruz(j-1, x_y))
                            nuevo_MIP(pos:pos+1) = [
                                max(nuevo_MIP(pos), puntos_en_cruz(j-1, x_y)),
                                max(nuevo_MIP(pos+1), puntos_en_cruz(j-1, x_y)),
                            ];
                        else
                            nuevo_MIP(pos:pos+1) = [
                                min(nuevo_MIP(pos), puntos_en_cruz(j-1, x_y)),
                                min(nuevo_MIP(pos+1), puntos_en_cruz(j-1, x_y)),
                            ];
                        endif

                        
                        H{elemento_ganador(j - 1, 1)}.matriz_intersecciones = [
                            H{elemento_ganador(j - 1, 1)}.matriz_intersecciones ;
                            nuevo_MIP
                        ];
                        
                    endif

                endif

            endfor


        end
        
    endfor
    
    % Calcular Intersecciones Aristas Interiores
    aristas_interiores = [ 0 1 1 0 ; 0 0 1 1 ; 1 0 0 1 ; 1 1 0 0 ];

    % Recorre cada uno de los elementos apendando las matrices de intersecciones
    % de aquellos segmentos que eran "interiores"
    for k = 1 : 4

        H{k}.matriz_intersecciones = [
            H{k}.matriz_intersecciones ;
            segmentos_en_elemento(H{k},
                                  segmentos(idx_segmentos_sin_calcular, :),
                                  aristas_interiores(k, :));
        ];
        
    endfor
    
endfunction





#tic
#plot_malla(M);
#hold on;
#plot(figura_x,figura_y)
#hold off;
#toc;








paso = pi/2;
rho = 0.3;

tita = 0:paso:2*pi-paso;
rho = rho*ones(1,length(tita));
figura_x = rho .* cos(tita) + 0.5;
figura_y = rho .* sin(tita) + 0.5;

segmentos_next = ...
	[ figura_x'(2:end) figura_y'(2:end) ; figura_x'(1) figura_y'(1) ];

segmentos = ...
	[ figura_x' figura_y' segmentos_next ] ;



cabecera = [1 1 0];
P1 = [0 0];
P2 = [1 0];
P3 = [1 1];
P4 = [0 1];

 E = struct("cabecera", cabecera,
                        "puntos", [P1 ; P2 ; P3 ; P4],
                        "matriz_intersecciones", [],
                        "vecinos", []);



[ matriz_intersecciones ] = segmentos_en_elemento(E, segmentos);

            E.matriz_intersecciones = matriz_intersecciones;


# M = subdividir(E,3,1, segmentos);
H = hijos_marcos(E, 1, segmentos);

