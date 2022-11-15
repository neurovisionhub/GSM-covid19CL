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
%load("solucionbuena_calibracion.mat")
%taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%all_taus = taus;
% %% Para variante donde gammaUCI está directamente en la fc. obj.
% all_taus = [tau1,tau2,tau3,tau4]';
nTau=length(all_taus);
tg=(1:max(size(Data)))';
tc=tg;
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


if acumulada == 1

    Inf_tmp = y(2,:);
    Idays = diff(Inf_tmp);
    Idays = [Idays,Idays(end)];

    fr=sigmoide_all(p,Idays,nTau);
    fr = fr; %% ajuste relevante
    InfR = fr.*Inf;
    f_tmp = cumsum(InfR);
else
fr = fr; %% ajuste relevante
InfR = fr.*Inf;
fr=sigmoide_all(p,y(2,:),nTau);

end
% %% Para la variante donde los UCI van en el target
% gammasU= p(12:12+nGammas-1)'; %de posicion 4 a nTau
% tUCI = linspace(tc(1),tc(end),numel(gammasU)) ;
% gammasUCI = interp1(tUCI,gammasU,tc);
% UCI = gammasUCI.*fr.*Inf;
%%


%figure
salida = [InfDa,InfR',UCIDa,UCI'];

%E_days= mean ([ ( InfR-InfDa' )./(InfR) ( y(4,:)-UCIDa' )./y(4,:) ]);
%E= mean ([ ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2))  ( y(4,:)-UCIDa' )./y(4,:)' ]);


ss = ( test_data_covid_estimate(:,1)-test_data_covid(:,4) )./(test_data_covid_estimate(:,1));
ii = ( test_data_covid_estimate(:,2)-test_data_covid(:,1) )./(test_data_covid_estimate(:,2));
uu = ( test_data_covid_estimate(:,4)-test_data_covid(:,3) )./(test_data_covid_estimate(:,4));
%ee = ( test_data_covid_estimate(:,3)-test_data_covid(:,3) )./(test_data_covid_estimate(:,3));
tx_dt = [ ss ; ii ; uu ];
rmse_t=  sqrt(mse(tx_dt))
E=  mean(tx_dt)



if acumulada == 1
UCIc = diff(UCI);
UCIr = diff(UCIDa);
Infac = diff(InfR);
InfDar = diff(InfDa);
Infc = diff(Inf);
UCI = [UCIc,UCIc(1,end)];
UCIDa = [UCIr',UCIr(1,end)];
InfR = [Infac,Infac(1,end)];
InfDa =[InfDar',InfDar(1,end)]; 
Inf =[Infc,Infc(1,end)];
else
UCIc = UCI;
UCIr = UCIDa;
Infac = InfR;
InfDar =InfDa;    
end
figure
hold on
plot(UCIc)
hold on
plot(UCIr)
figure
hold on
plot(Infac)
hold on
plot(InfDar)



if acumulada == 1

figure
formatSpec = " -%d thetas";
str = compose(formatSpec,numThetas);
titulo = region + str;
%UCIDa=xd(tc+round(tau5),3);
%% Gráficos
%% Para muchos datos graficarlos sólo cada 2 días
I=find( mod(tc,2)==0 );
% I=[1 I length(tc)];
% I=find( mod(tc,2)==0 );
% I=[1 I];
%I=find(tc);
texp=tc(I);
clf
subplot(121)
plot(tg,test_data_covid_estimate(:,2),'--k','LineWidth',2.3)
hold on
plot(tg,f_tmp,'r','LineWidth',0.7)
plot(texp,test_data_covid(I,2),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
maxdata=max([test_data_covid(:,1);f_tmp']);
mindata=min([test_data_covid(:,1);f_tmp']);
maxInf=max(Inf);
minInfR=min(InfR);
maxInfR=max(InfR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('Time (days)')
ylabel('Cases number')
axis([tg(1)-2 tg(end)+2 0.01*min(minInfR,mindata) 1.05*max(maxdata,maxInf)])
%% Para datos acumulados de la RM
%% Cuando no se grafica ya
title(titulo)
lgd=legend('$I$ fitted','$I$ actual','Data I');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
subplot(122)
plot(tg,UCI,'-.k','LineWidth',2.3)
hold on
plot(texp,test_data_covid(I,3),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
title(titulo)
maxdata=max(test_data_covid(:,3));
mindata=min(test_data_covid(:,3));
maxUCI=max(UCI_t);
minUCI=min(UCI_t);
axis([tg(1)-2 tg(end)+2 0.01*min(minUCI,mindata) 1.05*max(maxdata,maxInf)])
lgd=legend('$UCI$ fitted','Data UCI');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
shg
end

figure
formatSpec = " -%d thetas";
str = compose(formatSpec,numThetas);
titulo = region + str;
%UCIDa=xd(tc+round(tau5),3);
%% Gráficos
%% Para muchos datos graficarlos sólo cada 6 días
I=find( mod(tc,4)==0 );
% I=[1 I length(tc)];
% I=find( mod(tc,2)==0 );
% I=[1 I];
%I=find(tc);
texp=tc(I);
clf
subplot(121)
plot(tg,InfR,'--k','LineWidth',2.3)
hold on
plot(tg,Inf,'r','LineWidth',0.7)
plot(texp,InfDa(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
maxdata=max(InfDa);
mindata=min(InfDa);
maxInf=max(Inf);
minInfR=min(InfR);
maxInfR=max(InfR);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('Time (days)')
ylabel('Cases number')
axis([tg(1)-2 tg(end)+2 0.01*min(minInfR,mindata) 1.05*max(maxdata,maxInf)])
%% Para datos acumulados de la RM
%% Cuando no se grafica ya
title(titulo)
lgd=legend('$I$ fitted','$I$ actual','Data I');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
subplot(122)
plot(tg,UCI,'-.k','LineWidth',2.3)
hold on
plot(texp,UCIDa(I),'sb','MarkerEdgeColor','b',...
    'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',5);
title(titulo)
maxdata=max(UCIDa);
mindata=min(UCIDa);
maxUCI=max(UCI);
minUCI=min(UCI);
axis([tg(1)-2 tg(end)+2 0.01*min(minUCI,mindata) 1.05*max(maxdata,maxInf)])
lgd=legend('$UCI$ fitted','Data UCI');
set(lgd,'Location','northwest','Interpreter','latex','FontSize',10)
shg