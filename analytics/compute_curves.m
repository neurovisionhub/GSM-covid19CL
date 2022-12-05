tau1=p(4);
tau2=p(5);
tau3=p(6);
tau4=p(7);
tau5=p(8);
tau6=p(9);
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
%load("solucionbuena_calibracion.mat") % on case of charge directy initial
% data, for example to manual "p0"

nTau=length(all_taus);
tg=(1:max(size(Data)))';
tc=tg;
%%  config: solver EDP with time delays 
v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2)-xd(diaInicio,3);
    Data(1,1);Data(1,2);Data(1,3)];
vectorInicial = v_ini;

options = ddeset('RelTol',1e-4,'AbsTol',1e-8,...
                 'InitialY',vectorInicial,'InitialStep',10);
sol = dde23('sir_ret_fun_vac_all',all_taus,'sir_ret_hist',[tg(1),tg(end)],[],p,N,x0);
y = deval(sol,tg);

%% solver solutions
Inf = y(2,:);
UCI = y(4,:);
f_tmp = 0;
InfDa=Data(:,1);
UCIDa=Data(:,3);
Inf_t = Inf;
UCI_t = UCI;
InfDa_t=InfDa;
UCIDa_t=UCIDa;

fr=0;
Inf_tmp=0;
test_data_covid = Data;
test_data_covid_estimate = y'; 

% For adjustments on accumulated curves
if acumulada == 1 || acumulada == 0
    Inf_tmp = y(2,:);
    Idays = diferenciasDiarias(Inf_tmp);
    Idays_target = diferenciasDiarias(test_data_covid(:,1)');
    fr=sigmoide_all(p,Inf_tmp,nTau); 
    InfR = fr.*Idays;
    f_tmp = cumsum(InfR);
else % For adjustments on daily curves
    fr=sigmoide_all(p,y(2,:),nTau); 
end

%% In case of evaluating fit of the model
% ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid_estimate(:,1));
% ii = ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2));
% rr = ( test_data_covid_estimate(:,3)-test_data_covid(:,2) )./(test_data_covid_estimate(:,3));
% uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid_estimate(:,4));
% ii_fr = ( fr'.*test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(fr'.*test_data_covid_estimate(:,2));
% rr_fr = ( fr'.*test_data_covid_estimate(:,3)-test_data_covid(:,2) )./(fr'.*test_data_covid_estimate(:,3));


%% In case of evaluating fit to the data (default on evaluation results)
ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid(:,4));
ii = ( fr'.*test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid(:,1));
rr = ( fr'.*test_data_covid_estimate(:,3)-test_data_covid(:,2) )./(test_data_covid(:,2));
uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid(:,3));
salida=fr'.*test_data_covid_estimate(:,2);
ii_fr = ( fr'.*test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(fr'.*test_data_covid_estimate(:,2));
rr_fr = ( fr'.*test_data_covid_estimate(:,3)-test_data_covid(:,2) )./(fr'.*test_data_covid_estimate(:,3));

%% error groups
tx_dt = [ ss ; ii_fr; ii ; rr; uu ];
tx_dt_g_y = [ ss , ii_fr, ii , rr, uu ];
tx_dt_g_y0 = [ ss ,  ii , rr, uu ];
figure;boxplot(tx_dt_g_y0);

%% data analysis
target_y = test_data_covid;
output_y = test_data_covid_estimate;
tx_dt_g_target = [ target_y(:,4) , target_y(:,1), target_y(:,2) , target_y(:,3)];
tx_dt_g_output = [ output_y(:,1) , output_y(:,2), output_y(:,3) , output_y(:,4)];
s_pares = [tx_dt_g_target(:,1),tx_dt_g_output(:,1)];

%% Complementary graphics analysis
figure;
plot(tx_dt_g_target);
hold on;
plot(tx_dt_g_output);

%% Estimations of the errors in the origin data
rmse_t=  sqrt(mse(tx_dt));
E=  mean(tx_dt); % global error
Ess=  mean(abs(ss)); % susceptible error
Eii=  mean(abs(ii)); % infected error
Err = mean(abs(rr)); % recovered error
Euu=  mean(abs(uu)); % icu error
Error_rr_fr=  mean(abs(rr_fr)); %  recovered real "model" error
Error_ii_fr=  mean(abs(ii_fr)); % infected real "model" error

%% cumulative waves case (post-proccesing data)
if acumulada == 1 || acumulada == 0
    UCIc = diferenciasDiarias(UCI);
    UCIr = diferenciasDiarias(UCIDa');
    %Infac = diferenciasDiarias(InfR);fr.*
    Infac = fr.*diferenciasDiarias(test_data_covid_estimate(:,2)');
    InfDar = diferenciasDiarias(InfDa'); % infected daily target
    Infc = diferenciasDiarias(Inf); % infected daily solver
    UCI =UCIc;
    UCIDa =UCIr; 
    %InfR =Infac; %[Infac,Infac(1,end)];
    InfDa =InfDar;
    Inf =Infc;
        I_test = diferenciasDiarias(test_data_covid(:,1)');
        R_test = diferenciasDiarias(test_data_covid(:,2)');
        U_test = diferenciasDiarias(test_data_covid(:,3)');
        R_test_fit = InfR;
    ii = ( Infac-I_test )./(I_test); % infected relative error (daily)   
    rr = ( R_test_fit-R_test)./(R_test); %recovered relative error (daily) 
    uu = ( UCIc-U_test)./(UCIDa); % icu relative error (daily) 
    %Ess=  mean(abs(ss))
    Eii=  mean(abs(ii));
    Err = mean(abs(rr));
    Euu=  mean(abs(uu));
else %% daily waves case (acumulada == 2)
    UCIc = UCI;
    UCIr = UCIDa;
    InfR = salida;
    Infac = InfR;
    InfDar =InfDa;    
    rr = ( test_data_covid_estimate(:,3)-test_data_covid(:,2) )./(test_data_covid(:,2));
end

figure;
hold on;
plot(UCIc);
hold on;
plot(UCIr);
figure;
hold on;
plot(Infac);
hold on;
plot(InfDar);

% %% For graphics of the results from used cumulated curves: unofficial paper)
% if acumulada == 1 
% 
%     figure
%     formatSpec = " -%d thetas";
%     str = compose(formatSpec,numThetas);
%     titulo = region + str;
%     %UCIDa=xd(tc+round(tau5),3);
%     %% Gráficos
%     %% Para muchos datos graficarlos sólo cada 2 días
%     I=find( mod(tc,2)==0 );
%     % I=[1 I length(tc)];
%     % I=find( mod(tc,2)==0 );
%     % I=[1 I];
%     %I=find(tc);
%     texp=tc(I);
%     clf
%     subplot(121)
%     plot(tg,test_data_covid_estimate(:,2),'--k','LineWidth',2.3)
%     hold on
%     plot(tg,f_tmp,'r','LineWidth',0.7)
%     plot(texp,test_data_covid(I,2),'sb','MarkerEdgeColor','b',...
%         'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
%     maxdata=max([test_data_covid(:,1);f_tmp']);
%     mindata=min([test_data_covid(:,1);f_tmp']);
%     maxInf=max(Inf);
%     minInfR=min(InfR);
%     maxInfR=max(InfR);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     xlabel('Time (days)')
%     ylabel('Cases number')
%     axis([tg(1)-2 tg(end)+2 0.01*min(minInfR,mindata) 1.05*max(maxdata,maxInf)])
%     %% Para datos acumulados de la RM
%     %% Cuando no se grafica ya
%     title(titulo)
%     lgd=legend('$I$ fitted','$I$ actual','Data I');
%     set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
%     subplot(122)
%     plot(tg,UCI,'-.k','LineWidth',2.3)
%     hold on
%     plot(texp,test_data_covid(I,3),'sb','MarkerEdgeColor','b',...
%         'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
%     title(titulo)
%     maxdata=max(test_data_covid(:,3));
%     mindata=min(test_data_covid(:,3));
%     maxUCI=max(UCI_t);
%     minUCI=min(UCI_t);
%     axis([tg(1)-2 tg(end)+2 0.01*min(minUCI,mindata) 1.05*max(maxdata,maxInf)])
%     lgd=legend('$UCI$ fitted','Data UCI');
%     set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
%     shg
% end

figure
formatSpec = " -%d thetas";
str = compose(formatSpec,numThetas);
titulo = region + str;
%UCIDa=xd(tc+round(tau5),3);
%% Gráficos
%% Para muchos datos graficarlos sólo cada 6 días
I=find( mod(tc,2)==0 );
% I=[1 I length(tc)];
% I=find( mod(tc,2)==0 );
% I=[1 I];
%I=find(tc);
texp=tc(I);
clf
subplot(121)
plot(tg,InfR,'--k','LineWidth',0.5)
hold on
plot(tg,Inf,'r','LineWidth',0.5)
%% Fit the point (remember)
plot(texp,InfDa(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2);
maxdata=max(InfDa);
mindata=min(InfDa);
maxInf=max(Inf);
minInfR=min(InfR);
maxInfR=max(InfR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('Time (days)')
ylabel('Cases number')
axis([tg(1)-2 tg(end)+2 0.01*min(minInfR,mindata) 1.05*max(maxdata,maxInf)])
title(titulo)
lgd=legend('$I$ fitted','$I$ actual','Data I');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
subplot(122)
plot(tg,UCI,'-.k','LineWidth',0.5)
hold on
plot(texp,UCIDa(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',2);
title(titulo)
maxdata=max(UCIDa);
mindata=min(UCIDa);
maxUCI=max(UCI);
minUCI=min(UCI);
axis([tg(1)-2 tg(end)+2 0.01*min(minUCI,mindata) 1.05*max(maxdata,maxUCI)])
lgd=legend('$UCI$ fitted','Data UCI');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
shg


