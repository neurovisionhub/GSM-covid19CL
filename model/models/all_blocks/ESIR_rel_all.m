%% Calculation of the error function for the SIR model with delay
function E = ESIR_rel_all(p,tc,xd,x0,N,vectorIni,opcion_a1)
global  contF 
nTau = 6;
taus = p(4:4+nTau-1)';
vectorInicial = vectorIni;
options = ddeset('RelTol',1e-2,'AbsTol',1e-4,...
                 'InitialY',vectorInicial,'InitialStep',100);
sol = dde23('sir_ret_fun_vac_all',taus,'sir_ret_hist',[tc(1),tc(end)],options,p,N,x0);
y = deval(sol,tc);
a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(y(2,:)-aC) ) );

%Para pre-aproximacion con alfa = 1
%For pre-approximation with alpha = 1
if opcion_a1 == 1
    alfa = 1;
end

v_t = alfa.*y(2,:);
%% Relatives model error & relative UCI error
E= [  ( v_t-xd(:,1)' )./(v_t)   ( y(4,:)-xd(:,3)' )./y(4,:) ]; 
%E= [ (y(1,:)-xd(:,5)' )./y(1,:) (%alfa.*y(2,:)-xd(:,1)')./(alfa.*y(2,:)) ( y(4,:)-xd(:,3)' )./y(4,:) ( y(3,:)-xd(:,2)' )./(y(3,:)) ]; % for experimental test


contF=contF+1;
%% uncomment if performing convergence trace graphically
% if mod(contF,10)==0 
% figure('visible','off');
% %plot(log(alfa.*y(2,:)))
% hold on
% %plot(log(y(2,:)))
% %hold on
% plot(xd(:,1:3));
% %plot(y(1,:)); % S
% plot(alfa.*y(2,:),'-'); % I
% plot(y(2,:),'--'); % I
% %plot(alfa.*y(3,:),'--'); % R
% %plot(y(3,:),'.'); % R
% plot(y(4,:),'-'); % U
% t = datetime;
% t.Format = 'yyyymmddHHMMSS';
% text_log = datestr(t,t.Format);
% sLogpng = strcat('img_trace/',text_log,'_',string(contF),'.png');
% saveas(gcf, sLogpng);
% clf
% end