function [TL,f] = modelo_Davy(h,dens,young,perd,poisson,l_x,l_y)

p = dens;        % Densidad del material
E = young;       % Modulo de Young
F = perd;        % Factor de pérdidas
P = poisson;     % Módulo de Poisson

co = 343;                            % Velocidad del sonido en el aire
p_o = 1.18 ;                         % Densidad del aire. 

averages = 3; 
m = p*h ;                          % Masa superficial del elemento 
B = (E*h^3)/(12*(1-P^2)) ;         % Rigidez a la deflexión. 
f_c = ((co^2)/(2*pi))*(sqrt(m/B));   % Frecuencia crítica [Hz] 
f_d = (E/(2*pi*p))*(sqrt(m/B));    % Frecuencia de densidad [Hz].
n_interno = F ;                      % Factor de perdidas internas del material
f_11 = (co^2/(4*f_c))*((1/l_x^2)+(l_y^2));
% Bandas de tercios de octavas
f = [25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6000, 8000, 10000, 12500, 16000, 20000];

n_total = (F*ones(1, length(f))) + (m./(485*sqrt(f))) ;
ratio = f./f_c;
limit = 2^(1/6);

 for i = 1:length(f) 
        if (ratio(i)<(1/limit)) || (ratio(i)>limit) ;
            Tlost = Single_leaf_Davy(f(i),p,E,P,h,n_total(i),l_x,l_y);
        else
            Avsingle_leaf = 0 ; 
            for  j = 1:averages  
                factor = 2^((2*j-1-averages)/(2*averages*3)) ;
                aux = 10^(-Single_leaf_Davy(f(i)*factor,p,E,P,h,n_total(i),l_x,l_y)/10);
                Avsingle_leaf = Avsingle_leaf + aux ;      
            end
            Tlost = -10*log10(Avsingle_leaf/averages) ; 
        end
        TL(i) = Tlost ;
 end
end
 %%
    function [single_leaf] = Single_leaf_Davy(f,p,E,P,h,n_total,l_x,l_y)
   
% Definimos constantes

co = 343;        % Velocidad del sonido en el aire
p_o = 1.18 ;     % Densidad del aire. 
averages = 3; 
m = p*h ;                          % Masa superficial del elemento 
B = (E*h^3)/(12*(1-P^2)) ;         % Rigidez a la deflexión. 

        
cos21max = 0.9 ; %Angulo limite definido en el trabajo de Davy
 
critical_frequency = sqrt(12*p*(1-P^2)/E)*co^2/(2*h*pi); 
normal = p_o*co/(pi*f*m);              
normal_2= normal*normal;
e = 2*l_x*l_y/(l_x+l_y) ;
cos2l = co/(2*pi*f*e) ;

 ratio = f/critical_frequency ;
 r = 1-1/ratio;

        if cos2l > cos21max
            cos2l = cos21max ;
        end 
     
        if r<0
            r = 0 ;
        end
        
        
   tau_1 = normal_2*log((normal_2+1)/(normal_2+cos2l));
       

        
        G = sqrt(r) ;
        rad = Sigma(G,f,l_x,l_y) ;
        rad2 = rad*rad ;
        neta_total = n_total+rad*normal ;
        z = 2/neta_total ; 
        y = atan(z) - atan(z*(1-ratio)) ;
        tau_2 = normal_2*rad2*y/(neta_total*2*ratio) ;
        sh=shear(f,p,E,P,h) ;
        tau_2 = tau_2*sh;     
   
        
        if  f<critical_frequency
            tau = tau_1 + tau_2 ;
        else 
           tau = tau_2;
        end
       single_leaf = -10*log10(tau);
    end
    
    
    
    function [rad] = Sigma(G,f,l_x,l_y)
        %defino constantes 
        c = 343;
        w = 1.3;
        beta = 0.234;
        n = 2 ;
        S = l_x*l_y ; 
        U = 2*(l_x+l_y) ; 
        twoa = 4*S/U ;
        k = 2*pi*f/c ;
        efe = w*sqrt(pi/(k*twoa));
   
        if  efe > 1 
            efe = 1; 
        end
        
        hache = 1/(sqrt(k*twoa/pi)*2/3-beta) ;
        q = 2*pi/(k*k*S);
        qn = q^n;
        
        if G<efe 
            alpha = hache/efe-1 ;
            xn = (hache-alpha*G)^n ;
        else
            xn = G^n ; 
        end
        rad = (xn+qn)^(-1/n);
    end

%% DEfinimos la funcion Shear  
    function [out] = shear(f,p,E,P,h)
        
        %definimos variables.
        omega = 2*pi*f ;
        chi = ((1+P)/(0.87 + 1.12*P))^2 ; 
        X = h*h/12 ;
        QP = E/(1-P*P);
        C = -omega*omega ; 
        B = C*(1+2*chi/(1-P))*X ;
        A = X*QP/p ;
        
        kbcor2 = (-B+sqrt(B*B-4*A*C))/(2*A) ;
        kb2 = sqrt (-C/A) ; 
        
        G = E/(2*(1+P));
        
        kT2 = -C*p*chi/G;
        kL2 = -C*p/QP;
        kS2 = kT2 + kL2;
     
        ASI = 1 + X*(kbcor2*kT2/kL2-kT2);
        ASI = ASI*ASI;
        
        BSI = 1 - X*kT2 + kbcor2*kS2/(kb2*kb2);
        CSI = sqrt(1 - X*kT2 + kS2.^2/(4*kb2.^2));
  
        out = ASI/(BSI*CSI);
    end
            
