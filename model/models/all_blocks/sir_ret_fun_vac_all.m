%% Lado derecho del modelo SIR con dos retardos tau1 y tau2
function v = sir_ret_fun_vac_all(t,y,Z,p,N,x0)
%global time_range 
%global nBetas

% global all_betas
% global all_gammasU
% global all_gammasR
% global all_gammas all_alfaS all_deltaS
%global traza
traza=0;
nTau = 6;
nGammas = (size(p,1)-9)/6;
%Z
% t = ceil(t);

% if mod(t,1)==0
 %t
% end
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

%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
%% NUEVO -> p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];
posIni = 4; 

size_x=size(x0,1);
range = 1:size_x;

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



%t=ceil(t); %% --- %%
tr = linspace(min(range),max(range),numel(all_betas));
%beta = piecewise_interpolator(t,all_betas,tr) ;
if t<=range(end)
    beta   = interp1(tr,all_betas,t);
    alfaS  = interp1(tr,all_alfaS,t);
    deltaS = interp1(tr,all_deltaS,t);
    gamma  = interp1(tr,all_gammas,t); 
 else
    beta   = interp1(tr,all_betas,range);
    alfaS  = interp1(tr,all_alfaS,range);
    deltaS = interp1(tr,all_deltaS,range);
    gamma  = interp1(tr,all_gammas,range);
end
tr2 = linspace(min(range),max(range),numel(all_gammasU));
%gammasUCI = piecewise_interpolator(t,all_gammasU,tr2);
 if t<=range(end)
   gammasUCI = interp1(tr2,all_gammasU,t);
 else
      gammasUCI = interp1(tr2,all_gammasU,range);
%  gammasUCI = interp1(tr2,all_gammasU,t);
 end
%% Nueva variante con gamma de UCI a R
tr3 = linspace(min(range),max(range),numel(all_gammasR));
 if t<=range(end)
   gammasR   = interp1(tr3,all_gammasR,t);
 else
    gammasR   = interp1(tr3,all_gammasR,range);
 end
%fr=sigmoide(p,y(2,:),nTau);
%frd=interp1(time_range,fr,t-tau5,'pchip','extrap');
%%
%% Por ahora el cambio de escenario es al ojo
%% Aqui definir una estrategia de carga rapida de datos y parametros de simulación
%beta = beta1.*(t<=44)+beta2.*( (t>44) & (t<=72) )+beta3.*( t>72 );
%   disp(y(1))
%   disp(t)
%   disp(Z)
%  pause
if isnan(sum(sum(Z))) & traza == 1
    salida = 'aparece NAN en Z sis_ter_fun_vac_all'
   
    Z
    beta
    gamma   
    deltaS
    alfaS
    
    gammasUCI
    gammasR
    tr
    figure;plot(Z,'DisplayName','Z')
    hold on
    xline(tr)
    xline(t,'color','red')
    figure;
    plot(x0)
    hold on
    xline(t,'color','red')
    %x0
    - beta
    y(1)
    y(2)
    y(3)
    y(4)
    y
    ylag1
    N
    t
    range(end)
    pause
end

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

% disp(t)
%% OSCAR
%t
v(1,1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1) +0.001;
v(2,1) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2) +0.001;%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) ); Di
%v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2); %di
v(3,1) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+gammasR*ylag6(4)   +0.001;%dr
v(4,1) = gammasUCI*ylag5(2)-gammasR*ylag6(4)  +0.001; %du
% 
%    y(1)
% 
%     ylag1(2)
%  ylag3(1)
%     ylag4(1)
if(isnan(v)|v(1,1)==inf)
 
    t
  %  beta
%     alfaS
%     deltaS
  %  pause
end
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


if isnan(Z) & traza == 1
    salida = 'aparece NAN en v'
    v
    pause
end