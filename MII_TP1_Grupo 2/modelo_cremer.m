function  TL= modelo_cremer(h, dens,young,perd,poisson,f)

p = dens;        % Densidad del materia
E = young;       % Modulo de Young
F = perd;        % Factor de pérdidas
P = poisson;     % Módulo de Poisson

co = 343;                            % Velocidad del sonido en el aire
p_o = 1.18 ;                         % Densidad del aire. 

m = p*h ;                          % Masa superficial del elemento 
B = ((E*h^3)/(12*(1-P^2))) ;         % Rigidez a la deflexión. 
f_c = ((co^2)/(2*pi))*(sqrt(m/B));   % Frecuencia crítica [Hz] 
f_d = (E/(2*pi*p))*(sqrt(m/B));    % Frecuencia de densidad [Hz].
n_interno = F ;                      % Factor de perdidas internas del material

TL = zeros(1,30);

for i = 1:30
    
    n_total = n_interno + (m/(485*sqrt(f(i)))) ;    

     if f(i) <  f_c || f(i) > f_d
         
         R = 20*log10(m*f(i))-47; 
         
     else 
         
         R = 20*log10(m*f(i)) - 10*log10(pi/(4*n_total))- 10*log10(f_c/(f(i)-f_c))-47 ;
         
     end
     TL(i) = R;
end        
end