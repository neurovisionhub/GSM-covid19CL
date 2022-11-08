
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
% % % %==========================================================================
% % % % ----Valores iniciales propuesto para los parametros beta y gamma---
% beta=0.194
% %beta=beta/2; % buen beta en all blocks
% %beta=beta/3;
% %beta=0.5*(0.5+1/3)*beta;
% %beta=beta/4;
% %nCiclos = 10
% for i=1:nCiclos
%     beta=0.5*(0.5+1/3)*beta;
% 
% end
%beta=0.124
%% Beta para variante donde los UCI van directamente en el target
%beta=0.01*beta;
% % % % %%%%%%%%%%%%%%%
% gamma=1/28; %(IR)
% % tau1=5;
% % tau2=14;
% tau1=5;
% tau2=14;
% tau3=7;
% tau4=120;
% tau5=35;
% %% Nueva variante con paso de UCI a R
% tau6=32;
% beta_qty = numThetas ; %RM % Ojo aqui con el n�mero de betas
% %beta_qty = 15 ; 
% %nTau = 2;
% %nBetas = beta_qty;
% %% Gamma para variante donde los UCI van directamente en el target
% %all_gammasU = ones(GammasUCI_qty,1)*beta*0.1/2 ;
% %all_gammasU = ones(beta_qty,1)*beta ; %Mismo n�mero de betas en gammas Uci (experimental) 
% a=0.5;
% %all_gammasU = beta*0.001 ; %Mismo n�mero de betas en gammas Uci (experimental) 
% %% Este valor es determinante en los resultados del experimento - considerar su estudio en 
% %% en el modelo de optimizaci�n y estabilidad
% %i=find(tc==(tc(end)-3)/5);
% i=find(tc==tc(end));
% indice=tc(1,end)
% aC=mean(Data(1:i)); % ---- OJO ----
% %aC=mean(xd(1:diaFin,1));
% %aC=mean(xd(1:indice,1));
% k=1e-3;
% alfaS=0.00194; % 0.194 funcionan
% deltaS=0.011; % 0.194

% if primera_ola==1
%     disp('Configurando primera ola')
%     tau1=5;
%     tau2=14;
%     tau3=7;
%     tau4=1; % tiempo de inmunidad lo reducimos a 1
%     tau5=35;
%     %% Nueva variante con paso de UCI a R
%     tau6=32;
%     beta=0.5;
%     k=1e-3;
%     alfaS=0.594; % 0.194 %(SR)
%     deltaS=0.51; % 0.194 %(RS)
%     
%     for i=1:nCiclos
%     beta=0.5*beta;
% 
%     end
% 
%     if acumulada == 1
%     k=1e-3;
%     alfaS=0.194; % 0.194  %(SR)
%     deltaS=0.11; % 0.194
%     end
% 
% 
% end

% all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
% 
% all_betas = ones(beta_qty,1)*beta ;
% GammasUCI_qty = nGammas;
% % all_gammasU = beta*0.001;
% %% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
% all_gammasU = ones(GammasUCI_qty,1)*0.001 ; %Mismo n�mero de betas en gammas Uci (experimental)
% %all_gammasU = ones(GammasUCI_qty,1)*beta/10; 
% %% Nueva variante con gamma de UCI a R
% %all_gammasR = 5*0.1*all_gammasU;
% all_gammasR = ones(GammasUCI_qty,1)*0.001;

% if primera_ola==1
% %aumento_tasas = 1;    
% all_gammasU = ones(GammasUCI_qty,1)*beta*0.001*10*5; 
% all_gammasR = 10*0.1*all_gammasU;
% % k=1e-3;
% % alfaS=0.00194*aumento_tasas; % 0.194 funcionan
% % deltaS=0.0194*aumento_tasas; % 0.194
% % all_gammasU = ones(GammasUCI_qty,1)*beta*0.01; funcionan bien para
% % segunda ola + uci diario
% % all_gammasR = 0.1*all_gammasU;
% 
% 
% %   if acumulada == 1
% % 
% %        k=1e-3;
% %     alfaS=0.194; % 0.194 funcionan
% %     deltaS=0.11; % 0.194
% % aumento_tasas = 1;    
% % all_gammasU = ones(GammasUCI_qty,1)*beta*0.01; 
% % all_gammasR = 0.1*all_gammasU;
% % k=1e-3;
% % alfaS=0.00194*aumento_tasas; % 0.194 funcionan
% % deltaS=0.0194*aumento_tasas; % 0.194
% %     end
% 
% 
% end
%beta=0.194
%beta=beta/2; % buen beta en all blocks
%beta=beta/3;
%beta=0.5*(0.5+1/3)*beta;
%beta=beta/4;
%nCiclos = 10
% beta=0.2
% for i=1:nCiclos
%     beta=0.5*(0.5+1/3)*beta;
%   %  beta= beta - 0.0001;
% end


%gamma=1/28; %(IR)
% tau1=5;
% tau2=14;
tau1=5;
tau2=14;
tau3=7;
tau4=120;
tau5=35;
%% Nueva variante con paso de UCI a R
tau6=32;
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
indice=tc(1,end);
%aC=mean(Data(1:i)); % ---- OJO ----
%aC=mean(xd(1:diaFin,1));
aC=mean(xd(1:indice,1));
% k=1e-3;
% alfaS=0.00194; % 0.194 funcionan
% deltaS=0.011; % 0.194
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';

all_betas = ones(beta_qty,1)*beta ;
GammasUCI_qty = nGammas;
% all_gammasU = beta*0.001;
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
all_gammasU = ones(GammasUCI_qty,1)*0.001; %Mismo n�mero de betas en gammas Uci (experimental)
%all_gammasU = ones(GammasUCI_qty,1)*beta/10; 
%% Nueva variante con gamma de UCI a R
%all_gammasR = 5*0.1*all_gammasU;
all_gammasR = ones(GammasUCI_qty,1)*0.01;
k=1e-3;
%gamma=0.01;
alfaS=0.01;
deltaS=0.01;
%all_gammasR = all_gammasU/2;
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
% disp('CARGADO... all_blocks_params_model');
% disp('Cualquier acción para continuar...');

%Re_SIR_t = (1/N).*all_betas*I'


%p0
%pause






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


