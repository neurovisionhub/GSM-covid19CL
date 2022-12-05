%% This routine builds the vector of initial values of the model.

global nBetas 
global nGammas
global nTau
global time_range 
global all_taus;
global all_betas;
global all_gammasU;
global all_gammasR;
global all_gammas all_alfaS all_deltaS
global numThetas ;

nBetas=numThetas;
tc=diaInicio:diaFin;
nGammas=numThetas;
time_range = tc;
Data=xd(tc,:);
x0=[tc' Data];

%% for case data daily curves (this paper dev) 
if acumulada == 2 
    tc_a=diaInicio-1:diaFin;
    tc_b=diaInicio:diaFin;
    tc_a_ini=1:diaFin;
    Datatmp=xd(tc_a,:);
    Data_of_ini = xd(tc_a_ini,:);
    Data_of_ini_diff_i = diferenciasDiarias(Data_of_ini(:,1)'); % ok
    Data(:,1)= diff(Datatmp(:,1)');
    Data(:,2)= diff(Datatmp(:,2)');
    Data(:,3)= diff(Datatmp(:,3)');
    x0=[tc' Data];
    figure
    plot(Data(:,1:3))
    mean_data_ini = mean(Data_of_ini_diff_i);
    max_data_ini = max(Data_of_ini_diff_i);
end

%% for case data cumulative curves (experimental dev)
if acumulada ==0 % funciona relativamnte bien
%     mean_data_ini=mean(xd(1:diaFin,1));
%     max_data_ini = max(xd(1:diaFin,1))
    mean_data_ini=mean(xd(:,1));
    max_data_ini = max(xd(:,1))
end

%% for case data cumulative curves with (this paper dev)
if acumulada ==1 

tc_a=diaInicio-1:diaFin-1;
tc_a_ini=1:diaFin;
Data_of_ini = xd(tc_a_ini,:);
Data_of_ini_diff_i = diferenciasDiarias(Data_of_ini(:,1)');

   mean_data_ini=mean(xd(1:diaFin,1));
   %mean_data_ini = mean(Data_of_ini_diff_i); % example of other test
   if media_inicio_fin == 1

    mean_data_ini=mean(xd(diaInicio:diaFin,1));

   end

   max_data_ini = max(xd(1:diaFin,1)); 
   median_data_ini= median(xd(1:diaFin,1));
if maxGlobal==1

%% El valor maximo o bien diferentes valores en la media y maximo
%% se pueden utilizar para efectos de simulación ya que en el modelo de
%% ajuste es quien define el comportomaineto de la curva y el optimizador

%% The maximum value or different values in the mean and maximum
%% can be used for simulation purposes since in the model of
%% fit is who defines the behavior of the curve and the optimizer

    max_data_ini = max(xd(:,1));
end
%% Incluso estos valores se pueden utilizar para aumentar levemente en porcentajes los valores hasta la fecha
%% y de esta manera obtener los valores de parametros en diferentes escenarios

%% Even these values can be used to slightly increase the values to date in percentages
%% and in this way obtain the values of parameters in different scenarios

if meanGlobal==1
    mean_data_ini= mean(xd(:,1));
end
%% Es más la proyección de la primera ola y en especifico el valor de y_Real de olas previas es el valor inicial en la
%% aproximacion de siguientes olas... proxima investigacion

%% It is more the projection of the first wave and specifically the value of y_Real of previous waves is the initial value in the
%% approximation of next waves... next investigation

if mediana==1
    mean_data_ini=median_data_ini;
end
end

%% initial diferential equation values on solver dde23
v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2)-xd(diaInicio,3);
    Data(1,1);Data(1,2);Data(1,3)];

%% initial taus values on the optimizer
tau1=5;
tau2=14;
tau3=7; 
tau4=240;
%tau4=30; % example of decrease of the immunity tau4=30 (one month)
tau5=35;
tau6=32;
beta_qty = numThetas ; % number of params (partitions or number of intervals) of the blocks
a=a_test;
k=1e-3;
%% Importante: Este valor "aC" es determinante en los resultados del experimento - considerar su estudio en el modelo de optimización y estabilidad
%% Important: this value "aC" is decisive in the results of the experiment - consider its study in the optimization and stability model

i=find(tc==tc(end));
indice=tc(1,end);
aC=mean_data_ini;
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
all_betas = ones(beta_qty,1)*beta ;
GammasUCI_qty = nGammas;
all_gammasU = ones(GammasUCI_qty,1)*all_test_gammasU; % Same number of betas in Uci gammas (experimental)
all_gammasR = ones(GammasUCI_qty,1)*all_test_gammasR;
all_gammas = gamma*ones(nGammas,1); %(IR)
all_alfaS = alfaS*ones(nGammas,1); %(SR)
all_deltaS = deltaS*ones(nGammas,1);%(RS)

% For the case of load checkpoints on iterative cyclic call optimizer
% default = 0
if primero == 0
    p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR]; 
    params_exp_ini = [a;k;aC];
    params_tasas_ini = [beta;gamma;alfaS;deltaS;all_test_gammasU;all_test_gammasR];
    params_taus_ini = [tau1;tau2;tau3;tau4;tau5;tau6];
    p_inicial = p0;
else
    p0=pUltimo;
end
