
%% Definic�n de datos y par�metros iniciales para el ajuste
global nBetas 
global nGammas
global nTau
global time_range 
global all_taus;
global all_betas;
global all_gammasU;
global all_gammasR;
global all_gammas all_alfaS all_deltaS
global numThetas nCiclos;
%global Data primero
%global pMatrix;
nBetas=numThetas;
%global globalPais interpolacion;
%% Optimizaci�n se realiza con datos desde el 04 de marzo (hab�a 1 casos acumulado) hasta el 07 de sept
global diaInicio diaFin
tc=diaInicio:diaFin;
nGammas=numThetas;
%tc=t(1):t(end);
time_range = tc;
%% Los datos son s�lo los infectados activos diarios
Data=xd(tc,:);
x0=[tc' Data];

 
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


if acumulada ==0 % funciona relativamnte bien
%     mean_data_ini=mean(xd(1:diaFin,1));
%     max_data_ini = max(xd(1:diaFin,1))
    mean_data_ini=mean(xd(:,1));
    max_data_ini = max(xd(:,1))
end


if acumulada ==1 

%tc_a=diaInicio-1:diaFin-1;
tc_a_ini=1:diaFin;
%Data=xd(tc_a,:);
Data_of_ini = xd(tc_a_ini,:);
Data_of_ini_diff_i = diferenciasDiarias(Data_of_ini(:,1)');
% 
% Data(:,1)= diferenciasDiarias(Data(:,1)');
% Data(:,2)= diferenciasDiarias(Data(:,2)');
% Data(:,3)= diferenciasDiarias(Data(:,3)');
% x0=[tc' Data];
% figure
% plot(Data(:,1:3))
%% Aca se puede ajustar el valor en diff, donde esta
%la posicion id
% max_data_ini = max(Data_of_ini_diff_i);
% mean_data_ini = mean(Data_of_ini_diff_i);

   mean_data_ini=mean(xd(1:diaFin,1));
   max_data_ini = max(xd(1:diaFin,1)); 
   median_data_ini= median(xd(1:diaFin,1));
if maxGlobal==1

%% El valor maximo o bien diferentes valores en la media y maximo
%% se pueden utilizar para efectos de simulación ya que en el modelo de
%% ajuste es quien define el comportomaineto de la curva y el optimizador
    max_data_ini = max(xd(:,1));
end
%% Inlcuso estos valores se pueden utilizar para aumentar levemente en porcentajes los valores hasta la fecha
%% y de esta manera obtener los valores de parametros en diferentes escenarios
if meanGlobal==1
    mean_data_ini= mean(xd(:,1));
end
%% Es más la proyección de la primera ola y en especifico el valor de y_Real de olas previas es el valor inicial en la
%% aproximacion de siguientes olas... asi que profundizar en esto!!!!!!!!

if mediana==1
    mean_data_ini=median_data_ini;


end

end





v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2)-xd(diaInicio,3);
    Data(1,1);Data(1,2);Data(1,3)];
%v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2);...
%    Data(1,1);Data(1,2);Data(1,3)];
tau1=5;
tau2=14;
tau3=7; %tiempo en que comienza el efecto de la vacuna?
tau4=tau_4_op; % tiempo de inmunidad
tau5=35;
%% Nueva variante con paso de UCI a R
tau6=32;
beta_qty = numThetas ; %RM % Ojo aqui con el n�mero de betas
a=a_test;
%all_gammasU = beta*0.001 ; %Mismo n�mero de betas en gammas Uci (experimental) 
%% Este valor es determinante en los resultados del experimento - considerar su estudio en 
%% en el modelo de optimizaci�n y estabilidad
%i=find(tc==(tc(end)-3)/5);
i=find(tc==tc(end));
indice=tc(1,end);
%aC=mean(Data(1:i)); % ---- OJO ----
%aC=mean(xd(1:diaFin,1));
aC=mean_data_ini;
%aC=mean_data_ini;
%aC=mean(xd(1:indice,1));
%aC=mean(xd(:,1));
% k=1e-3;
% alfaS=0.00194; % 0.194 funcionan
% deltaS=0.011; % 0.194
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';

all_betas = ones(beta_qty,1)*beta ;
GammasUCI_qty = nGammas;
% all_gammasU = beta*0.001;
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
all_gammasU = ones(GammasUCI_qty,1)*all_test_gammasU;%0.004 ; %Mismo n�mero de betas en gammas Uci (experimental)
%% Nueva variante con gamma de UCI a R
%all_gammasR = 5*0.1*all_gammasU;
all_gammasR = ones(GammasUCI_qty,1)*all_test_gammasR;
k=1e-3;
all_gammas = gamma*ones(nGammas,1); %(IR)
all_alfaS = alfaS*ones(nGammas,1); %(SR)
all_deltaS = deltaS*ones(nGammas,1);%(RS)
if primero == 0
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];

 


%primero=1;
%pUltimo=p0;
else
p0=pUltimo;
end

% d_t_tmp = diaFin - diaInicio;
% sampling_t = ceil(1:d_t_tmp/(nGammas-1):d_t_tmp);
% 
% size_t_int =  [sampling_t,size(x0,1)]';
% S_t = N-x0(1,1)-x0(1,2)-x0(1,3);
% 
% S_t = N-x0(size_t_int,2)-x0(size_t_int,3)-x0(size_t_int,4);
% RE_SIR = (all_betas.*S_t)./(all_gammas*N);
% t_taus = all_taus;
% R_I = x0(size_t_int,2);
%compute_curves
% all_betas/100
% 1./all_gammas