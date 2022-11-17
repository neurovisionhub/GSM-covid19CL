clear
time_config_data_tic=tic
%addpath (genpath('/'))
addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))
addpath (genpath('config/'))
addpath (genpath('img_trace/'))
global numThetas grafica_data nCiclos ventana_general%maxiters option_model grafica_ajustes primero
global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data nCiclos
global h Mv funEvals contF
contF=1
funEvals = 40000;
Mv = struct('cdata', [], 'colormap', []);  %predeclare struct array
regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
global_time_op=tic;
region = 'Metropolitana'
close all
% % % % % cont=0;
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
acumulada =2;


% TRAZA OPTIMIZER
traza = 0;
primero = 0
%primero = 0
% example 2
maxiters = 10;
numThetas=  10;   %% Para AG usar un valor bajo para 
% realizar primera aproximación factible, luego al usal el optimizadro no lineal aumentar su valor para conseguir mejor precisión
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
% %data_config
diaInicio = 600
diaFinEstudio = 900;
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
ventana_general=14;
%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
format shortg
variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
grafica_data=0
matrix_optimus=[];
matrix_optimus_poblacion=[];
matrix_optimus_scores=[];

data_times_processing
time_config_data_toc=toc(time_config_data_tic);

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
traza =0;
format shortg
%% Obs: el tiempo de infección promedio si se establece en por ejemplo 0.07, dara aprox 14 dias como masivamente se cree
% pero en el contexto matemática tenemos a 1/gamma y por otro lado a los
% taus que buscan el periodo de tiempo, se producen multiples minimos
% locales debido a que ambas variables buscan de manera implicita el tiempo
% (a traves de la tasa gamma) y de manera explicita misma caracteristica (a traves de tau)

a_t = 10e-5;
b_t = 0.6;
 
%En primera ola el beta más grande
beta_lb_up_op = [1e-1,0.3]; % Mayoria de valores cercanos a 0.2
gamma_lb_up_op = [1e-4,1e-1]; % % (1/gamma) tiempo de infección promedio - tasa de remosión media
alfaS_lb_up_op = [1e-4,1e-2];%%(SR) gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS_lb_up_op = [1e-4,1e-2];% %(RS) 0.0011/0.194
all_test_gammasR_lb_up_op = [1e-4,1e-2]; %Recuperado UCI
all_test_gammasU_lb_up_op = [1e-4,1e-2]; %ingreso UCI
a_test_lb_up_op = [0.01,0.9];

beta = 0.2;
gamma = 0.01;
% alfaS=0.01;
% deltaS=0.01;
alfaS=0.00194;% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS=0.00194;% 0.0011/0.194
all_test_gammasR=0.001;%solution(1,5);
all_test_gammasU=0.001;%solution(1,6);
a_test=0.5;
% % Por ahora este esquema con poblacion pequeña dificulta la busqueda, se
% deben dar mayor numero depoblacion y nube de puntos inicial
% si se utiliza esta opcion se debe aumentar la poblacion inicial - recuros
% de cpu y utilizar el 100% de threads de la computadora.

% beta_lb_up_op = [0.01,b_t]; % Mayoria de valores cercanos a 0.2
% gamma_lb_up_op = [a_t,b_t];
% alfaS_lb_up_op = [a_t,b_t];% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS_lb_up_op = [a_t,b_t];% 0.0011/0.194
% all_test_gammasR_lb_up_op = [a_t,b_t];
% all_test_gammasU_lb_up_op = [a_t,b_t];
% a_test_lb_up_op = [0.01,0.9];

d_t = diaFin - diaInicio;
tau_4_op_lb_lb =[1,140]; % obs: los taus estimados < periodo (dias de la data)

%% Para acelerar proceso partir de valores bajos
%% factor 
% factor_inicial=1
% beta = mean(beta_lb_up_op)*factor_inicial; %tasa de contato (fabrizzio en algunas partes indica contacto en otra transmision) -- tasa de transmisión! .
% gamma = mean(gamma_lb_up_op)*factor_inicial;% % (1/gamma) tiempo de infección promedio - tasa de remosión media
% alfaS=mean(alfaS_lb_up_op)*factor_inicial;%0.00194; 
% deltaS=mean(deltaS_lb_up_op)*factor_inicial;%0.0011; 
% all_test_gammasR=mean(all_test_gammasR_lb_up_op)*factor_inicial;%0.0041;
% all_test_gammasU=mean(all_test_gammasU_lb_up_op)*factor_inicial;%0.00125;
% a_test = mean(a_test_lb_up_op);%0.3; 
% tau_4_op = mean(tau_4_op_lb_lb);
% 


factor_inicial=0.005
beta = mean(beta_lb_up_op)*factor_inicial; %tasa de contato (fabrizzio en algunas partes indica contacto en otra transmision) -- tasa de transmisión! .
gamma = mean(gamma_lb_up_op)*factor_inicial;% % (1/gamma) tiempo de infección promedio - tasa de remosión media
alfaS=mean(alfaS_lb_up_op)*factor_inicial;%0.00194; 
deltaS=mean(deltaS_lb_up_op)*factor_inicial;%0.0011; 
all_test_gammasR=mean(all_test_gammasR_lb_up_op)*factor_inicial;%0.0041;
all_test_gammasU=mean(all_test_gammasU_lb_up_op)*factor_inicial;%0.00125;
a_test = mean(a_test_lb_up_op);%0.3; 
tau_4_op = mean(tau_4_op_lb_lb);

tau_4_op=1
% 
% solution = [0.005292324185371,0.001197693705559,0.000621007213593,0.000284389982224,0.000348566269875,0.003403111946897,0.710175727827394];
% 
% beta = solution(1,1);
% gamma = solution(1,2);
% % alfaS=0.01;
% % deltaS=0.01;
% alfaS=solution(1,3);% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS=solution(1,4);% 0.0011/0.194
% all_test_gammasR=solution(1,5);
% all_test_gammasU=solution(1,6);
% a_test=solution(1,7);

%% id NAN 3.467500000000000e+02 -- 371

% %all_blocks_params_model_analytics
% estado_op=true;

%%%%%% ------- %%%%%%%%%% 
tic
all_blocks_params_model_analytics_hibridas
p=p0
%return
compute_curves_error
compute_curves
main_all_blocks_1

