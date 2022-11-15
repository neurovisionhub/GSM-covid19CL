function E = vectorized_fitness(p_op,p,N,acumulada,test_data_covid,diaInicio,diaFinEstudio,numThetas,Data)
%PARAMETERIZED_FITNESS fitness function for GA
%tc=diaInicio:diaFinEstudio;
nGammas=numThetas;
%tc=t(1):t(end);
%time_range = tc;


%p(7)=p_op(8); %- verificar esta relacion  tau4 = 1/gamma
tau1=p(4);
tau2=p(5);
tau3=p(6);
tau4=p(7);
tau5=p(8);
%% Para la variante que incluye el paso de UCI a R
tau6=p(9);
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
tg=diaInicio:diaFinEstudio;
x0=[tg',test_data_covid];
%taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%all_taus = taus;
% %% Para variante donde gammaUCI está directamente en la fc. obj.
% all_taus = [tau1,tau2,tau3,tau4]';
nTau=length(all_taus);
tc=(1:size(tg,2))';
tg=tc;
beta_qty= numThetas;
%i=find(tc==tc(end));
indice=tc(1,end);
%aC=mean(Data(1:i)); % ---- OJO ----
aC=mean(test_data_covid(:,1));
%aC=mean(xd(1:indice,1));
%aC=mean(xd(:,1));
% k=1e-3;
% alfaS=0.00194; % 0.194 funcionan
% deltaS=0.011; % 0.194
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
a=p_op(7); %%TAMBIEN A OPTIMIZAR AL INICIO   
all_betas = ones(beta_qty,1)*p_op(1) ;
GammasUCI_qty = nGammas;
% all_gammasU = beta*0.001;
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
all_gammasU = ones(GammasUCI_qty,1)*p_op(6);%0.004 ; %Mismo n�mero de betas en gammas Uci (experimental)
%all_gammasU = ones(GammasUCI_qty,1)*beta/10; 
%% Nueva variante con gamma de UCI a R
%all_gammasR = 5*0.1*all_gammasU;
all_gammasR = ones(GammasUCI_qty,1)*p_op(5);
k=1e-3;
%gamma=0.01;
%alfaS=0.01;
%deltaS=0.01;
%all_gammasR = all_gammasU/2;
all_gammas = p_op(2)*ones(nGammas,1); %(IR)
all_alfaS = p_op(3)*ones(nGammas,1); %(SR)
all_deltaS = p_op(4)*ones(nGammas,1);%(RS)
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];
%sol = dde23('sir_ret_fun_21',[tau1,tau2],'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);
%% Variante con vacunación (la función de historia no cambia)
%% Para variante con vacunación se agregan dos retardos
% tau3=p(12);
% tau4=p(13);
% sol = dde23('sir_ret_fun_vac',[tau1,tau2,tau3,tau4],'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);

vectorInicial = [N-Data(1,1)-Data(1,2)-Data(1,3);Data(1,1);Data(1,2);Data(1,3)];
%vectorInicial = [N-Data(1,1)-Data(1,2);Data(1,1);Data(1,2);Data(1,3)];
%disp('en vectorized fittness')
%pause
options = ddeset('RelTol',1e-8,'AbsTol',1e-12,...
                 'InitialY',vectorInicial);

% options = ddeset('RelTol',1e-6,'AbsTol',1e-16,...
%                  'InitialY',vectorInicial,'NormControl','on');
%% Para versión con UCI
sol = dde23('sir_ret_fun_vac_all',all_taus,'sir_ret_hist',[tg(1),tg(end)],options,p0,N,x0);
y = deval(sol,tg);
retroceso=50;
tg_test = tg(1:end-retroceso,1);
% probar acá solo aproximar la integral hasta 10 días antes.


% pos_t = isnan(y);
% if isnan(sum(sum(y))) & traza == 1
%     salida = 'aparece NAN en y'
%     t
%     Z
%     p_op
%     tr
%     figure;plot(xds,'DisplayName','xds')
%     hold on
%     xline(pos_t)
%     pause
% end

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
    Idays = diferenciasDiarias(Inf_tmp);
    fr=sigmoide_all(p0,Idays,nTau);
    %fr = ceil(fr); %% ajuste relevante
    InfR = fr.*Inf;
    f_tmp = cumsum(InfR);
else
%fr = ceil(fr); %% ajuste relevante
InfR = fr.*Inf;
fr=sigmoide_all(p0,y(2,:),nTau);

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
% ss = (log(  abs(test_data_covid_estimate(:,1)-test_data_covid(:,4))) )./(log(abs(test_data_covid(:,4))));
% ii = (log(  abs(test_data_covid_estimate(:,2)-test_data_covid(:,1)) ))./(log(abs(test_data_covid(:,1))));
% uu = (log(  abs(test_data_covid_estimate(:,4)-test_data_covid(:,3)) ))./(log(abs(test_data_covid(:,3))));

% ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid(:,4) );
% ii = ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid(:,1) );
% uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid(:,3) );

ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid_estimate(:,1));
ii = ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2));
uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid_estimate(:,4));


 y_t = deval(sol,tg_test);
 test_data_covid_estimate_t=y_t'; 


ss_t = ( test_data_covid_estimate_t(tg_test,1)-test_data_covid(tg_test,4) )./(test_data_covid(tg_test,4) );
ii_t = ( test_data_covid_estimate_t(tg_test,2)-test_data_covid(tg_test,1) )./(test_data_covid(tg_test,1) );
uu_t = ( test_data_covid_estimate_t(tg_test,4)-test_data_covid(tg_test,3) )./(test_data_covid(tg_test,3) );
%ee = ( test_data_covid_estimate(:,3)-test_data_covid(:,3) )./(test_data_covid_estimate(:,3));
tx_dt_t = [ ss_t ; ii_t ; uu_t ]; %recordar probar el solo ss
sum_nan_t = sum(isnan(tx_dt_t));



%ee = ( test_data_covid_estimate(:,3)-test_data_covid(:,3) )./(test_data_covid_estimate(:,3));
%tx_dt = [ ss ; ii ; uu ]; %recordar probar el solo ss
 %tx_dt = [ uu ];
%tx_dt = [ ii ];
%tx_dt = [ ii ; uu ]; %recordar probar el solo ss
tx_dt = [ ss];%(1:end-10) ];
 tx_0 = tx_dt;

sum_nan = sum(isnan(tx_dt));
% tx_dt(isnan(tx_dt))=10e+6;
% tx_dt(tx_dt<0)=10e+6;
E_nan=mean(tx_dt)+sum_nan*10e+6
rmse_t=  sqrt(mse(test_data_covid_estimate(:,2)-test_data_covid(:,1)))
%integration_t = int 
 
%Que la suma de tasas sea 1 por tanto (sum(10:end,:)/nGammas) = 1

s_params_n =  (1-sum(p0(10:end,:))/nGammas);
w_score = s_params_n*0.5 + E_nan*0.3 %+ (p_op(8)-1/p_op(2))*0.2
%rmse_t=  sqrt(mse(tx_dt));

%p_op
%test_data_covid_estimate(:,1)'
%disp(p_op(8))
disp(p(7))
E=rmse_t
E=s_params_n
E=  w_score
E= E_nan
disp(w_score)
sum_nan
sum_nan_t
E = mean(tx_dt)


%end