
clear

%% vars global for test 
global globalPais grafica_data ventana_general globalUCImovil flagpause numThetas

% grafica_data = 1 for generated graphics on analisys
grafica_data=0; 
flagpause=0; % for pause on visualization

% globalPais = 1 using data national; 
% globalPais = 0 using data regional; 
globalPais =0; 

% globalUCImovil = 1 <- using  admission daily national; 
% globalUCImovil = 0 <- using  hospitalization and ICU stay; 
globalUCImovil = 0; 

% Research block analysis
diaInicio = 250 % init day
diaFinEstudio = 900 % finish day

%% Params of control/performance
primera_ola =0; % for localized research on first wave, default = 0
toda_la_ola = 0; % for future test, default = 0
opcion_a1 = 0; % for first optimization, default = 0
cargar_checkpoint = 0; % 1-> for case load checkpoint, default = 0
media_inicio_fin=0 % 1 for use media global, default 0

% days after the first wave  
if diaInicio > 200
media_inicio_fin = 0
end

distancia_t = diaFinEstudio - diaInicio;
%numThetas=ceil(distancia_t/30); % For automatic estimate number blocks

numThetas = 20 % is recommended for all tests

% (ventana_general) --> As the interest is the trend of the curves, and there is a data lag between 3 to 5 days,
% at intervals of several months or a year, we increase the size of the mobile windows to a month
% in this way, we smooth the curves and minimize the abrupt jumps in the data.
% In addition, to avoid long approximation cycles in the sign changes of the derivatives, we have of the use of accumulated curves, where use larger moving window .... when there are abrupt changes in the curve
%% Important: If is used one day (ventana_general = 1), original data from the data set is used

ventana_general=14; % windows mobile size (on days), 14 days is default

matrix_results = [];
regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
%global_time_op=tic;

% other example
% region = 'Magallanes'
region = 'Metropolitana'

% On case of the automatics design execution program 
size_regiones = size(regiones,2)
Region = cell(size_regiones,1);
total_days = [];
matrix_resultados = [];

%% See relevant params for execution program
% acumulada = 1 is cumulative data smooth and cumulative proccesing curves, util for the detection of anomalies on data and large datasets, and fast proccessing;
% acumulada = 2 is cumulative data smooth and dialy proccesing curves, util for an exhaustive approach and definitive result; 
acumulada = 1;  

maxGlobal =0;%  For test with max of the all data, default = 0 
meanGlobal =0; % For test with mean of the all data, default = 0
mediana = 0; % For extra test, default = 0

%% Call main test of the publication research 
test_paper_build_tables

%% Build results tables
createTablas





