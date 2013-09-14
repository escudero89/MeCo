function [u1,u2,u3] = Ejemplo_NoEstacionario(hx)
%  Calculamos por diferencias finitas de la solucion de una PDE
%       (du/dt)-d^2u/dx^2 = 100*x; 0 < x < 1;
%       u(0,t) = 1; u(1,t) = 0;
%       u(x,0) = 0;

   x = [0:hx:1]';            %  puntos de la malla, incluyendo la frontera.
   n = length(x);

%  En base al numero de Fourier calculamos un delta t correcto
   fd = 1; % factor = 1 --> delta t límite, factor > 1 --> diverge
   ht = 0.5*(hx^2)*fd;

%  Tomamos un T maximo = ht*1000, si llega a su estado estacionario antes,
%  informamos en que tiempo fue, tomando una tolerancia definida por tol.
   tol = 0.0001; 
   nt = 1000; T = nt*ht;
   u = zeros(n,nt); 
   
   figure(1);
   plot(x,u(:,1),'*b--');
   disp('Metodo de integracion explicito');
   no_est = 1; % bandera para saber si llego a un estado estacionario
   a = ht/(hx^2);
   b = 1-((2*ht)/(hx^2));
   for t=2:nt
       for i=2:(n-1)
           u(i,t)=a*u(i-1,t-1)+b*u(i,t-1)+a*u(i+1,t-1)+(100*x(i)*ht);
       end
       u(1,t) = 1; %  Izquierda BC
       u(n,t) = 0; %  Derecha BC
       plot(x,u(:,t),'*b--');
       pause(0.15);
       if (norm(u(:,t)-u(:,t-1),2)/norm(u(:,t),2) < tol)
           disp ('La solucion ha llegado a un estado estacionario');
           fprintf('Los pasos realizados fueron: %d\n',t)
           fprintf('El tiempo transcurrido fue de: %f segundos\n',t*ht)
           no_est = 0;
           break;
       end
   end
   if (no_est)
       disp ('La solucion no llego a un estado estacionario, se requieren mas pasos de simulacion');
   end
   u1=u(:,t);
   
   disp ('Presione una tecla para continuar');
   pause
   
   disp('Metodo de integracion implicito');
   ht=ht*2; %aumento el paso de tiempo para acelerar la convergenicia 
   %ya que no es necesario cumplir con el coeficiente de Fourier
   no_est = 1; % bandera para saber si llego a un estado estacionario
   u = zeros(n,nt);
   u_ap = zeros(n-2,1);
   K = zeros(n-2);
   Q = zeros (n-2,1);
   A = (1/ht)+(2/(hx^2));
   fila = [(-1/(hx^2)) A (-1/(hx^2))];
   K(1,1:2) = fila(2:3); Q(1) = 100*x(2);
   for i=2:(n-3)
        K(i,i-1:i+1) = fila;
        Q(i) = 100*x(i+1);
   end
   K(n-2,n-3:n-2) = fila(1:2); Q(n-2) = 100*x(n-1);
   u_left = 1;   %  Izquierda BC
   u_right = 0;  %  Derecha BC
   plot(x,u(:,1),'*b--');
   for t=2:nt
       b = Q + (u_ap./ht);
       if (t ~= 2)
           b(1) = b(1) + (u_left/(hx^2));
           b(n-2) = b(n-2) + (u_right/(hx^2)); %u_right en este caso es cero, pero podria no serlo
       end
       u_ap = K\b;
       u(2:n-1,t) = u_ap;
       u(1,t) = 1;
       u(n,t) = 0;
       plot(x,u(:,t),'*b--');
       pause(0.15);
       if (norm(u(:,t)-u(:,t-1),2)/norm(u(:,t),2) < tol)
           disp ('La solucion ha llegado a un estado estacionario');
           fprintf('Los pasos realizados fueron: %d\n',t)
           fprintf('El tiempo transcurrido fue de: %f segundos\n',t*ht)
           no_est=0;
           break;
       end
   end
   if (no_est)
       disp ('La solucion no llego a un estado estacionario, se requieren mas pasos de simulacion');
   end
   u2=u(:,t);
   
   disp ('Presione una tecla para continuar');
   pause
   
   disp('Metodo de integracion de Crank Nicholson'); 
   ht=ht*2; %aumento el paso de tiempo para acelerar la convergenicia
   %ya que no es necesario cumplir con el coeficiente de Fourier
   no_est = 1; % bandera para saber si llego a un estado estacionario
   u = zeros(n,nt);
   u_ap = zeros(n-2,1);
   K = zeros(n-2);
   Q = zeros(n-2,1);
   A = (1/ht)+(1/(hx^2));
   fila = [(-1/(2*(hx^2))) A (-1/(2*(hx^2)))];
   K(1,1:2) = fila(2:3); Q(1) = 100*x(2); 
   for i=2:(n-3)
        K(i,i-1:i+1) = fila;
        Q(i) = 100*x(i+1);
   end
   K(n-2,n-3:n-2) = fila(1:2); Q(n-2) = 100*x(n-1);
   b = zeros (n-2,1);
   u_left = 1;   %  Izquierda BC
   u_right = 0;  %  Derecha BC
   plot(x,u(:,1),'*b--');
   for t=2:nt
       for i=2:(n-1)
           b(i-1) = Q(i-1) + ((1/(2*(hx^2)))*u(i-1,t-1)) + (((1/ht)-(1/(hx^2)))*u(i,t-1)) + ((1/(2*(hx^2)))*u(i+1,t-1));
       end
       if (t ~= 2)
           b(1) = b(1) + ((1/(2*(hx^2)))*u_left);
           b(n-2) = b(n-2) + ((1/(2*(hx^2)))*u_right); %u_right en este caso es cero, pero podr�a no serlo
       end
       u_ap = K\b;
       u(2:n-1,t) = u_ap;
       u(1,t) = 1;
       u(n,t) = 0;
       plot(x,u(:,t),'*b--');
       pause(0.15);
       if (norm(u(:,t)-u(:,t-1),2)/norm(u(:,t),2) < tol)
           disp ('La solucion ha llegado a un estado estacionario');
           fprintf('Los pasos realizados fueron: %d\n',t)
           fprintf('El tiempo transcurrido fue de: %f segundos\n',t*ht)
           no_est=0;
           break;
       end
   end
   if (no_est)
       disp ('La solucion no llego a un estado estacionario, se requieren mas pasos de simulacion');
   end
   u3=u(:,t);
   
   disp ('Presione una tecla para continuar');
   pause
   
   %analitica estacionaria
   x1=0:hx/2:1; % uso una malla más fina para tener una buena descripcion de la curva
   u_an=(-50/3)*(x1.^3)+(47/3)*x1+1;
   figure(2);
   plot(x,u1,'+r--',x,u2,'*g-',x,u3,'b--',x1,u_an,'oy-')
   xlabel('eje x')
   ylabel('u(x)')
   titulo = ['N� puntos:  ', num2str(n)];
   title(titulo)
   legend('Metodo Explicito','Metodo implicito','Crank Nicholson','Analitica')

end

