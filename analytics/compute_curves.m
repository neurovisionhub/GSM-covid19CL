
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

%taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%all_taus = taus;
% %% Para variante donde gammaUCI está directamente en la fc. obj.
% all_taus = [tau1,tau2,tau3,tau4]';
nTau=length(all_taus);
tg=tc;
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
fr=sigmoide_all(p,y(2,:),nTau);
% %% Para la variante donde los UCI van en el target
% gammasU= p(12:12+nGammas-1)'; %de posicion 4 a nTau
% tUCI = linspace(tc(1),tc(end),numel(gammasU)) ;
% gammasUCI = interp1(tUCI,gammasU,tc);
% UCI = gammasUCI.*fr.*Inf;
%%
InfR = fr.*Inf;
InfDa=Data(:,1);
UCIDa=Data(:,3);
%figure
salida = [InfDa,InfR',UCIDa,UCI'];

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