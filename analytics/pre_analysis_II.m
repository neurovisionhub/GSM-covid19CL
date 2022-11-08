clear
addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))
addpath (genpath('img_trace/'))
addpath (genpath('config/'))
global numThetas grafica_data nCiclos ventana_general%maxiters option_model grafica_ajustes primero
global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data nCiclos

global h Mv funEvals contF
contF=1
funEvals = 20000;
Mv = struct('cdata', [], 'colormap', []);  %predeclare struct array
regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
region = 'Metropolitana'
close all
cont=0;
option_model = 2
grafica_data = 0; % graphics of data_config
grafica_ajustes = 0; % graphics of ajs
%%  Para experimentos ad-hoc / vacunas / comunales / simulación
% config
%% Graficas muestren los ejes correctamente 
%% Datos del ajuste
%% Datos de la predicción
% globalPais = 1 <- chile (suma de datos regionales & desconocido, si es null se asigna 0) 
globalPais = 0;
% globalUCImovil = 1 <- ingreso movil nacional chileno 
globalUCImovil = 0; % si se utiliza ingreso movil se ajusta mejor el final de la curva desde el inicio de optimizacion 
% AJUSTE DE CURVAS
interpolacion = 1;
% interpolacion = 1 <- se interpola y luego se aplica modelo SIER de test sobre un subconjunto pequeño de puntos esto para en fase dde experimentación, 
% for short experiment percentPrunning < 1
percentPrunning = 1 %   1 > values > 0 is percentage of data 
% Aproximacion sobre curva acumulada
acumulada =0;
% TRAZA OPTIMIZER
traza = 0;
primero = 0
%primero = 0
% example 2
maxiters = 3;
numThetas=10;
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
%data_config
diaInicio = 240
diaFinEstudio = 580;
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
ventana_general=60;

%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
data_times_processing


% INTERVALO DE ESTUDIO 

diaInicio = I00
diaFinEstudio = I10;
nF=0;
% diaInicio = 280;
%diaFinEstudio = 835;
% nF=84;
diaFin=diaFinEstudio-nF;
%aj = 1/diaFinEstudio;


%% ------ejemplo 1 ----------------
%option_model = 2
%model_solver_config
%main_all_blocks_1


%% ----- ejemplo 2 -------
option_model = 3 
traza = 0;
format long
beta = 0.3
gamma = 0.01
%all_blocks_params_model_analytics

%p=p0

delta_beta = 0.001
value_beta = [];
errores = [];
select_beta = 10000;
cota_error = 10000;
for i=1:1000
    i
    all_blocks_params_model_analytics    
    p=p0;
    compute_curves_error
    if isnan(E)
    E=9999999999
        break
    end
    errores = [errores,E];
    if E < cota_error && E > 0
       cota_error = E;
       select_beta = beta;
    end
    value_beta = [value_beta,beta];
    if beta <= delta_beta
        break
    end
    E
    beta = beta - delta_beta;
end

errores
cota_error
beta = select_beta;
all_blocks_params_model_analytics
p=p0;

compute_curves_error
compute_curves

gamma = 0.08
delta_gamma = 0.00025
value_gamma = [];
errores_gamma = [];
select_gamma = 10000;
cota_error = 10000;
for i=1:1000
    i
all_blocks_params_model_analytics_I    
p=p0;
compute_curves_error
 if isnan(E)
     E=9999999999
     break
 end
errores_gamma = [errores_gamma,E];
if E < cota_error && E > 0
   cota_error = E;
   select_gamma= gamma;
end
value_gamma = [value_gamma,gamma];
if gamma <= delta_gamma
break
end
E
gamma = gamma - delta_gamma;
end
gamma = select_gamma;
all_blocks_params_model_analytics
p=p0;

compute_curves_error
compute_curves

%main_all_blocks_1
% 
%

%% ----------------------
%save_log_data




