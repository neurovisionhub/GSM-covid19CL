%% cï¿½lculo de la funciï¿½n error para el modelo SIR con retardo
function E = ESIR_rel_all(p,tc,xd,x0,N,vectorIni,opcion_a1)
% global nTau 
global h Mv contF 
nTau = 6;
% xd
% x0
% pause
%% funciï¿½n de error para modelo SIR con retardo
% % Para beta lineal por tramos
%V = otras;
%tau1=p(2);
%tau2=p(3);
%p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR]
%rangoTaus = 
taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%% Desnormalización para evaluar los taus reales
% taus(1)=13*taus(1)+1;
% taus(2)=20*taus(2)+1;
% %taus(3)=119*taus(3)+1;
% taus(3)=19*taus(3)+1;
% taus(4)=239*taus(4)+1;
% taus(5)=42*taus(5)+14;
% taus(6)=21*taus(6)+21;
%% Variante vacunacion 16-01-2022
%options = ddeset('Jumps',5);
%%menor tol mayor tiempo - para experimentos inciciales usar error alto
%tic

%% Aca ajuste de valor inicial es diferente para uso de funciones acum versus diarias
%% donde en ambos casos la condicion inicial debe corresponder al valor de ACUM en t
% vectorInicial = [N-xd(1,1);xd(1,1);xd(1,2);xd(1,3)];
% vectorInicial = [N-xd(1,1)-xd(1,2)-xd(1,3);xd(1,1);xd(1,2);xd(1,3)];
%vectorInicial = [xd(1,4);xd(1,1);xd(1,2);xd(1,3)];
%options = ddeset('RelTol',1e-2,'AbsTol',1e-4,...
%                 'InitialY',[N;1;1;1]);,'NormControl','on'

vectorInicial = vectorIni;
options = ddeset('RelTol',1e-2,'AbsTol',1e-4,...
                 'InitialY',vectorInicial,'InitialStep',100);
sol = dde23('sir_ret_fun_vac_all',taus,'sir_ret_hist',[tc(1),tc(end)],options,p,N,x0);
y = deval(sol,tc);
%y(isnan(y))=1e+20;
%alfa=sigmoide_all(p,y(2,:),nTau);
tmp = y;
tmpx = xd;
%  if acumulada == 1
%   y(2,:) = diferenciasDiarias(y(2,:));
% %   y(4,:) = diferenciasDiarias(y(4,:));
% %   y(3,:) = diferenciasDiarias(y(3,:));
%   xd(:,1) = diferenciasDiarias(xd(:,1)');
% %   xd(:,3) = diferenciasDiarias(xd(:,3)');
% %   xd(:,2) = diferenciasDiarias(xd(:,2)'); 
%  end
% alfa=sigmoide_all(p,y(2,:),nTau);
a=p(1);
k=p(2);
aC=p(3);

alfa=1-(1-a)./( 1+exp( -k*(y(2,:)-aC) ) );

%Para pre-aproximacion
if opcion_a1 == 1
alfa = 1;
end

alfaMean = mean(alfa);
%alfa=1; %% RECORDAR BORRAR SOLO PARA EXPERIMENTAL DEPENDENCIA
%y(2,:) = tmp(2,:);
%xd(:,1) = tmpx;
%% Sacar comentarios en caso de realizar traza grafica en archivos


v_t = alfa.*y(2,:);
%% Error relativo al modelo considera
%E= [  ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:)) +numRel',  ( y(4,:)-xd(:,3)' )./y(4,:) ];
%%E= abs([  ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:))   ( y(4,:)-xd(:,3)' )./y(4,:) ]);
E= [  ( v_t-xd(:,1)' )./(v_t)   ( y(4,:)-xd(:,3)' )./y(4,:) ]; %para curva diaria acumulada=2
%E= [ ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( alfa.*y(3,:)-xd(:,2)' )./(alfa.*y(3,:)) ]; %acumulada=1
%%%E= [ ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( y(3,:)-xd(:,2)' )./(y(3,:)) ]; %acumulada=1
%E= [ (y(1,:)-xd(:,5)' )./y(1,:)     ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( y(3,:)-xd(:,2)' )./(y(3,:)) ]; %acumulada=1
%E= [ (y(1,:)-xd(:,5)' )./y(1,:)     ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( alfa.*y(3,:)-xd(:,2)' )./(alfa.*y(3,:)) ]; %acumulada=1

% S+I+UCI
%E= [ (y(1,:)-xd(:,5)' )./y(1,:)     ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ]; %acumulada=1



y = tmp;
xd = tmpx;

contF=contF+1;
if mod(contF,10)==0 
figure('visible','off');
%plot(log(alfa.*y(2,:)))
hold on
%plot(log(y(2,:)))
%hold on
plot(xd(:,1:3));
%plot(y(1,:)); % S
plot(alfa.*y(2,:),'-'); % I
plot(y(2,:),'--'); % I
%plot(alfa.*y(3,:),'--'); % R
%plot(y(3,:),'.'); % R
plot(y(4,:),'-'); % U
t = datetime;
t.Format = 'yyyymmddHHMMSS';
text_log = datestr(t,t.Format);
sLogpng = strcat('img_trace/',text_log,'_',string(contF),'.png');
saveas(gcf, sLogpng);
clf
end





%E= [ ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( y(3,:)-xd(:,2)' )./(y(3,:)) ]; %acumulada=1


% E= [ ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:))  ( y(4,:)-xd(:,3)' )./y(4,:) ( y(3,:)-xd(:,2)' )./(y(3,:)) ];
%Para la optimización no lineal con lsnonlineal utilizamos el error
%relativo de alfa*I_s(t) vs I y U_s(t) - U(t)

%E= [ ( y(1,:)-xd(:,4)' )./y(1,:) ( y(2,:)-xd(:,1)')./y(2,:)];
%E= [ ( y(1,:)-xd(:,4)' )./y(1,:) ( y(4,:)-xd(:,3)')./y(4,:) ( alfa.*y(2,:)-xd(:,1)' )./(alfa.*y(2,:))];
% E= [ ( y(1,:)-xd(:,4)' )./y(1,:)];

%E= [  ( y(2,:)-xd(:,1)' )./(y(2,:))   ( y(4,:)-xd(:,3)' )./y(4,:) ];

%E= [  ( y(2,:)-xd(:,1)' )./(y(2,:))   ( y(4,:)-xd(:,3)' )./y(4,:) ];
%E= [  ( y(2,:)-xd(:,1)' )./(xd(:,1))   ( y(4,:)-xd(:,3)' )./xd(:,3) ];
%salidaTest = mean(E)

%E= [ sum( ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:)))/size(xd,1) sum(( y(4,:)-xd(:,3)' )./y(4,:))/size(xd,1)];
%% %%   5.6863e+05 20 thetas 830 60 0.1 no acumulada - movil

%% Error relativo a los datos
%E= [ ( ( alfa.*y(2,:)-xd(:,1)' )./(xd(:,1)) + abs(numRel)') ( y(4,:)-xd(:,3)' )./xd(:,3) ];
%% Valor mínimo del error:
%%   5.7246e+04 5 tethas
%%   3.8215e+05 10 thetas 830 60 0.1 no acumulada - movil
%%   6.0514e+06 10 thetas 830 60 0.1 no acumulada - original
%E=mean(E);
% if isnan(E)
%     salida = 'aparece NAN'
% end

%E= [ ( alfa.*y(2,:)-xd(:,1)' )/N ( y(4,:)-xd(:,3)' )/N ];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )  ( y(4,:)-xd(:,3)' )];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:))];
%E= [  ( y(4,:)-xd(:,3)' )./y(4,:)];
%E= [  ( y(4,:)-xd(:,3)' )./xd(:,3)];
%y(1,:)