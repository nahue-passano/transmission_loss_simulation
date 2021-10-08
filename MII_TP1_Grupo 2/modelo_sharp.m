function  TL= modelo_sharp(h, dens,young,perd,poisson,f)

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
    
    if f(i) < 0.5*f_c 
        
        R = 10*log10(1+ ( (pi*m*f(i)) / (p_o*co) )^2 ) - 5.5 ;
        
    elseif f(i)>= f_c 
        
        R_1 = 10*log10(1 + ( (pi*m*f(i)) / (p_o*co) )^2 ) + 10*log10( (2*n_total*f(i)) / (pi*f_c) ) ;
        R_2 = 10*log10(1 + ( (pi*m*f(i)) / (p_o*co) )^2 ) - 5.5 ;
        R = min(R_1, R_2) ;
                
    else
        R_a = 10*log10(1+ ( (pi*m*f_c*0.5) / (p_o*co) )^2 ) - 5.5 ;   
        
        n_total = n_interno + (m/(485*sqrt(f_c)));
        R_1 = 10*log10(1 + ( (pi*m*f_c) / (p_o*co) )^2 ) + 10*log10( (2*n_total*f_c) / (pi*f_c) ) ;
        R_2 = 10*log10(1 + ( (pi*m*f_c) / (p_o*co) )^2 ) - 5.5 ;
        R_b = min(R_1, R_2) ;
        
        R = 2*((R_b-R_a)/(f_c))*(f(i)-0.5*f_c) + R_a;
    end
    TL(i) = R ;
end 

end



