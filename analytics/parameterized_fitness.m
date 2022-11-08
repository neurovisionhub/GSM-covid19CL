function y = parameterized_fitness(p,N,acumulada,test_data_covid,diaInicio,diaFinEstudio)
%PARAMETERIZED_FITNESS fitness function for GA

%   Copyright 2004 The MathWorks, Inc.        
 
%numThetas
%% Gráfico para modelo con retardos (tiempos de incubación y de remoción)
%% Para datos de la RM hasta entre el 15-03-21 al 12-06-21
%p=p0;
%% all_taus = [tau1,tau2,tau3,tau4,tau5]';
%% p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas];
tau1=p(4);
tau2=p(5);
tau3=p(6);
tau4=p(7);
tau5=p(8);
%% Para la variante que incluye el paso de UCI a R
tau6=p(9);
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
tg=diaInicio:diaFinEstudio;
x0=[tg',test_data_covid(:,1:3)];
%taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%all_taus = taus;
% %% Para variante donde gammaUCI está directamente en la fc. obj.
% all_taus = [tau1,tau2,tau3,tau4]';
nTau=length(all_taus);

%sol = dde23('sir_ret_fun_21',[tau1,tau2],'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);
%% Variante con vacunación (la función de historia no cambia)
%% Para variante con vacunación se agregan dos retardos
% tau3=p(12);
% tau4=p(13);
% sol = dde23('sir_ret_fun_vac',[tau1,tau2,tau3,tau4],'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);
%% Para versión con UCI
sol = dde23('sir_ret_fun_vac_all',all_taus,'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);
y = deval(sol,tg);
%% Cálculo de los infectados acumulados
Inf = y(2,:);
UCI = y(4,:);
f_tmp = 0;
InfDa=test_data_covid(:,1);
UCIDa=test_data_covid(:,3);

Inf_t = Inf;
UCI_t = UCI;
InfDa_t=InfDa;
UCIDa_t=UCIDa;

fr=0;
Inf_tmp=0;
% 
% test_data_covid = Data;
% test_data_covid_estimate = y'; 
% 

if acumulada == 1

    Inf_tmp = y(2,:);
    Idays = diferenciasDiarias(Inf_tmp);
    fr=sigmoide_all(p,Idays,nTau);
    fr = ceil(fr); %% ajuste relevante
    InfR = fr.*Inf;
    f_tmp = cumsum(InfR);
else
fr = ceil(fr); %% ajuste relevante
InfR = fr.*Inf;
fr=sigmoide_all(p,y(2,:),nTau);

end
% %% Para la variante donde los UCI van en el target
% gammasU= p(12:12+nGammas-1)'; %de posicion 4 a nTau
% tUCI = linspace(tc(1),tc(end),numel(gammasU)) ;
% gammasUCI = interp1(tUCI,gammasU,tc);
% UCI = gammasUCI.*fr.*Inf;
%%

test_data_covid_estimate = y'; 
%figure
%salida = [InfDa,InfR',UCIDa,UCI'];

%E_days= mean ([ ( InfR-InfDa' )./(InfR) ( y(4,:)-UCIDa' )./y(4,:) ]);
%E= mean ([ ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2))  ( y(4,:)-UCIDa' )./y(4,:)' ]);


ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid_estimate(:,1));
ii = ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2));
uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid_estimate(:,4));
%ee = ( test_data_covid_estimate(:,3)-test_data_covid(:,3) )./(test_data_covid_estimate(:,3));
tx_dt = [ ss ; ii ; uu ];
rmse_t=  sqrt(mse(tx_dt))
E=  mean(tx_dt)
E=tx_dt;

end