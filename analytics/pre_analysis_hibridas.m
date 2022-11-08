clear
%addpath (genpath('/'))
addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))

addpath (genpath('config/'))
global numThetas grafica_data nCiclos ventana_general%maxiters option_model grafica_ajustes primero
global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data nCiclos

global h Mv funEvals contF
contF=1
funEvals = 40000;
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
percentPrunning = 1 %  esta versión falla con el 1  > values > 0 is percentage of data 
% Aproximacion sobre curva acumulada
acumulada =1;
% TRAZA OPTIMIZER
traza = 0;
primero = 0
%primero = 0
% example 2
maxiters = 10;
numThetas=10;
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
%data_config
diaInicio = 300
diaFinEstudio = 600;
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
ventana_general=21;
%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories

variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
grafica_data=0
data_times_processing

% figure
% plot(data_pais)
% figure
% plot(data_region)
% figure
% plot(xd)


% INTERVALO DE ESTUDIO 

diaInicio = I00
diaFinEstudio = I10;
nF=0;
% diaInicio = 280;
%diaFinEstudio = 835;
% nF=84;
diaFin=diaFinEstudio-nF;
%aj = 1/diaFinEstudio;

%% beta, gamma, alfaS,deltaS

params_ini = [];
%% ------ejemplo 1 ----------------
%option_model = 2
%model_solver_config
%main_all_blocks_1


%% ----- ejemplo 2 -------
cota_error = 10000;
option_model = 3 
traza = 0;
format long
% En primera ola el beta más grande
beta = 0.23
gamma = 0.51
% alfaS=0.01;
% deltaS=0.01;
alfaS=0.0194; % gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS=0.0011; % 0.0011/0.194
%all_blocks_params_model_analytics
all_blocks_params_model_analytics_hibridas
p=p0

% buscar un beta inicial
cota_beta
beta = select_beta;
disp(beta)
% 
% %pause
all_blocks_params_model_analytics_hibridas
p=p0;
p_ini=p0;
compute_curves_error
compute_curves
disp(cota_error)
% fr
% % buscar un gamma inicial
gamma = 0.01
cota_gamma
gamma = select_gamma;
disp(gamma)
%gamma = 0.01


all_blocks_params_model_analytics_hibridas

p=p0;
compute_curves_error
compute_curves
disp(cota_error)
% 
figure;plot(test_data_covid_estimate,'DisplayName','test_data_covid_estimate')
hold on
plot(test_data_covid,'DisplayName','test_data_covid')

figure;plot(diff(test_data_covid_estimate(:,2:end)),'DisplayName','test_data_covid_estimate')
hold on
plot(diff(test_data_covid(:,1:3)),'DisplayName','test_data_covid')

E
% 
% 
% main_all_blocks_1
% p=p0;
% compute_curves_error
% compute_curves
% figure;plot(diff(test_data_covid_estimate(:,2)),'DisplayName','Ie')
% hold on
% plot(diff(test_data_covid(:,1)),'DisplayName','I')
% plot(diff(test_data_covid_estimate(:,4)),'DisplayName','Ue')
% % 
% plot(diff(test_data_covid(:,3)),'DisplayName','U')

%p_ini
%p0

% 
%

%% ----------------------
%save_log_data

%% El UCI hospitalizado (permanencia pacientes) acumulado es un indicardor
% preciso de carga hospitalaria. La cual entrega la carga diaria (pacientes
% totales atendidos dicho dia), la suma acumulada en un periodo por tanto
% expresa el numero de pacientes totales en estado de asistencia critica en un
% periodo de tiempo. Además, existe una alta correlación entre el número de
% fallecidos y el número de pacientes en UCI, en que los peaks de
% fallecidos sigue la misma tendencia que la saturación y/o aumento en estados UCI.


