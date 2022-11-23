%clear
time_config_data_tic=tic
%addpath (genpath('/'))
addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))
addpath (genpath('config/'))
addpath (genpath('img_trace/'))
addpath (genpath('fig_review/'))
global numThetas grafica_data nCiclos ventana_general%maxiters option_model grafica_ajustes primero
global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data nCiclos
global h Mv funEvals contF
contF=1
funEvals = 40000;
Mv = struct('cdata', [], 'colormap', []);  %predeclare struct array
%regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
global_time_op=tic;
%region = 'Arica y Parinacota'
close all
% % % % % cont=0;
option_model = 2
%grafica_data = 0; % graphics of data_config
grafica_ajustes = 0; % graphics of ajs
%%  Para experimentos ad-hoc / vacunas / comunales / simulación
% config
%% Graficas muestren los ejes correctamente 
%% Datos del ajuste
%% Datos de la predicción
% globalPais = 1 <- chile (suma de datos regionales & desconocido, si es null se asigna 0) 
% globalPais = 0;
% % globalUCImovil = 1 <- ingreso movil nacional chileno 
% globalUCImovil = 0; % si se utiliza ingreso movil se ajusta mejor el final de la curva desde el inicio de optimizacion 
% AJUSTE DE CURVAS
interpolacion = 1;
% interpolacion = 1 <- se interpola y luego se aplica modelo SIER de test sobre un subconjunto pequeño de puntos esto para en fase dde experimentación, 
% for short experiment percentPrunning < 1
percentPrunning = 1 %  esta versión falla con el 1  > values > 0 is percentage of data 
% 1 Aproximacion sobre curva acumulada
%acumulada =1;

% 2 Aproximacion sobre diferencias diarias usando la data de curva acumulada
%acumulada =2;


% 0 Aproximacion del dato de origen 
%acumulada =1; % =1 y 20 veces más rapido La que mejor funciona en cualquier parte de la curva

% TRAZA OPTIMIZER
traza = 0;
primero = 0
%primero = 0
% example 2
maxiters = 10;
% realizar primera aproximación factible, luego al usal el optimizadro no lineal aumentar su valor para conseguir mejor precisión
nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
% %data_config
% diaInicio = 30
% diaFinEstudio = 760
I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
%ventana_general=14;
%% como el interes es la tendencia de las curvas y existe un desfase de datos entre 3 a 5 días,
%% en intervalos de varios meses o un año, nosotros aumentamos el tamaño de las ventanas moviles a un mes
% de esta manera suavisamos las curvas y minimizamos los saltos abruptos en
% los datos.
%% Además, para evitar ciclos largo de aproximación en los cambios de signo de las derivadas, disponemos
% del uso de curvas acumuladas, donde las
%%Ventana movil mayor .... cuando hay cambios abruptos en la curva

%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
format shortg
variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
%grafica_data=0
matrix_optimus=[];
matrix_optimus_poblacion=[];
matrix_optimus_scores=[];

data_times_processing
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

% if mean_coef_var >= 1
%    numThetas=  maxThetas; 
% else
%     numThetas = ceil(maxThetas*mean_coef_var)
% 
%     if numThetas < minThetas
%        numThetas = minThetas;
%     end
% 
% end

%numThetas = 20
  %% Para AG usar un valor bajo para 


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
b_t = 0.9;
 
% si se utiliza funcion acumulada multiplicar por factor pequeño!

% %En primera ola el beta más grande
beta_lb_up_op = [1e-1,0.9]; % Mayoria de valores cercanos a 0.2
gamma_lb_up_op = [1e-5,1e-1]; % % (1/gamma) tiempo de infección promedio (hay que ajustar porque gamma es bajo) - tasa de remosión media
alfaS_lb_up_op = [1e-5,1e-1];%%(SR) gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS_lb_up_op = [1e-4,1e-1];% %(RS) 0.0011/0.194
all_test_gammasR_lb_up_op = [1e-4,1e-1]; %Recuperado UCI
all_test_gammasU_lb_up_op = [1e-4,1e-1]; %ingreso UCI
a_test_lb_up_op = [0.01,0.9];

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

beta_lb_up_op = [a_t,0.9]; % Mayoria de valores cercanos a 0.2
gamma_lb_up_op = [a_t,b_t];
alfaS_lb_up_op = [a_t,b_t];% gran parte 0.00194 /0.194 funcionan - mientras más pequeño menos variación en las maximas distancias de curvas, atención suceptibles, ese dato define lo demas
deltaS_lb_up_op = [a_t,b_t];% 0.0011/0.194
all_test_gammasR_lb_up_op = [a_t,b_t];
all_test_gammasU_lb_up_op = [a_t,b_t];
a_test_lb_up_op = [0.01,0.5];

d_t = diaFin - diaInicio;
tau_4_op_lb_lb =[1,240]; % obs: los taus estimados < periodo (dias de la data)

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

%% mientras mas al inicio de la pandemia este valor es más bajo, a 
%% medida que vanza se puede aumentar para asegurar convergencia
if acumulada == 2
    if diaInicio < 200
    factor_inicial=0.00001 %(seleccionados: 0.0125,0.002125)
    else
    factor_inicial=0.00005

    end
else % si se utilizan diferencias diarias
    factor_inicial=0.0005 %(seleccionados: 0.0125,0.002125)
end


beta = max(beta_lb_up_op)*factor_inicial; %tasa de contato (fabrizzio en algunas partes indica contacto en otra transmision) -- tasa de transmisión! .
gamma = max(gamma_lb_up_op)*factor_inicial;% % (1/gamma) tiempo de infección promedio - tasa de remosión media
alfaS=max(alfaS_lb_up_op)*factor_inicial;%0.00194; 
deltaS=max(deltaS_lb_up_op)*factor_inicial;%0.0011; 
all_test_gammasR=max(all_test_gammasR_lb_up_op)*factor_inicial;%0.0041;
all_test_gammasU=max(all_test_gammasU_lb_up_op)*factor_inicial;%0.00125;
a_test = max(a_test_lb_up_op);%; 
tau_4_op = max(tau_4_op_lb_lb);


% lb = [beta_lb_up_op(1,1);gamma_lb_up_op(1,1);alfaS_lb_up_op(1,1);deltaS_lb_up_op(1,1);all_test_gammasR_lb_up_op(1,1);all_test_gammasU_lb_up_op(1,1);a_test_lb_up_op(1,1)]'; % sin optimizar tau4
% ub = [beta_lb_up_op(1,2);gamma_lb_up_op(1,2);alfaS_lb_up_op(1,2);deltaS_lb_up_op(1,2);all_test_gammasR_lb_up_op(1,2);all_test_gammasU_lb_up_op(1,2);a_test_lb_up_op(1,2)]';

tic

all_blocks_params_model_analytics_hibridas
p=p0
% if acumulada == 2
% load p0_inicial.mat %buenos valores para acumualda=1
% p(1,10:end)=p0(1,10:end).*0.1
% 
% 
% 
% 
% end
% a_test=0.99
% primero = 1
% p=pUltimo
% p(1)=a_test
% 

%return
compute_curves_error
compute_curves

%pause

  main_all_blocks_1
compute_curves
format shortg

posIni = 4; 
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

all_gammas_salida  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_alfaS_salida    = p(posIni+nTau+nGammas:posIni+nTau+nGammas*2-1);
all_deltaS_salida   = p(posIni+nTau+nGammas*2:posIni+nTau+nGammas*3-1);
all_gammasU_salida  = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
all_betas_salida    = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammasR_salida  = p(posIni+nTau+nGammas*5:posIni+nTau+nGammas*6-1);


suma_beta = sum(all_betas_salida)
suma_gamma = sum(all_gammas_salida)
suma_alfaS = sum(all_alfaS_salida)
suma_deltaS = sum(all_deltaS_salida)
suma_gammasU = sum(all_gammasU_salida)
suma_gammasR = sum(all_gammasR_salida)

params_results = [suma_beta;suma_gamma;...
    suma_alfaS;suma_deltaS;suma_gammasU;...
    suma_gammasR;]

ro_basico = suma_beta/suma_gamma
ro_distribucion_bloque = all_betas_salida./all_gammas_salida

ro_basico_st = (suma_beta/suma_gamma)/nGammas

results_ro = [ro_basico;ro_basico_st];
%  p=p0
%  compute_curves_error
%  compute_curves
% 
% main_all_blocks_1
% p=p0
% compute_curves_error
% compute_curves
% primero = 1
% pUltimo=p
% all_blocks_params_model_analytics_hibridas