function [R_iso] = modelo_iso(largo,alto,espesor,rho,E,nu,poi,f)
%% Constantes

lx = largo;
ly = alto;
t = espesor;
c = 343;                    % Velocidad del sonido en el aire [m/s]
rho_cero = 1.18;            % Densidad del aire [kg/m^3]
m = rho*t;                  % Masa superficial [kg/m^2]
B = (E*t^3)/(12*(1-poi^2)); % Rigidez del material [Nm^2]

%% Frecuencias 
% Bandas de tercios de octavas

fc = (c^2/(2*pi))*sqrt(m/B);             % Frecuencia crítica [Hz]
fd = (E/(2*pi*rho))*sqrt(m/B);           % Frecuencia de densidad [Hz]
f11 = (c^2/(4*fc))*((1/lx^2)+(1/ly^2));  % Frecuencia modo 1,1 [Hz]

%% Cálculos

% Factor de pérdidas por frecuencias
nu_total = (nu*ones(1, length(f)))+(m./(485*sqrt(f)));

% Número de onda
k = (2*pi.*f)./c;

% Factor A
for i = 1:length(f);
    A(i) = -0.964-(0.5 + ly/(pi*lx))*log(ly/lx) + ((5*ly)/(2*pi*lx)) - (1/(4*pi*lx*ly*k(i)^2));
end

% Deltas

lambda = sqrt(f/fc);


for i = 1:length(f);
    delta_1(i) = ((1-lambda(i)^2)*(log((1+lambda(i))/(1-lambda(i)))) + (2*lambda(i)))/((4*pi^2)*((1-(lambda(i)^2))^(1.5)));
    if f(i)>0.5*fc;
        delta_2(i) = 0;
    else
        delta_2(i) = (8*c^2*(1-(2*lambda(i)^2)))/(fc^2*pi^4*lx*ly*lambda(i)*sqrt(1-lambda(i)^2));
    end
end

% Sigmas
   %-----Factor de radiación por ondas de flexión
if f11<=0.5*fc;
    for i = 1:length(f);
        if f(i)>=fc;
            sigma(i) = 1/sqrt(1-(fc/f(i)));
        else f(i)<fc;
            sigma(i) = ((2*(lx+ly)*c*delta_1(i))/(lx*ly*fc)) + delta_2(i);
        end
    end
    
    for i = 1:length(f);
        if f(i)<f11<0.5*fc  &&  sigma(i)>4*lx*ly*(f(i)/c)^2;
            sigma(i) = 4*lx*ly*(f(i)/c)^2;
        end
    end
else
    for i = 1:length(f);
        if f(i)<fc  &&  (4*lx*ly*(f(i)/fc)^2)<sqrt((2*pi*f(i)*(lx+ly))/(16*c));
            sigma(i) = 4*lx*ly*(f(i)/fc)^2;
        else if f(i)>fc  &&  (1/sqrt(1-(fc/f(i))))<sqrt((2*pi*f(i)*(lx+ly))/(16*c));
                sigma(i) = 1/sqrt(1-(fc/f(i)));
            else 
                sigma(i) = sqrt((2*pi*f(i)*(lx+ly))/(16*c));
            end
        end
    end
end

    %-----Factor de radiación para transmisión forzada (si lx>ly) 
    
k = (2*pi.*f)./c;    % Número de onda

for i = 1:length(f) ; % Factor A
    A(i) = -0.964-(0.5 + ly/(pi*lx))*log(ly/lx) + ((5*ly)/(2*pi*lx)) - (1/(4*pi*lx*ly*k(i)^2));
end

for i = 1:length(f);
    sigma_f(i) = 0.5*(log(k(i)*sqrt(lx*ly))-A(i));
end
          % Valores de sigma superiores a 2
for i = 1:length(f);
    if sigma(i)>2;
        sigma(i)=2;
    end
    if sigma_f(i)>2;
        sigma_f(i)=2;
    end
end

% Coeficiente de transmisión

for i = 1:length(f)
    if f(i)> fc+.05*fc
        tao(i) = (((2*rho_cero*c)/(2*pi*f(i)*m))^2)*((pi*fc*sigma(i)^2)/(2*f(i)*nu_total(i)));
    else if f(i)<fc-.05*fc
            tao(i) = (((2*rho_cero*c)/(2*pi*f(i)*m))^2)*(2*sigma_f(i) + ((lx+ly)^2/(lx^2+ly^2))*sqrt(fc/f(i))*(sigma(i)^2/nu_total(i)));
        else
            tao(i) = (((2*rho_cero*c)/(2*pi*f(i)*m))^2)*((pi*sigma(i)^2)/(2*nu_total(i)));
        end
    end
end

% Aislamiento por bandas de tercio de octava

for i = 1:length(f)
    R_iso(i) = -10*log10(tao(i));
end

R_iso;
end
