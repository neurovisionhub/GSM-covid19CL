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

regiones_in=[1,2,7]
for i=regiones_in
region = regiones{i}

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
numThetas=5;
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
%data_config
diaInicio = 600
diaFinEstudio = 900;
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
ventana_general=14;
%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories

variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
grafica_data=0

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
traza = 0;
format long
% En primera ola el beta más grande
% beta = 0.4; beta_lb_up_op = [1e-3,0.5];
% gamma = 0.01; gamma_lb_up_op = [1e-3,0.3];
% % alfaS=0.01;
% % deltaS=0.01;
% alfaS=0.00194; alfaS_lb_up_op = [1e-5,0.5];% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS=0.0011; deltaS_lb_up_op = [1e-5,0.5];% 0.0011/0.194
% a_test = 0.3; a_test_lb_up_op = [0.1,0.9];
% all_test_gammasR=0.0041; all_test_gammasR_lb_up_op = [1e-4,0.01];
% all_test_gammasU=0.00125;all_test_gammasU_lb_up_op = [1e-4,0.01];

% %all_blocks_params_model_analytics
% estado_op=true;

%%%%%% ------- %%%%%%%%%% 
tic
% all_blocks_params_model_analytics_hibridas
% p=p0
% compute_curves_error
% % 
% % rng default % For reproducibility
% % options = optimoptions('ga','PlotFcn',@gaplot1drange);
% % [x,fval] = ga(@ESIR_rel_all,1,[],[],[],[],[],[],[],options)
% 
% rng default % For reproducibility
% FitnessFunction = @vectorized_fitness;
% 
% lb = [beta_lb_up_op(1,1);gamma_lb_up_op(1,1);alfaS_lb_up_op(1,1);deltaS_lb_up_op(1,1);all_test_gammasR_lb_up_op(1,1);all_test_gammasU_lb_up_op(1,1);a_test_lb_up_op(1,1)]';
% ub = [beta_lb_up_op(1,2);gamma_lb_up_op(1,2);alfaS_lb_up_op(1,2);deltaS_lb_up_op(1,2);all_test_gammasR_lb_up_op(1,2);all_test_gammasU_lb_up_op(1,2);a_test_lb_up_op(1,2)]';
% 
% %type parameterized_fitness
% type vectorized_fitness
% 
% 
% p_op = [beta;gamma;alfaS;deltaS;all_test_gammasR;all_test_gammasU;a_test];

% numberOfVariables=size(p_op,1);
% % Pass fixed parameters to objfun
% objfun5 = @(p_op)vectorized_fitness(p_op,p,N,acumulada,test_data_covid,...
%     diaInicio,diaFinEstudio,numThetas);
% 
% % Set nondefault solver options
% options6 = optimoptions("ga","PlotFcn",["gaplotdistance","gaplotgenealogy",...
%     "gaplotselection","gaplotscorediversity","gaplotscores","gaplotstopping",...
%     "gaplotmaxconstr","gaplotbestf","gaplotbestindiv","gaplotexpectation",...
%     "gaplotrange","gaplotrange"]);
% options6.PopulationSize = 5;
% options6.MaxGenerations  = 150;
% %options6.MutationFcn ={@mutationgaussian,1,.5};
% % Solve
% [solution,objectiveValue] = ga(objfun5,numberOfVariables,[],[],[],[],lb,ub,[],...
%     [],options6);
% 
% % Clear variables
% clearvars objfun5 options6
%[x,fval] = ga(FitnessFunction,numberOfVariables,[],[],[],[],lb,ub)
toc
%simulations brute force
%while(estado_op)

tic
%% Solucion abuelo - pais - contiene a todas las demas

%% Solucion padre - RM por densidad - contiene a casi todas las demas. 2° año
solution_buena = [0.005292324185371,0.001197693705559,0.000621007213593,0.000284389982224,0.000348566269875,0.003403111946897,0.710175727827394];
%% tercer año ...
%solution_buena = [0.0796489277570966,0.115283860197751,0.210886423700311,0.375000000000000,0.0100000000000000,0.00398304749338827,0.177705424988678];

solution=solution_buena;

beta = solution(1,1);
gamma = solution(1,2);
% alfaS=0.01;
% deltaS=0.01;
alfaS=solution(1,3);% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS=solution(1,4);% 0.0011/0.194
all_test_gammasR=solution(1,5);
all_test_gammasU=solution(1,6);
a_test=solution(1,6);





all_blocks_params_model_analytics_hibridas
p=p0
compute_curves_error
compute_curves


% % buscar un beta inicial
% cota_beta
% beta = select_beta;
% disp(beta)
% % 
% % %pause
% all_blocks_params_model_analytics_hibridas
% p=p0;
% p_ini=p0;
% compute_curves_error
% compute_curves
% disp(cota_error)
% % fr
% % % buscar un gamma inicial
% gamma = 0.01
% cota_gamma
% gamma = select_gamma;
% disp(gamma)
% %gamma = 0.01
% all_blocks_params_model_analytics_hibridas
% 
% p=p0;

% compute_curves_error
% compute_curves
% %disp(cota_error)
disp(E)
disp(rmse_t);


% if condiciones_error
% 
% if (condicion==1)
%     estado_op=false
%    % break
% end
%end
% % 
    figure;plot(test_data_covid_estimate,'DisplayName','test_data_covid_estimate')
    hold on
    plot(test_data_covid,'DisplayName','test_data_covid')
    
    figure;plot(diff(test_data_covid_estimate(:,2:end)),'DisplayName','test_data_covid_estimate')
    hold on
    plot(diff(test_data_covid(:,1:3)),'DisplayName','test_data_covid')

E
% 
% 
tic
main_all_blocks_1
toc
save_log_data_ck_point


end



p=p0;
compute_curves_error
compute_curves
figure;plot(diff(test_data_covid_estimate(:,2)),'DisplayName','Ie')
hold on
plot(diff(test_data_covid(:,1)),'DisplayName','I')
plot(diff(test_data_covid_estimate(:,4)),'DisplayName','Ue')
% 
plot(diff(test_data_covid(:,3)),'DisplayName','U')
t_total=toc(global_time_op)
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

minutos_cf_data = time_config_data_toc/60
minutos_op_lsnonlineal=t_total/60

% Dado que totas las curvas de totales regionales (C_R) estan contenidas en la curva
% de totales nacionales (C_N), los parámetros P ajustados a C_N con técnicas
% de optimización se pueden utilizar como valores iniciales de la optimización con 
% datos regionales. Misma técnica se puede aplicar a nivel regional y 
% subregional (comuna para el caso de chile)  

% AProximadamente 