%% ###########################################################################
%  ######              TRABAJO PRACTICO 1: Pared Simple                 ######
%  ###########################################################################
%  ######                       ESTUDIANTES                             ######
%  ######         *Espíndola, Agustín.     *Passano, Nahuel             ######
%  ######         *Ricciardi, Micaela                                   ######
%  ###########################################################################

%% ###### GRAPHIC USER INTERFACE ###### 
clear

dspfigure = figure('Visible','off','units','normalized','Position',[0 0 1 0.96],...
    'Name','Aislamiento a ruido aéreo de una pared simple mediante distintos métodos de predicción',...
    'NumberTitle','off','toolbar','none');dspfigure.MenuBar = 'none';dspfigure.Visible = 'off';

%% ###### EXTRAS ######

% Finalizar
extra_close_pb = uicontrol('parent', dspfigure,'style','pushbutton','string','Finalizar','units','normalized',...
    'position',[0.86 0.925 0.11 0.05],'fontsize',10,'callback',{@closegui,dspfigure});
% Help
extra_help_pb = uicontrol('parent', dspfigure,'style','pushbutton','string','Ayuda','units','normalized',...
    'position',[0.86 0.865 0.11 0.05],'fontsize',10,'callback',{@helpgui,dspfigure});

%% ###### AÑADIR MATERIAL ######
 
addmaterial_fig = figure('Visible','off','units','normalized','Position',[0.15 0.2 0.7 0.6],...
    'Name','Añadir material',...
    'NumberTitle','off','toolbar','none');addmaterial_fig.MenuBar = 'none';

%Textbox
    addmat_titulo = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Añadir material ','fontsize',24, ...
            'Units','Normalized','position',[0.05 0.8 0.3 0.1],...
            'BackGroundColor',[1 164/255 32/255]);
    addmat_loaded = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Materiales cargados ','fontsize',24, ...
            'Units','Normalized','position',[0.4 0.8 0.55 0.1],...
            'BackGroundColor',[1 164/255 32/255]);
                
    addmat_material = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Nombre del material ','fontsize',11, ...
            'Units','Normalized','position',[0.05 0.66 0.3 0.1]);
    addmat_dens = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Densidad [kg/m^3] ','fontsize',11, ...
            'Units','Normalized','position',[0.05 0.50 0.15 0.1]);
    addmat_young = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Módulo de Young ','fontsize',11, ...
            'Units','Normalized','position',[0.05 0.42 0.15 0.1]);
        addmat_multiplicador = uicontrol('parent', addmaterial_fig,'Style','text',...
                'String','x 10','fontsize',11, ...
                'Units','Normalized','position',[0.265 0.422 0.05 0.1]);
        
    addmat_perd = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Factor de perdidas','fontsize',11, ...
            'Units','Normalized','position',[0.05 0.34 .15 0.1]);
    addmat_poisson = uicontrol('parent', addmaterial_fig,'Style','text',...
            'String','Módulo de Poisson','fontsize',11, ...
            'Units','Normalized','position',[0.05 0.26 0.15 0.1]);
    
    % Editbox
    addmat.material = uicontrol('parent', addmaterial_fig,'Style','edit',...
            'fontsize',11,...
            'Units','Normalized','position',[0.08 0.66 0.24 0.05]);
    addmat.dens = uicontrol('parent', addmaterial_fig,'Style','edit',...
             'fontsize',11,...
            'Units','Normalized','position',[0.2 0.555 0.13 0.050]);
    addmat.young = uicontrol('parent', addmaterial_fig,'Style','edit',...
             'fontsize',11,...
            'Units','Normalized','position',[0.2 0.475 0.068 0.050]);
        addmat.mult = uicontrol('parent', addmaterial_fig,'Style','edit',...
                'fontsize',7,...
                'Units','Normalized','position',[0.307 0.495 0.02 0.03]);
    addmat.perd = uicontrol('parent', addmaterial_fig,'Style','edit',...
             'fontsize',11,...
            'Units','Normalized','position',[0.2 0.395 0.13 0.050]);
    addmat.poisson = uicontrol('parent', addmaterial_fig,'Style','edit',...
            'fontsize',11,...
            'Units','Normalized','position',[0.2 0.315 0.13 0.050]);
        
    % Pushbutton
    
    addmat_save = uicontrol('parent',addmaterial_fig,'style','pushbutton','string','Guardar y añadir',...
            'units','normalized','position',[0.08 0.2 0.22 0.07],'fontsize',12,...
            'callback',{@addmatsave,addmat});
        
    addmat_back = uicontrol('parent',addmaterial_fig,'style','pushbutton','string','Volver',...
            'units','normalized','position',[0.42 0.02 0.16 0.07],'fontsize',12,...
            'callback',{@addmatback,addmaterial_fig});
           
   % Tabla
   
   addmat_tabla = uitable('parent', addmaterial_fig,'units','normalized','Position',[0.4 0.15 0.55 0.65],...
    'ColumnName',{'Material','Densidad','Módulo de Young','Factor de perdidas','Módulo de Poisson'},...
    'BackgroundColor',[0.7 0.75 0.8]);
 
%% ###### TITULO y LOGO ######

% Titulo
titulodsp = uicontrol('parent',dspfigure,'style','text',...
        'string','Aislamiento a ruido aéreo de una pared simple mediante distintos métodos de predicción',...
        'units','normalized','position',[0.15 0.865 0.70 0.11],'fontsize',24,...
        'backgroundcolor',[3/255 0 104/255]  ,'foregroundcolor',[1 1 1],'fontweight','bold');

% Logo
logodsp = axes('parent',dspfigure,'units','normalized','position',[0.04 0.865 0.10 0.11]);
axes(logodsp);
imshow('UNTREF-LOGO.png');

grafico_fondo = uicontrol('parent',dspfigure,'style','text','units','normalized','position',[0.37 0.71 0.31 0.06],'string',''...
     ,'BackGroundColor',[200/255 200/255 200/255]);
grafico_fondo_1 = uicontrol('parent',dspfigure,'style','text','units','normalized','position',[0.70 0.71 0.19 0.06],'string',''...
     ,'BackGroundColor',[200/255 200/255 200/255]);
 

%% ########## ESPECIFICACIONES TÉCNICAS ########

spects_titulo = uicontrol('parent',dspfigure,'style','text','string','Especificaciones técnicas del material',...
        'units','normalized','position',[0.03 0.37 0.24 0.09],'fontsize',20,...
        'backgroundcolor',[90/255 165/255 255/255]);
% Text
spects_material = uicontrol('parent', dspfigure,'Style','text',...
            'String','Material ','fontsize',12, ...
            'Units','Normalized','position',[0.03 0.29 0.12 0.050]);
spects_dens = uicontrol('parent', dspfigure,'Style','text',...
            'String','Densidad [kg/m^3] ','fontsize',12, ...
            'Units','Normalized','position',[0.03 0.235 0.12 0.050]);
spects_young = uicontrol('parent', dspfigure,'Style','text',...
            'String','Módulo de Young ','fontsize',12, ...
            'Units','Normalized','position',[0.03 0.18 0.12 0.050]);
spects_perd = uicontrol('parent', dspfigure,'Style','text',...
            'String','Factor de perdidas','fontsize',12, ...
            'Units','Normalized','position',[0.03 0.125 0.12 0.050]);
spects_poisson = uicontrol('parent', dspfigure,'Style','text',...
            'String','Módulo de Poisson','fontsize',12, ...
            'Units','Normalized','position',[0.03 0.07 0.12 0.050]);
    
spects.material = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.15 0.29 0.12 0.050]);
spects.dens = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.15 0.235 0.12 0.050]);
spects.young = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.18 0.18 0.03 0.050]);
        spects_mult = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.205 0.18 0.03 0.050]);
        spects_mult_pot = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',8,...
            'Units','Normalized','position',[0.228 0.223 0.01 0.015]);
spects.perd = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.15 0.125 0.12 0.050]);
spects.poisson = uicontrol('parent', dspfigure,'Style','text',...
            'String','', 'fontsize',12,...
            'Units','Normalized','position',[0.15 0.07 0.12 0.050]);    

%% ###### INFORMACIÓN DEL MATERIAL ######
%Titulo
informacionprevia = uicontrol('parent',dspfigure,'style','text','string','Información del material',...
        'units','normalized','position',[0.03 0.79 0.24 0.050],'fontsize',20,...
        'backgroundcolor',[90/255 165/255 255/255]);
info_material = uicontrol('parent', dspfigure,'Style','text',...
            'String','Material ','fontsize',12, ...
            'Units','Normalized','position',[0.035 0.71 0.1 0.050]);
info_largo = uicontrol('parent', dspfigure,'Style','text',...
            'String','Largo [m]', 'fontsize',10,...
            'Units','Normalized','position',[0.04 0.61 0.06 0.09],...
            'BackGroundColor',[200/255 200/255 200/255]);
info_alto = uicontrol('parent', dspfigure,'Style','text',...
            'String','Alto [m]', 'fontsize',10,...
            'Units','Normalized','position',[0.12 0.61 0.06 0.09],...
            'BackGroundColor',[200/255 200/255 200/255]);
info_espesor = uicontrol('parent', dspfigure,'Style','text',...
            'String','Espesor [m]', 'fontsize',10,...
            'Units','Normalized','position',[0.2 0.61 0.06 0.09],...
            'BackGroundColor',[200/255 200/255 200/255]);

% Editboxss
info.largo = uicontrol('parent', dspfigure,'Style','edit','string','',...
            'units','normalized','position',[0.05 0.63 0.04 0.035]);
info.alto = uicontrol('parent', dspfigure,'Style','edit','string','',...
            'units','normalized','position',[0.13 0.63 0.04 0.035]);
info.espesor = uicontrol('parent', dspfigure,'Style','edit','string','',...
            'units','normalized','position',[0.21 0.63 0.04 0.035]);

% Popupmenu

info_popupmaterial = uicontrol('parent',dspfigure,'fontsize',10,'style','popup','units','normalized','position',....
    [0.115 0.715 0.125 0.05],'string',{''});
info_popupmaterial.Callback = {@listamateriales,info_popupmaterial,spects,spects_mult,spects_mult_pot};

        
% Pushbutton

info_addmat = uicontrol('parent',dspfigure,'style','pushbutton','string','Añadir material',...
            'units','normalized','position',[0.04 0.50 0.08 0.075],'fontsize',10,...
            'callback',{@addmatbutton,addmaterial_fig});
procesar_pushbutton = uicontrol('parent',dspfigure,'style','pushbutton','string','Procesar',...
            'units','normalized','position',[0.13 0.50 0.13 0.075],'fontsize',12);

%% ###### GRAFICOS ######

% Textbox's
graficos_titulo = uicontrol('parent',dspfigure,'style','text','string','Gráficos',...
        'units','normalized','position',[0.29 0.79 0.68 0.050],'fontsize',20,...
        'backgroundcolor',[1 98/255 98/255]);

graficos_metodo_text = uicontrol('parent',dspfigure,'style','text','units','normalized','position',[0.375 0.72 0.06 0.035],'string',...
    'Método:','fontsize',14,'BackGroundColor',[200/255 200/255 200/255]);


% Checkboxs
grafico.sharp = uicontrol('parent',dspfigure,'style','checkbox','fontsize',12,'units','normalized','position',[0.44 0.72 0.06 0.035],...
    'string','Sharp','BackGroundColor',[200/255 200/255 200/255]);
grafico.cremer = uicontrol('parent',dspfigure,'style','checkbox','fontsize',12,'units','normalized','position',[0.49 0.72 0.06 0.035],...
    'string','Cremer','BackGroundColor',[200/255 200/255 200/255]);
grafico.davy = uicontrol('parent',dspfigure,'style','checkbox','fontsize',12,'units','normalized','position',[0.63 0.72 0.04 0.035],...
    'string','Davy','BackGroundColor',[200/255 200/255 200/255]);
grafico.iso = uicontrol('parent',dspfigure,'style','checkbox','fontsize',12,'units','normalized','position',[0.55 0.72 0.08 0.035],...
    'string','ISO 1235-1','BackGroundColor',[200/255 200/255 200/255]);
grafico.sharp.Callback = {@checksharp,grafico};
grafico.cremer.Callback = {@checkcremer,grafico};
grafico.davy.Callback = {@checkdavy,grafico};
grafico.iso.Callback = {@checkiso,grafico};

% Axes
graficos_axes = axes('parent',dspfigure,'units','normalized','position',[0.32 0.1 0.65 0.55]);xlabel('');ylabel('');title('');{@exportar_figura,dspfigure};
datacursormode ('on'); xticks([20 31.5 63 125 250 500 1000 2000 4000 8000 16000]); yticks([]);
dcm = datacursormode(dspfigure);
set(dcm,'UpdateFcn',@myupdatefcn)


% Pushbutton
graficos_export_plot = uicontrol('parent',dspfigure,'style','pushbutton','string','Exportar gráfico','units','normalized',...
    'position',[0.71 0.72 0.08 0.035],'fontsize',10,'callback',...
    {@exportar_figura,graficos_axes,dspfigure,grafico});
graficos_export_tabla = uicontrol('parent',dspfigure,'style','pushbutton','fontsize',10,'string','Exportar tabla','units','normalized',...
    'position',[0.80 0.72 0.08 0.035],'callback',{@exportar_tabla,info_popupmaterial,grafico});

% Callback addmat

addmat_save.Callback = {@addmatsave,addmat,info_popupmaterial, addmat_tabla};

                                        %l,a,h   %ejes   %checkboxs   %Value del popup  
procesar_pushbutton.Callback = {@procesar,info,graficos_axes,grafico,info_popupmaterial,dspfigure};

dspfigure.Visible = 'off';
text_inicio = importdata('Inicio.txt'); % Carga mensaje de inicio
waitfor(helpdlg(text_inicio,'Bienvenidos'))
dspfigure.Visible = 'on';

%% ##############################################################################
%% ############################# FUNCIONES ######################################
%% ##############################################################################

global datosxls;
[datosxls,txt,raw]=xlsread('Tabla de materiales.xlsx');
datosxls = raw;
materiales = datosxls([2:end],2);
mat_lista = string(char({char('Seleccionar el material...') char(materiales)})); 
lista = info_popupmaterial;
lista.String = mat_lista;
addmat_tabla.Data = raw([2:end],[2:end]);

% Abrir pestaña para añadir materiales
function addmatbutton(object_handle,event,addmaterial_fig)
    addmaterial_fig.Visible = 'on';
end

% Cerrar pestaña para añadir materiales
function addmatback(object_handle,event,addmaterial_fig)
    addmaterial_fig.Visible = 'off';
end

% Seleccion de materiales a partir del popup menu
function listamateriales(~,~,info_popupmaterial,spects,spects_mult,spects_mult_pot)
    [num,txt,raw] = xlsread('Tabla de materiales.xlsx');
    raw = raw([2:end],[2:end]);
    k = info_popupmaterial.Value ;
    k=k-1 ;
    if k==0
        spects.material.String = '';
        spects.dens.String = '';
        spects.young.String = '';
        spects.perd.String = '';
        spects.poisson.String = '';
        spects_mult.String = '';
        spects_mult_pot.String = '';
    else
        spects.material.String = char(string(raw{k,1}));
        spects.dens.String = char(string(raw{k,2}));
        spects.young.String = char(string(raw{k,3}/1000000000));
        spects.perd.String = char(string(raw{k,4}));
        spects.poisson.String = char(string(raw{k,5}));
        spects_mult.String = 'x 10';
        spects_mult_pot.String = '9';
    end
end

% Añadir material
function addmatsave(~,~,addmat,info_popupmaterial,addmat_tabla)
if isempty(addmat.material.String) | isempty(str2num(addmat.dens.String)) |...
        isempty(str2num(addmat.young.String)) | isempty(str2num(addmat.mult.String)) ...
        | isempty(str2num(addmat.perd.String)) | isempty(str2num(addmat.poisson.String)) ...
        | str2num(addmat.dens.String)<0 |  str2num(addmat.young.String)<0 | ...
        str2num(addmat.perd.String)<0 | str2num(addmat.poisson.String)<0
    errordlg('Revise los campos de entrada','Error')
else

global datosxls
young = str2num(addmat.young.String)*10^(str2num(addmat.mult.String));
newmaterial = {addmat.material.String, str2double(addmat.dens.String), young,...
    str2double(addmat.perd.String), str2double(addmat.poisson.String)};
[datosxls, txt, raw] = xlsread('Tabla de materiales.xlsx');
raw1 = raw([2:end],[2:end]);
raw1(end + 1 ,[1:end]) = newmaterial;
addmat_tabla.Data = raw1;
datosxls = raw1;
materiales = datosxls(:,1);
mat_lista = string(char({char('Seleccionar el material...') char(materiales)})); 
lista = info_popupmaterial;
lista.String = mat_lista;

raw(end+1, [2:end]) = newmaterial;
raw{end,1} = length(raw1([1:end],1));
xlswrite('Tabla de materiales.xlsx',raw,'Hoja1','B2');

helpdlg('Material añadido correctamente',' ')

addmat.material.String = '';
addmat.dens.String = '';
addmat.young.String = '';
addmat.mult.String = '';
addmat.perd.String = '';
addmat.poisson.String = '';
end

end


%% PROCESAR
function procesar(~,~,info,graficos_axes,grafico,info_popupmaterial,dspfigure)
cla
graficos_axes.Visible = 'off';

if isempty(str2num(info.largo.String)) | isempty(str2num(info.alto.String)) ...
        | isempty(str2num(info.espesor.String)) | str2num(info.largo.String)<0 ...
        | str2num(info.alto.String)<0 | str2num(info.espesor.String)<0
    errordlg('Revise los campos de entrada','Error')
elseif info_popupmaterial.Value == 1
    errordlg('Seleccione un material','Error')
else
axes(graficos_axes);



global largo_exp alto_exp espesor_exp name_exp

loadingbar = waitbar(0,'...Procesando...');
pasos = 13;
clear i;    
% Levanta los datos de entrada
largo = info.largo.String;
largo = str2num(largo);
largo_exp = largo;
alto = info.alto.String;
alto = str2num(alto);
alto_exp = alto;
espesor = info.espesor.String;
espesor = str2num(espesor);
espesor_exp = espesor;

for i=1:100
    waitbar(i/1100)
    pause(0.001)
    end

% Carga de datos del excel
[a,b,raw] = xlsread('Tabla de materiales.xlsx');
raw = raw([2:end],[2:end]);

for i=200:300
    waitbar(i/1100)
    pause(0.001)
end

% Material seleccionado en el popup
k = info_popupmaterial.Value;
material = raw(k-1,[1:end]);
name = material{1};
name_exp = name;
dens = material{2};
young = material{3};
perd = material{4};
poisson = material{5};

for i=300:400
    waitbar(i/1100)
    pause(0.001)
    end

ms=dens*espesor; % Masa superficial

p_o = 1.18; % Densidad del aire

B = ((young*espesor^3)/(12*(1-poisson^2)));

f_c = ((343^2)/(2*pi))*(sqrt(ms/B));   %Frecuencia crítica [Hz] 

f_d = (young/(2*pi*dens))*(sqrt(ms/B));    %Frecuencia de densidad [Hz].

for i=400:500
    waitbar(i/1100)
    pause(0.001)
    end

format shortg
grafico.fc.String = round(f_c,1);
grafico.fd.String = round(f_d,1);
grafico.ms.String = round(ms,1);

%Frecuencias
f=[25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000];

global plot_sharp plot_cremer plot_iso plot_davy TLS

% Sharp (Cálculo)
[TL_sharp] = modelo_sharp(espesor,dens,young,perd,poisson,f);
for i=500:600
    waitbar(i/1100)
    pause(0.001)
    end
    
% Cremer (Cálculo)
[TL_cremer] = modelo_cremer(espesor, dens,young,perd,poisson,f);
for i=600:700
    waitbar(i/1100)
    pause(0.001)
    end

% ISO (Cálculo)
[TL_iso] = modelo_iso(largo,alto,espesor,dens,young,perd,poisson,f);
for i=700:800
    waitbar(i/1100)
    pause(0.001)
    end
    
% Davy (Cálculo)
[TL_davy] = modelo_Davy(espesor,dens,young,perd,poisson,largo,alto);
for i=800:900
    waitbar(i/1100)
    pause(0.001)
end

TLS = [TL_sharp ; TL_cremer ; TL_iso ; TL_davy];

     %####### PLOTEOS #######
     
% Sharp (Ploteo)
%axes(graficos_axes);
plot_sharp = semilogx(graficos_axes,f,TL_sharp,'-g.',...
    'MarkerSize',20); xlim(graficos_axes,[20 20000]);
xticks(graficos_axes,[25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000]);
grafico.sharp.Value = 1; xtickangle(graficos_axes,45);
grid(graficos_axes,'on')
hold(graficos_axes,'on')
plot_sharp.Visible = 'off';
ylabel(graficos_axes,'TL [dB]'); xlabel(graficos_axes,'Frecuencia [Hz]');
titulo_spects = string(['Largo: ' num2str(largo) ' m ; Alto: ' num2str(alto) ' m ; Espesor: ' num2str(espesor) ' m']);
opa = title(graficos_axes,{name ; titulo_spects});
opa.Visible = 'off';
        
% Cremer (Ploteo)
%axes(graficos_axes);
plot_cremer = semilogx(graficos_axes,f,TL_cremer,'-b.',...
    'MarkerSize',20); xlim(graficos_axes,[20 20000]);
plot_cremer.Visible = 'off';
grafico.cremer.Value = 1;
hold(graficos_axes,'on')


% ISO (Ploteo)
%axes(graficos_axes);
plot_iso = semilogx(graficos_axes,f,TL_iso,'-r.',...
    'MarkerSize',20); xlim(graficos_axes,[20 20000]);
plot_iso.Visible = 'off';
grafico.iso.Value = 1;
hold(graficos_axes,'on')


% Davy
%axes(graficos_axes);
plot_davy = semilogx(graficos_axes,f,TL_davy,'-k.',...
    'MarkerSize',20); xlim(graficos_axes,[20 20000]);
plot_davy.Visible = 'off';
grafico.davy.Value = 1;
hold(graficos_axes,'on')

    
%axes(graficos_axes);
epa = legend(graficos_axes,'Sharp','Cremer','ISO 1235-1','Davy','Location','northwest');
epa.Visible = 'off';

    
ann_fc_1 = 'f_c: ';
ann_fc_2 = num2str(round(f_c,1));
ann_fc_3 = ' Hz';
ann_fc_string = ['$$' ann_fc_1 ann_fc_2 '$$' ann_fc_3];
ann_fc = text(graficos_axes,'Units', 'Normalized','Position',[0.83 0.21],'String',ann_fc_string,'FontSize',12,...
    'Interpreter','latex');
ann_fc.Visible = 'off';

ann_fd_1 = 'f_d: ';
ann_fd_2 = num2str(round(f_d,1));
ann_fd_3 = ' Hz';
ann_fd_string = ['$$' ann_fd_1 ann_fd_2 '$$' ann_fd_3];
ann_fd = text(graficos_axes,'Units', 'Normalized','Position',[0.83 0.14],'String',ann_fd_string,'FontSize',12,...
    'Interpreter','latex');
ann_fd.Visible = 'off';

ann_ms_1 = 'm_s: ';
ann_ms_2 = num2str(round(ms,1));
ann_ms_3 = ' kg/m^2';
ann_ms_string = ['$$' ann_ms_1 ann_ms_2 '$$' ' ' '$$' ann_ms_3 '$$'];
ann_ms = text(graficos_axes,'Units', 'Normalized','Position',[0.83 0.07],'String',ann_ms_string,'FontSize',12,...
    'Interpreter','latex');
ann_ms.Visible = 'off';


graficos_axes.Visible = 'on';
ann_ms.Visible = 'on';
ann_fc.Visible = 'on';
ann_fd.Visible = 'on';
plot_sharp.Visible = 'on';
plot_cremer.Visible = 'on';
plot_iso.Visible = 'on';
plot_davy.Visible = 'on';
epa.Visible = 'on';
opa.Visible = 'on';


for i=900:1000
    waitbar(i/1100)
    pause(0.0005)
end

info_popupmaterial.Value =1 ;
info.largo.String = '';
info.alto.String = '';
info.espesor.String = '';

for i=900:1000
    waitbar(i/1100)
    pause(0.0005)
end

close(loadingbar);
end
end

%%

% Exportar gráfico
 function exportar_figura (~,~,graficos_axes,dspfigure,grafico)
 
 if grafico.sharp.Value ==0 && grafico.cremer.Value ==0 && grafico.iso.Value==0 && ...
         grafico.davy.Value ==0
 errordlg('Seleccione por lo menos un metodo para exportar el gráfico','Error al exportar')
 else
     
try 
    global largo_exp alto_exp espesor_exp name_exp
    
    figurita = figure('Units','Normalized','Position',[0 0 1 0.96],'Visible','off');
    graficos_axes.Parent = figurita ;
    posicion = graficos_axes.Position ;
    graficos_axes.Position=[0.1 0.2 0.8 0.7] ;
    titulo_exp = [ name_exp ' - Largo ' num2str(largo_exp) 'm; Alto ' num2str(alto_exp) 'm; Espesor ' num2str(espesor_exp) 'm']; 
    [a,b] = uiputfile({'*.jpg';'*.png';'*.fig'},'Seleccione el directorio para exportar el gráfico',titulo_exp) ; 
    loadingbar = waitbar(0,'...Exportando...');
     
    clear i
    
    for i=1:100
    waitbar(i/300)
    pause(0.005)
    end
    
    saveas(figurita,[b a]) ;

    for i=100:200
    waitbar(i/300)
    pause(0.005)
    end
    
    graficos_axes.Position = posicion ;
    graficos_axes.Parent = dspfigure ;
    
    for i=200:300
    waitbar(i/300)
    pause(0.005)
    end
    
    close(loadingbar)
helpdlg('Gráfico exportado correctamente','Exportar gráfico') ;
catch
    close(loadingbar)
      graficos_axes.Position = posicion ; 
    graficos_axes.Parent = dspfigure ;
errordlg('Ocurrió un problema y no se pudo exportar el gráfico correctamente', 'Error') ;
   
end
 end 
 end
 
 function exportar_tabla(~,~,info_popupmaterial,grafico)
 if grafico.sharp.Value ==0 && grafico.cremer.Value ==0 && grafico.iso.Value==0 && ...
         grafico.davy.Value ==0
 errordlg('Seleccione por lo menos un metodo para exportar el gráfico','Error al exportar')
 else
 
try
    
     
 global TLS largo_exp alto_exp espesor_exp name_exp
 
 A = {'Metodo \ f [Hz]',25,31.5,40,50,63,80,100,125,160,200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6000,8000,10000,12000,16000,20000};

 
 if grafico.sharp.Value == 1
    A = [A ; 'Sharp', num2cell(TLS(1,[1:end]))];
 end
 
 if grafico.cremer.Value == 1
    A = [A ; 'Cremer', num2cell(TLS(2,[1:end]))];
 end
 
 if grafico.iso.Value == 1
    A = [A ; 'ISO 1235', num2cell(TLS(3,[1:end]))];
 end
 
 if grafico.davy.Value == 1
    A = [A ; 'Davy', num2cell(TLS(4,[1:end]))];
 end
 
titulo_exp = [ name_exp ' - Largo ' num2str(largo_exp) 'm; Alto ' num2str(alto_exp) 'm; Espesor ' num2str(espesor_exp) 'm']; 
[b a] = uiputfile({'*.xls';'*.xlsx'},'Exportar tabla',titulo_exp);

 loadingbar = waitbar(0,'...Exportando...');
 for i=1:100
    waitbar(i/200)
    pause(0.005)
 end

xlswrite([a b],A);

 for i=100:200
    waitbar(i/200)
    pause(0.005)
 end
  close(loadingbar)

  helpdlg('Tabla exportada correctamente','') ;
 catch 
    errordlg('Ocurrió un problema y no se pudo exportar la tabla correctamente', 'Error') ;
    close(loadingbar)
end
 end
 end
 
%% Checkboxs 
 function checksharp(~,~,grafico)
 try
 global plot_sharp ;
 if grafico.sharp.Value == 1
     plot_sharp.Visible = 'on';
 else
     plot_sharp.Visible = 'off';
 end
 catch
 errordlg('Primero procese un material','Error');
 grafico.sharp.Value = 0;
 end
 end
 
 function checkcremer(~,~,grafico)
 try
 global plot_cremer ;
 if grafico.cremer.Value == 1
     plot_cremer.Visible = 'on';
 else
     plot_cremer.Visible = 'off';
 end
 catch
 errordlg('Primero procese un material','Error'); 
 grafico.cremer.Value = 0;
 end
 end
 
 function checkiso(~,~,grafico)
 try
 global plot_iso ;
 if grafico.iso.Value == 1
     plot_iso.Visible = 'on';
 else
     plot_iso.Visible = 'off';
 end
 catch
 errordlg('Primero procese un material','Error'); 
 grafico.iso.Value = 0;
 end
 end
 
  function checkdavy(~,~,grafico)
 try
  global plot_davy ;
 if grafico.davy.Value == 1
     plot_davy.Visible = 'on';
 else
     plot_davy.Visible = 'off';
 end
 catch
 errordlg('Primero procese un material','Error');
 grafico.davy.Value = 0;
 end
  end
 
 function closegui(~,~,dspfigure)

  helpdlg('Gracias por utilizar nuestro software','') ;  
 
 dspfigure.Visible = 'off' ;
 
 end
 
 function helpgui(~,~,dspfigure)
 text_help = importdata('Help.txt'); % Carga mensaje de inicio
 waitfor(helpdlg(text_help,'Ayuda'))
 end
 
 function txt = myupdatefcn(empt,event_obj)
% Customizes text of data tips

pos = get(event_obj,'Position');
txt = {['f [Hz] : ',num2str(pos(1))],...
	      ['TL [dB] : ',num2str(round(pos(2),1))]};
end