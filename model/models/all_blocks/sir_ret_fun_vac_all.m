%% Lado derecho del modelo SIR con dos retardos tau1 y tau2
function v = sir_ret_fun_vac_all(t,y,Z,p,N,~)
global time_range 
global nBetas
global nGammas
global all_betas
global all_gammasU
global all_gammasR
global all_gammas all_alfaS all_deltaS
global nTau traza
%Z
%t = ceil(t)
ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
ylag4 = Z(:,4);
ylag5 = Z(:,5);
%% Version 16-01-2022
%all_betas = p(end-nBetas+1:end);
%all_gammasU = p(end-nGammas-nBetas+1:end-nBetas);
%% Nueva variante con gamma de UCI a R
ylag6 = Z(:,6);
if isnan(sum(sum(Z))) & traza == 1
    salida = 'aparece NAN en Z'
    t
    Z
    pause
end
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
%% NUEVO -> p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];
posIni = 4; 

all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_alfaS   = p(posIni+nTau+nGammas:posIni+nTau+nGammas*2-1);
all_deltaS  = p(posIni+nTau+nGammas*2:posIni+nTau+nGammas*3-1);
all_gammasU = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
all_betas   = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammasR = p(posIni+nTau+nGammas*5:posIni+nTau+nGammas*6-1);
%% hasta antes de 24 de septiembre 2002
% % all_betas   = p(end-nGammas-nBetas+1:end-nGammas);
% % all_gammasU = p(end-2*nGammas-nBetas+1:end-nBetas-nGammas);
% % all_gammasR = p(end-nGammas+1:end);
%% hasta antes de sep 2022
% % gamma=p(1);
% % alfaS=p(2);
% % deltaS=p(3);
tr = linspace(min(time_range),max(time_range),numel(all_betas)) ;
%beta = piecewise_interpolator(t,all_betas,tr) ;
if t<=time_range(end)
    beta   = interp1(tr,all_betas,t);
    alfaS  = interp1(tr,all_alfaS,t);
    deltaS = interp1(tr,all_deltaS,t);
    gamma  = interp1(tr,all_gammas,t); 
else
    beta   = interp1(tr,all_betas,time_range(end));
    alfaS  = interp1(tr,all_alfaS,time_range(end));
    deltaS = interp1(tr,all_deltaS,time_range(end));
    gamma  = interp1(tr,all_gammas,time_range(end));
end
tr2 = linspace(min(time_range),max(time_range),numel(all_gammasU)) ;
%gammasUCI = piecewise_interpolator(t,all_gammasU,tr2);
if t<=time_range(end)
   gammasUCI = interp1(tr2,all_gammasU,t);
else
   gammasUCI = interp1(tr2,all_gammasU,time_range(end));
  % gammasUCI = interp1(tr2,all_gammasU,t);
end
%% Nueva variante con gamma de UCI a R
tr3 = linspace(min(time_range),max(time_range),numel(all_gammasR)) ;
if t<=time_range(end)
   gammasR   = interp1(tr3,all_gammasR,t);
else
   gammasR   = interp1(tr3,all_gammasR,time_range(end));
end
%fr=sigmoide(p,y(2,:),nTau);
%frd=interp1(time_range,fr,t-tau5,'pchip','extrap');
%%
%% Por ahora el cambio de escenario es al ojo
%% Aqui definir una estrategia de carga rapida de datos y parametros de simulación
%beta = beta1.*(t<=44)+beta2.*( (t>44) & (t<=72) )+beta3.*( t>72 );


%v = zeros(3,1);
v = zeros(4,1);
% v(1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1);
% v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2);
% v(3) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1);
% v(4) = gammasUCI*ylag2(2);

% %% NUEVO
% v(1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1);
% v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2);%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) );
% %v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2);
% v(3) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+gammasR*ylag6(4);
% v(4) = gammasUCI*ylag5(2)-gammasR*ylag6(4);


%% OSCAR

v(1,1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1) + 1e-5;
v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
%v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
v(3,1) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+ 1e-5+gammasR*ylag6(4)  ;%dr
v(4,1) = gammasUCI*ylag5(2)+ 1e-5-gammasR*ylag6(4) + 1e-2; %du

% v(1,1) = - beta*log10(gammasUCI*ylag5(2)+1)*(1+gammasR)-alfaS*ylag3(1)+deltaS*ylag4(1)+ 1e-5;
% %v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% %v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
% v(2,1) = log10(gammasUCI*ylag5(2)+1)*(1+gammasR)-gamma*ylag2(2)+ 1e-5;%- gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% 
% 
% v(3,1) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+ 1e-5;%   +gammasR*ylag6(4)  ;%dr
% v(4,1) = gammasUCI*ylag5(2);%+ 1e-5-gammasR*ylag6(4) + 1e-2; %du

% %%% bien uci
% v(1,1) = - beta*y(1)*ylag1(2)/N+deltaS*ylag4(1)+ 1e-5;
% %v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% %v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
% v(2,1) = log10(gammasUCI*ylag5(2)+1)*(1+gammasR)+ 1e-5;%- gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% v(3,1) = log10(gammasUCI*ylag5(2)+1)*(1+gamma)-deltaS*ylag4(1)+ 1e-5;%   +gammasR*ylag6(4)  ;%dr
% v(4,1) = gammasUCI*ylag5(2);%+ 1e-5-gammasR*ylag6(4) + 1e-2; %du



% v(1,1) = -beta*y(1)*ylag1(2)/N + log10(gammasUCI*ylag5(2)+1)*(1+gamma)+ 1e-5;
% %v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% %v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
% v(2,1) =beta*y(1)*ylag1(2)/N - log10(gammasUCI*ylag5(2)+1)*(1+gammasR)+ 1e-5;%- gammasUCI*ylag5(2)  + 1e-5;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% 
% 
% v(3,1) = log10(gammasUCI*ylag5(2)+1)*(1+gamma)+ 1e-5;%   +gammasR*ylag6(4)  ;%dr
% v(4,1) = gammasUCI*ylag5(2);%+ 1e-5-gammasR*ylag6(4) + 1e-2; %du

% %pause
% if isnan(v(1,1)) || isnan(v(2,1))|| isnan(v(3,1))|| isnan(v(4,1))
%     
%     N
%     v(1,1)
%     v(2,1)
%     v(3,1)
%     v(4,1)
%     t
%     beta
%     deltaS
%     alfaS
%     gamma
%     gammasUCI
%     gammasR
%     ylag3(1)
%     %pause 
%     y(1)
%     pause
% end

% %% OSCAR
% v(1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1);
% v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2);%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
% %v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
% v(3) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1);%+gammasR*ylag6(4); %dr
% v(4) = gammasUCI*ylag5(2);%-gammasR*ylag6(4); %du
% %v(4) = gammasUCI*ylag5(2);
% gammasUCI;
% v
% beta
% gamma
% alfaS
% deltaS
if isnan(Z) & traza == 1
    salida = 'aparece NAN en v'
    v
    pause
end