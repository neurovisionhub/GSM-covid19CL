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
region = 'Ñuble'
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
acumulada =1;


% TRAZA OPTIMIZER
traza = 0;
primero = 0
%primero = 0
% example 2
maxiters = 10;
numThetas=  20;   %% Para AG usar un valor bajo para 
% realizar primera aproximación factible, luego al usal el optimizadro no lineal aumentar su valor para conseguir mejor precisión
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
% %data_config
diaInicio = 270
diaFinEstudio = 590
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
% Opcion 1: En caso de observar que dd23 avanza lentamente usanon cambios abruptos en la curva
% aumentar el tamaño de la ventana en escala de semanas ej: 4 a 8 semanas
% (28 a 56 dias)
ventana_general=31;
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
option_model = 2 %% ACA HABIA UN 3

traza =0;
format shortg
%% Obs: el tiempo de infección promedio si se establece en por ejemplo 0.07, dara aprox 14 dias como masivamente se cree
% pero en el contexto matemática tenemos a 1/gamma y por otro lado a los
% taus que buscan el periodo de tiempo, se producen multiples minimos
% locales debido a que ambas variables buscan de manera implicita el tiempo
% (a traves de la tasa gamma) y de manera explicita misma caracteristica (a traves de tau)

a_t = 10e-5;
b_t = 0.9;
 
beta_lb_up_op = [1e-1,0.6]; % Mayoria de valores cercanos a 0.2
gamma_lb_up_op = [1e-6,9e-1]; % % (1/gamma) tiempo de infección promedio (hay que ajustar porque gamma es bajo) - tasa de remosión media
alfaS_lb_up_op = [1e-6,9e-1];%%(SR) gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS_lb_up_op = [1e-6,9e-1];% %(RS) 0.0011/0.194
all_test_gammasR_lb_up_op = [1e-6,9e-1]; %Recuperado UCI
all_test_gammasU_lb_up_op = [1e-6,9e-1]; %ingreso UCI
a_test_lb_up_op = [0.01,0.9];

% 
% 
% %En primera ola el beta más grande
% beta_lb_up_op = [1e-2,0.9]; % Mayoria de valores cercanos a 0.2
% gamma_lb_up_op = [1e-5,1e-1]; % % (1/gamma) tiempo de infección promedio - tasa de remosión media
% alfaS_lb_up_op = [1e-5,1e-1];%%(SR) gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS_lb_up_op = [1e-5,1e-1];% %(RS) 0.0011/0.194
% all_test_gammasR_lb_up_op = [1e-5,1e-1]; %Recuperado UCI
% all_test_gammasU_lb_up_op = [1e-5,1e-1]; %ingreso UCI
% a_test_lb_up_op = [0.01,0.9];
% beta = 0.2;
% gamma = 0.01;
% % alfaS=0.01;
% % deltaS=0.01;
% alfaS=0.00194;% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS=0.00194;% 0.0011/0.194
% all_test_gammasR=0.001;%solution(1,5);
% all_test_gammasU=0.001;%solution(1,6);
% a_test=0.5;
% % Por ahora este esquema con poblacion pequeña dificulta la busqueda, se
% deben dar mayor numero depoblacion y nube de puntos inicial
% si se utiliza esta opcion se debe aumentar la poblacion inicial - recuros
% de cpu y utilizar el 100% de threads de la computadora.
% 
beta_lb_up_op = [a_t,b_t]; % Mayoria de valores cercanos a 0.2
gamma_lb_up_op = [a_t,b_t];
alfaS_lb_up_op = [a_t,b_t];% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS_lb_up_op = [a_t,b_t];% 0.0011/0.194
all_test_gammasR_lb_up_op = [a_t,b_t];
all_test_gammasU_lb_up_op = [a_t,b_t];
a_test_lb_up_op = [0.01,0.9];

% beta_lb_up_op = [1e-1,0.6]; % Mayoria de valores cercanos a 0.2
% gamma_lb_up_op = [1e-5,1e-1]; % % (1/gamma) tiempo de infección promedio (hay que ajustar porque gamma es bajo) - tasa de remosión media
% alfaS_lb_up_op = [1e-5,1e-1];%%(SR) gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS_lb_up_op = [1e-4,1e-1];% %(RS) 0.0011/0.194
% all_test_gammasR_lb_up_op = [1e-4,1e-1]; %Recuperado UCI
% all_test_gammasU_lb_up_op = [1e-4,1e-1]; %ingreso UCI
% a_test_lb_up_op = [0.01,0.9];

d_t = diaFin - diaInicio;
tau_4_op_lb_lb =[1,160]; % obs: los taus estimados < periodo (dias de la data)

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


factor_inicial=0.0001
beta = max(beta_lb_up_op)*factor_inicial; %tasa de contato (fabrizzio en algunas partes indica contacto en otra transmision) -- tasa de transmisión! .
gamma = max(gamma_lb_up_op)*factor_inicial;% % (1/gamma) tiempo de infección promedio - tasa de remosión media
alfaS=max(alfaS_lb_up_op)*factor_inicial;%0.00194; 
deltaS=max(deltaS_lb_up_op)*factor_inicial;%0.0011; 
all_test_gammasR=max(all_test_gammasR_lb_up_op)*factor_inicial;%0.0041;
all_test_gammasU=max(all_test_gammasU_lb_up_op)*factor_inicial;%0.00125;
a_test = max(a_test_lb_up_op);%0.3; 
tau_4_op = max(tau_4_op_lb_lb);
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


disp('Continue test ini 0')
%pause


% 
 rng default % For reproducibility
% options = optimoptions('ga','PlotFcn',@gaplot1drange);
% [x,fval] = ga(@ESIR_rel_all,1,[],[],[],[],[],[],[],options)

%rng default % For reproducibility
FitnessFunction = @vectorized_fitness

lb = [beta_lb_up_op(1,1);gamma_lb_up_op(1,1);alfaS_lb_up_op(1,1);deltaS_lb_up_op(1,1);all_test_gammasR_lb_up_op(1,1);all_test_gammasU_lb_up_op(1,1);a_test_lb_up_op(1,1)]'; % sin optimizar tau4
ub = [beta_lb_up_op(1,2);gamma_lb_up_op(1,2);alfaS_lb_up_op(1,2);deltaS_lb_up_op(1,2);all_test_gammasR_lb_up_op(1,2);all_test_gammasU_lb_up_op(1,2);a_test_lb_up_op(1,2)]';
%lb = [beta_lb_up_op(1,1);gamma_lb_up_op(1,1);alfaS_lb_up_op(1,1);deltaS_lb_up_op(1,1);all_test_gammasR_lb_up_op(1,1);all_test_gammasU_lb_up_op(1,1);a_test_lb_up_op(1,1);tau_4_op_lb_lb(1,1)]';
%ub = [beta_lb_up_op(1,2);gamma_lb_up_op(1,2);alfaS_lb_up_op(1,2);deltaS_lb_up_op(1,2);all_test_gammasR_lb_up_op(1,2);all_test_gammasU_lb_up_op(1,2);a_test_lb_up_op(1,2);tau_4_op_lb_lb(1,2)]';

%type parameterized_fitness
%type vectorized_fitness
ConstraintFunction = @simple_constraint;
%p_op = solution'
p_op = [beta;gamma;alfaS;deltaS;all_test_gammasR;all_test_gammasU;a_test]; % sin tau 4

%p_op = [beta;gamma;alfaS;deltaS;all_test_gammasR;all_test_gammasU;a_test;tau_4_op];
%P=p0
numberOfVariables=size(p_op,1);
% Pass fixed parameters to objfun
objfun5 = @(p_op)vectorized_fitness(p_op,p,N,acumulada,test_data_covid,...
    diaInicio,diaFinEstudio,numThetas,mean_data_ini,v_ini);

%Para acelerar los computos usamos computación paralela, utilizando 10
%procesadores


%% Usamos @gacreationnonlinearfeasible,'UseParallel',true,'NumStartPts',200
%% para generar de manera aleatoria 200 puntos iniciales sobre el espacio factible
%% 

%% Utilizamos el toolbox de computacion paralela con las opciones parpool("Processes",20)
% Set nondefault solver options
delete(gcp('nocreate'))
parpool("Processes",16)
%parpool('local', 10);

% availableGPUs = gpuDeviceCount("available")
% parpool('Processes',availableGPUs);
% options6 = optimoptions("ga",'UseParallel', true,'UseVectorized', false);%,"PlotFcn",["gaplotdistance","gaplotgenealogy",...
%    "gaplotselection","gaplotscorediversity","gaplotscores","gaplotstopping",...
%    "gaplotmaxconstr","gaplotbestf","gaplotbestindiv","gaplotexpectation",...
%    "gaplotrange","gaplotrange"]); %,'MutationFcn',{@mutationgaussian,1,.5}
% 

%% prueba hjeuristica 0.728717616119050	0.687983602376209	0.591166653779399	0.734174336268369	0.149860939642366	0.0926411244920624	0.760755650514368
%'CreationFcn',{ @gacreationnonlinearfeasible,'UseParallel',true,'NumStartPts',20}
options6 = optimoptions("ga",'UseParallel', true,'UseVectorized', false, 'CreationFcn',{ @gacreationnonlinearfeasible,'UseParallel',true,'NumStartPts',80},...
    "PlotFcn",["gaplotdistance","gaplotgenealogy",...
    "gaplotselection","gaplotscorediversity","gaplotscores","gaplotstopping",...
    "gaplotmaxconstr","gaplotbestf","gaplotbestindiv","gaplotexpectation",...
    "gaplotrange","gaplotrange"]);%,'MutationFcn',{@mutationuniform, 0.1}); %

options6.PopulationSize = 40;
options6.MaxGenerations  = 150;
%options6.MutationFcn ={@mutationgaussian,1,.5};
% Solve
% [solution,objectiveValue] = ga(objfun5,numberOfVariables,[],[],[],[],lb,ub,ConstraintFunction,...
%     [],options6);

[solution,objectiveValue,exitflag,output,population,scores]=ga(objfun5,numberOfVariables,[],[],[],[],lb,ub,[],...
    [],options6);

matrix_optimus=[matrix_optimus;solution];
matrix_optimus_poblacion=[matrix_optimus_poblacion;population];
matrix_optimus_scores=[matrix_optimus_scores;scores];
% Clear variables
clearvars objfun5 options6
toc
%simulations brute force
%while(estado_op)

tic
%% Solucion abuelo - pais - contiene a todas las demas
%% Solucion padre - RM por densidad - contiene a casi todas las demas.
%solution_buena = [0.005292324185371,0.001197693705559,0.000621007213593,0.000284389982224,0.000348566269875,0.003403111946897,0.710175727827394];

%% para experimento largo
%solution_buena = [0.0796489277570966,0.115283860197751,0.210886423700311,0.375000000000000,0.0100000000000000,0.00398304749338827,0.177705424988678]
%solution_buena = [ 0.395200932025909	,0.236059570312500,0.0792665315628052,0.129762060952011,	0.0512080062719018,	0.187050665175685,	0.102894449830055]
%solution=solution_buena;
beta = solution(1,1);
gamma = solution(1,2);
% alfaS=0.01;
% deltaS=0.01;
alfaS=solution(1,3);% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS=solution(1,4);% 0.0011/0.194
all_test_gammasR=solution(1,5);
all_test_gammasU=solution(1,6);
a_test=solution(1,7);

% tau_4_op=100% temporal solution(1,8)log()
% beta = 0.2;
% gamma = 0.01;
% % alfaS=0.01;
% % deltaS=0.01;
% alfaS=0.00194;% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
% deltaS=0.00194;% 0.0011/0.194
% all_test_gammasR=0.001;%solution(1,5);
% all_test_gammasU=0.001;%solution(1,6);
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
disp(tau_4_op);
% if condiciones_error
% 
% if (condicion==1)
%     estado_op=false
%    % break
% end
%end
% % 
x_t_chip_end = 0; 
    figure;plot(test_data_covid_estimate,'DisplayName','test_data_covid_estimate')
    hold on
    plot(test_data_covid,'DisplayName','test_data_covid')
    
    figure;plot(diff(test_data_covid_estimate(1:end-x_t_chip_end,2:end)),'DisplayName','test_data_covid_estimate')
    hold on
    plot(diff(test_data_covid(:,1:3)),'DisplayName','test_data_covid')

E
% 
% 
 tic
%  z
disp('Continue test')
pause
cicles_op_nsnl = 3
for f_1=1:cicles_op_nsnl
main_all_blocks_1 
p=p0;
end
 toc
% % save_log_data_ck_point
t_total=toc(global_time_op)
format shortg


compute_curves_error
compute_curves
figure;plot(test_data_covid_estimate(:,2),'DisplayName','Ie')
hold on
plot(test_data_covid(:,1),'DisplayName','I')
plot(test_data_covid_estimate(:,4),'DisplayName','Ue')
% 
plot(test_data_covid(:,3),'DisplayName','U')

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

save matrix_optimus;
save matrix_optimus_poblacion;
save matrix_optimus_scores;

% Dado que totas las curvas de totales regionales (C_R) estan contenidas en la curva
% de totales nacionales (C_N), los parámetros P ajustados a C_N con técnicas
% de optimización se pueden utilizar como valores iniciales de la optimización con 
% datos regionales. Misma técnica se puede aplicar a nivel regional y 
% subregional (comuna para el caso de chile)  

% AProximadamente 