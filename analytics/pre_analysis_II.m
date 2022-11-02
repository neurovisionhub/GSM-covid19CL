addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))

addpath (genpath('config/'))
global numThetas grafica_data nCiclos%maxiters option_model grafica_ajustes primero
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
primero = 0
% example 2
maxiters = 100;
numThetas=20;
nCiclos = 3% veces que se reduce beta a la mitad
primera_ola=0
%data_config
diaInicio = 50
diaFinEstudio = 360;
nF=0;
diaFin=diaFinEstudio-nF;

%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
data_times_processing


% INTERVALO DE ESTUDIO
ventana_general=14;
diaInicio = 20
diaFinEstudio = 360;
nF=0;
% diaInicio = 280;
%diaFinEstudio = 835;
% nF=84;
diaFin=diaFinEstudio-nF;
%aj = 1/diaFinEstudio;


%% ----------------------
model_solver_config
main_all_blocks_1

%% ----------------------
save_log_data




