close all
%% Time_0 of the data proccessing
time_config_data_tic=tic

%% Paths of directories
addpath (genpath('calls/')) % on case of add new code
addpath (genpath('model/')) % baseline models and new models (some experiments)
addpath (genpath('dataCL/')) % input and proccessing covid-19
addpath (genpath('exps/')) % for save logs experiments
addpath (genpath('analytics/')) % main call analytics research paper
addpath (genpath('config/')) % examples for multiple config 
addpath (genpath('img_trace/')) %directory save images fit at iterations times
addpath (genpath('fig_review/')) % images for this paper research
%global  grafica_data nCiclos ventana_general %maxiters option_model grafica_ajustes primero
%global  globalPais globalUCImovil  cont  grafica_data nCiclos
%global h Mv 
global funEvals contF traza nGammas numThetas interpolacion 
nGammas=numThetas;
contF=1
funEvals = 40000; % max evals on the optimizer
%global_time_op=tic;
%option_model = 2
%grafica_data = 0; % 1 = graphics of data_config, 0 =  default
grafica_ajustes = 1; % 1 = graphics of smooth, 0 =  default

% smooth curve - phase 1 
interpolacion = 1; % for interpolation origin curve (0 original data with many abrupt changes), deafult = 1
% interpolacion = 1 <- It is interpolated and then the SIER test model is applied to a small subset of points, this is in the experimental phase. 
% for short experiment percentPrunning < 1
percentPrunning = 1 %  this is in the experimental phase, next version ->  1  > values > 0 is percentage of data 

% Optimizer trace 0 is default
traza = 0;
primero = 0; % first experiment = 0

% example 2
maxiters = 10;
% realizar primera aproximación factible, luego al usal el optimizadro no lineal aumentar su valor para conseguir mejor precisión
%nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
% %data_config

I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
%ventana_general=14;

%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
format shortg
variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
grafica_data=1
matrix_optimus=[];
matrix_optimus_poblacion=[];
matrix_optimus_scores=[];

%% call main of data proccessing
data_times_processing

%% Time_1 of the data proccessing
time_config_data_toc=toc(time_config_data_tic);

intervalo = I00:I10;
xd_studio = xd(intervalo,:);
xd_studio_diff = [diferenciasDiarias(xd_studio(:,1)')',...
    diferenciasDiarias(xd_studio(:,2)')',...
    diferenciasDiarias(xd_studio(:,3)')'];

coef_var_I = std2(xd_studio_diff(:,1))/mean(xd_studio_diff(:,1));
coef_var_R = std2(xd_studio_diff(:,2))/mean(xd_studio_diff(:,2));
coef_var_U = std2(xd_studio_diff(:,3))/mean(xd_studio_diff(:,3));
coef_var = [coef_var_I,coef_var_R,coef_var_U];
mean_coef_var = mean(coef_var);

maxThetas = 20;
minThetas = 5;

%% For trace
% figure
% plot(data_pais)
% figure
% plot(data_region)
% figure
% plot(xd)

diaInicio = I00
diaFinEstudio = I10;
nF=0;
% nF=84; %For case prediction use nf = time predicction before end day study
diaFin=diaFinEstudio-nF;


params_ini = [];
cota_error = 10000;
option_model = 3 
traza =0;
format shortg

%% Observacion para tesistas: el tiempo de infección promedio si se establece en por ejemplo 0.07, dara aprox 14 dias como masivamente se cree
% pero en el contexto matemática tenemos a 1/gamma y por otro lado a los
% taus que buscan el periodo de tiempo, se producen multiples minimos
% locales debido a que ambas variables buscan de manera implicita el tiempo
% (a traves de la tasa gamma) y de manera explicita misma caracteristica (a traves de tau)

%% Observation for thesis students: the average infection time, if set to, for example, 0.07, will give approximately 14 days, as is widely believed
%, but in the mathematical context, we have 1/gamma, and on the other hand the
% taus looking for the time period, multiple minima occur
% local because both variables implicitly lookup time
% (via gamma rate) and explicitly the same feature (via tau)


a_t = 10e-5;
b_t = 0.9;
 
beta_lb_up_op = [a_t,0.9]; % Average transmission rate
gamma_lb_up_op = [a_t,b_t]; % mean rate of the remotion 
alfaS_lb_up_op = [a_t,b_t];% the smaller, the less variation in the maximum distances of curves.
deltaS_lb_up_op = [a_t,b_t];
all_test_gammasR_lb_up_op = [a_t,b_t];
all_test_gammasU_lb_up_op = [a_t,b_t];
a_test_lb_up_op = [0.01,b_t];

d_t = diaFin - diaInicio;

%% Important 1: here define factor of initial values (critical values on models); 
%% this is experimental for each covid 19 data set
%% Important 2: if after 20 iters and no convergence, modification of one grade of the magnitude of the +- factor_inicial and repeat the experiment

%factor_inicial =0.00025; % Magallanes
factor_inicial =0.0001; % Metropolitan

beta = max(beta_lb_up_op)*factor_inicial; %rate of the contact/transmition 
gamma = max(gamma_lb_up_op)*factor_inicial;% (1/gamma) mean time infection - mean rate of the remotion 
alfaS=max(alfaS_lb_up_op)*factor_inicial; 
deltaS=max(deltaS_lb_up_op)*factor_inicial; 
all_test_gammasR=max(all_test_gammasR_lb_up_op)*factor_inicial;
all_test_gammasU=max(all_test_gammasU_lb_up_op)*factor_inicial;
a_test = max(a_test_lb_up_op);%; 


%% This routine builds the vector of initial values (p0) of the model 
all_blocks_params_model_analytics_hibridas
p=p0

%% Errores usando valores iniciales
compute_curves

tic
main_all_blocks_1
toc

%% Errores usando valores optimizados

compute_curves
format shortg

%% Optimized parameters values

a_salida = p0(1);
k_salida = p0(2);
aC_salida = p0(3);
tau1_salida = p0(4);
tau2_salida = p0(5);
tau3_salida = p0(6);
tau4_salida = p0(7);
tau5_salida = p0(8);
tau6_salida = p0(9);

taus_results = [tau1_salida;tau2_salida;...
    tau3_salida;tau4_salida;tau5_salida;...
    tau6_salida;];
params_exp = [a_salida;k_salida;aC_salida;];

posIni = 4; 

%% Vectors of Optimized params values
all_gammas_salida  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_alfaS_salida    = p(posIni+nTau+nGammas:posIni+nTau+nGammas*2-1);
all_deltaS_salida   = p(posIni+nTau+nGammas*2:posIni+nTau+nGammas*3-1);
all_gammasU_salida  = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
all_betas_salida    = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammasR_salida  = p(posIni+nTau+nGammas*5:posIni+nTau+nGammas*6-1);


%% Estimation non-formal of the epidemiological params - the sum of the rates
suma_beta = sum(all_betas_salida);
suma_gamma = sum(all_gammas_salida);
suma_alfaS = sum(all_alfaS_salida);
suma_deltaS = sum(all_deltaS_salida);
suma_gammasU = sum(all_gammasU_salida);
suma_gammasR = sum(all_gammasR_salida);

params_results = [suma_beta;suma_gamma;...
    suma_alfaS;suma_deltaS;suma_gammasU;...
    suma_gammasR;]

%% Basic estimation of Ro (non-formal) (for reference and research)

ro_basico = suma_beta/suma_gamma;
ro_distribucion_bloque = all_betas_salida./all_gammas_salida;
ro_basico_st = (suma_beta/suma_gamma)/nGammas;
results_ro = [ro_basico;ro_basico_st];

%% Study interval
distancia_t = diaFinEstudio - diaInicio; % interval size
meses = distancia_t/30; % months of the study
dim_tramo = meses/nGammas; % block dimension