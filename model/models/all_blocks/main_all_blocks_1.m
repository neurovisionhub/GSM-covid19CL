global nTau contF 
%%%delete(gcp('nocreate'))
%parpool("Processes",20)

%% ** Script para Optimizaci�n por m�nimos cuadrados **
%% Opciones para el solver de optimizaci�n
%maxiters=5;
%options = optimset('UseParallel',true,'Algorithm','trust-region-reflective','Display','iter','MaxIter',maxiters,'TolFun',1e-6,'TolX',1e-10,'MaxFunEvals',40000,'Diagnostics','on');

oldoptions = optimoptions(@lsqnonlin,'UseParallel',true,'Algorithm','trust-region-reflective','Display','iter','MaxIter',maxiters,'TolFun',1e-6,'TolX',1e-10,'MaxFunEvals',40000,'Diagnostics','on')

options = optimoptions(oldoptions)

%delete(gcp)
%parpool('local')
%options = optimset('FinDiffRelStep',1e-4,'Algorithm','trust-region-reflective','Display','iter-detailed','MaxIter',maxiters,'TolFun',1e-17,'TolX',1e-21,'MaxFunEvals',50000);

%options = optimset('FinDiffRelStep',1e-3,'Algorithm','trust-region-reflective','Display','iter-detailed','MaxIter',maxiters,'TolFun',1e-17,'TolX',1e-24,'MaxFunEvals',20000);
%options = optimset('Display','iter','PlotFcns',@optimplotfval);
%% Para Datos de �uble hasta el 02 de sept. se cambia el TolX (norma del paso)
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',2.16e-08,'MaxFunEvals',20000);
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',7.07913e-08,'MaxFunEvals',20000);
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',9.7e-08,'MaxFunEvals',20000);
%% Inicializaci�n de cotas para los par�metros
Lb=ones(size(p0))*1e-5;
Ub=1*ones(size(p0));
%Ub=N*ones(size(p0));
%% ** Seg�n informe conjunto China-OMS, tau1 var�a entre 1 y 14 d�as, con un promedio de 5-6 dias
%% mientras que tau2 var�a entre 7 y 56 d�as, con un promedio de 14 d�as

%% Nueva variante que considera paso de UCI a R
nTau = 6;
%nBetas = 7;
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas];
%% Nuevo 24/09/2022
%p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR]
%pos_a= 3 + nTau;
pos_a = 1;
pos_k = 2;
pos_aC = 3;
%%
Lb(pos_a)=1e-5; Ub(pos_a)=1; %a
Lb(pos_k)=1e-5; Ub(pos_k)=1; %k


Lb(pos_aC)=1e-5; 
if acumulada == 1 
    Ub(pos_aC)=max_data_ini;%max(Data(:,1)); %aC
end

if acumulada == 2 
    Ub(pos_aC)=max_data_ini; %aC
end


if  acumulada == 0
    Ub(pos_aC)=max_data_ini;%max(Data(:,1)); %aC
end


%Lb(pos_aC)=1; 

%% Observacion los tiempos de tau grandes afectan el calculo de derivadas y la estabilidad
%% adfemás en algunos casos se realiza extrapolacion ejmplo con pcchip y se sale de los rangos
%% especificamente donde las derivadas tienden a 0 se produce NAN 0/0 por tanto se debe controlar el 
%% salto en x
%% ideas: intervenir la funcion sir_ret_fun_vac y cuando se detecte un NAN usar un numero grande que
%% no sobrepase el limite de la computadora y si se detecta hacia el 0 uno pequeño cercano a 0 pero no 0
% Lb(1)=1e-5; Ub(1)=1; 
% Lb(2)=1e-5; Ub(2)=1; 
% Lb(3)=1e-5; Ub(3)=1;
% for i=4:4+nTau-1
%     
%     Lb(i)=0.001; Ub(i)=10; 
% end
% % %% No normalizados
Lb(4)=3; Ub(4)=7; %tau1 -> incubacion
Lb(5)=7; Ub(5)=21; %tau2 -> recuperacion
% % %% Debemos encontrar un buen rango pata tau3 (comienzo de la inmunidad desde la vacunación)
Lb(6)=7; Ub(6)=21; %tau3 -> suceptible a recuperado (inmunidad) ojo hay reincidencia pero leve - menos casos UCI?
% % %% Probare un rango de 1-20 días para tau3
% % % Lb(6)=1; Ub(6)=20; %tau3 
Lb(7)=14; Ub(7)=240; %tau4 -> duracion inmunidad
Lb(8)=7; Ub(8)=56; %tau5 -> en UCI
Lb(9)=7; Ub(9)=42; %tau6 -> recuperacion UCI



p=p0;
%% ORIGINALES DE PATRICIO
% % % resnormref=9.7028e-02;% no ad-hoc
% % % tol=5e-2;
% % % %tol=0.214;
% % % r=0.3;
% % % it=0;
% % % maxit=5;
%% EXPERIMENTALES
resnormref=1e-2;
tol=5e-2;
%tol=0.214;
r=0.3;
it=0;
maxit=100;
%abs(r-resnormref)/r
vectorR = [];

cont=0;
contGlobal=0;
%% Nuevo vector p0 con vectores de parametros para ajuste a toda la curva
%% Hipotesis que las tasas de todos los parametros son variables y afectados por la vacuna, donde al optimizar se
%% observara si son cercanos o varias, en que entre olas con o sin vacuna deberian ser diferentes
%p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR];


if traza == 1
disp(p0)


%pause
end

tc=diaInicio:diaFin;
nGammas=numThetas;
%tc=t(1):t(end);
time_range = tc;
%% Los datos son s�lo los infectados activos diarios
if acumulada ~= 2
Data=xd(tc,:);
x0=[tc' Data];
end
% 
% if acumulada == 2
% %original
% % % % tc_a=diaInicio-1:diaFin-1;
% % % % Data=xd(tc_a,:);
% % % % Data(:,1)= diferenciasDiarias(Data(:,1)');
% % % % Data(:,2)= diferenciasDiarias(Data(:,2)');
% % % % Data(:,3)= diferenciasDiarias(Data(:,3)');
% 
% 
% % tc_a=diaInicio-1:diaFin;
% % Data=xd(tc_a,:);
% % Data(:,1)= diferenciasDiarias(Data(:,1)');
% % Data(:,2)= diferenciasDiarias(Data(:,2)');
% % Data(:,3)= diferenciasDiarias(Data(:,3)');
% % 
% % x0=[tc' Data];
% 
% end

v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2)-xd(diaInicio,3);
    Data(1,1);Data(1,2);Data(1,3)];
vectorInicial = v_ini;

tc_t=1:size(x0,1);

for it=0:maxit
   if abs(r-resnormref)/r<tol
       disp('abs(r-resnormref)/r<tol');
       break;
   end

   if abs(r)<=0.001
      disp('abs(r)<=0.001');
       break;
   end

   if funEvals<=contF
       disp('funEvals<=contF');
       break;
   end
contF
%while (abs(r-resnormref)/r>tol)&&(it<maxit)
    %[p,r,~,~,~,~,jac]=lsqnonlin(@(p) ESIR_rel(p,tc,Data,x0,N),p0,Lb,Ub,options);
%disp(p')
%disp(x0);
   [p,r,~,~,~,~,jac]=lsqnonlin(@(p) ESIR_rel_all(p,tc_t,Data,x0,N,v_ini,acumulada),p0,Lb,Ub,options);
   %  [p,r,~,~,~,~,jac]=fmincon(@(p) ESIR_rel(p,tc,Data,x0,N),p0,Lb,Ub,options);
    p0=p
    r0=r;
    %it=it+1;
    %r
    %abs(r-resnormref)/r
    %tol
    cont
    vectorR = [vectorR,r];
    
    if cont==5
        coefVar = std(vectorR)/mean(vectorR)
        vectorR = vectorR(1,2:5);
        cont=4;
        if coefVar < 0.01
            salida = "Parando..."
            break; 
        end
        
    end
 
    cont=cont+1;
    contGlobal=contGlobal+1
end
format short e
%disp('p=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammas_R]:');
%disp(p')
disp('Valor mínimo del error:');
disp(r)
compute_curves


