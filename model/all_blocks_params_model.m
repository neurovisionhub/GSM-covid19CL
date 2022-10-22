
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
global numThetas;
%global pMatrix;
nBetas=numThetas;
%global globalPais interpolacion;

%% Optimizaci�n se realiza con datos desde el 04 de marzo (hab�a 1 casos acumulado) hasta el 07 de sept

tc=diaInicio:diaFin;
%tc=t(1):t(end);
time_range = tc;

%% Los datos son s�lo los infectados activos diarios
Data=xd(tc,:);
x0=[tc' Data];

% % % %==========================================================================
% % % % ----Valores iniciales propuesto para los parametros beta y gamma---
beta=0.194;
%beta=beta/2;
%beta=beta/3;
beta=0.5*(0.5+1/3)*beta;
%beta=beta/4;


%beta=0.124
%% Beta para variante donde los UCI van directamente en el target
%beta=0.01*beta;
% % % % %%%%%%%%%%%%%%%
gamma=1/28;
% tau1=5;
% tau2=14;
tau1=5;
tau2=14;
tau3=7;
tau4=120;
tau5=35;
%% Nueva variante con paso de UCI a R
tau6=32;

all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
%% Normalización
% tau1n=(tau1-1)/13;
% tau2n=(tau2-1)/20;
% tau3n=(tau3-1)/19;
% tau4n=(tau4-1)/239;
% tau5n=(tau5-14)/42;
% tau6n=(tau6-21)/21;
% all_taus = [tau1n,tau2n,tau3n,tau4n,tau5n,tau6n]';
beta_qty = numThetas ; %RM % Ojo aqui con el n�mero de betas
%beta_qty = 15 ; 
%nTau = 2;
%nBetas = beta_qty;

%% Gamma para variante donde los UCI van directamente en el target
%all_gammasU = ones(GammasUCI_qty,1)*beta*0.1/2 ;

%all_gammasU = ones(beta_qty,1)*beta ; %Mismo n�mero de betas en gammas Uci (experimental) 
a=0.5;
%all_gammasU = beta*0.001 ; %Mismo n�mero de betas en gammas Uci (experimental) 

%% Este valor es determinante en los resultados del experimento - considerar su estudio en 
%% en el modelo de optimizaci�n y estabilidad
%i=find(tc==(tc(end)-3)/5);
i=find(tc==tc(end));
aC=mean(Data(1:i));
%aC=mean(xd(1:i,1));
k=1e-3;
alfaS=0.00194; % 0.194 funcionan
deltaS=0.011; % 0.194
all_betas = ones(beta_qty,1)*beta ;
GammasUCI_qty = nGammas;
% all_gammasU = beta*0.001;
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
all_gammasU = ones(GammasUCI_qty,1)*beta*0.001*10*5 ; %Mismo n�mero de betas en gammas Uci (experimental)
%% Nueva variante con gamma de UCI a R
all_gammasR = 5*0.1*all_gammasU;
all_gammas = gamma*ones(nGammas,1);
all_alfaS = alfaS*ones(nGammas,1);
all_deltaS = deltaS*ones(nGammas,1);

if primero == 0
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];
else
p0=pUltimo;

end
disp('CARGADO... all_blocks_params_model')





% if expTradicional==1
%     if experimento == 2
%     main_new_vacunacion2;
%     elseif experimento == 3
%     main_new_vacunacion3;
%     else
%     main_new_vacunacion;    
%     end
% 
%     figure
%     graficaSIRr_vac
% end


