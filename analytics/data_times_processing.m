%loadData2022_analysis
grafica_data=0;
warning('off')
stringPath = '';
global globalPais grafica_data ventana_general
grafica=grafica_data;
if globalPais == 1
N = 19212362;
end
revisados = 0;
fechas_iniciales = [];
fechas_finales = [];
datos_metadata = []; 
pivot = datetime(2020,3,3,0,0,0,'TimeZone','America/Santiago');
%% Infectados por comuna desde el 2020-03-30 to 2022-10-28
[Poblaciones,iRegion,ipais,idist,iT,iDstring,iDtable,iDdouble] = loadDataProducto1(region,grafica,stringPath);
N=sum(Poblaciones);

idist_nacional = iDdouble;
idist_nacional(  idist_nacional(:,5) == 0,: )=[];
t1_ic = datetime(2020,3,30,0,0,0,'TimeZone','America/Santiago');
t2_ic = datetime(2022,10,28,0,0,0,'TimeZone','America/Santiago');
ic = [t1_ic,t2_ic];
dt_ic = caldays(caldiff(ic,'days'))+1;
size_data_i = size(idist_nacional,2)-5;

if (dt_ic ~= size_data_i)
    disp('Es necesario interpolar infectados comunales para proyectar y comparar curvas de manera diaria & anual!')
    %dt_ic
    %size_data_i
    revisados=revisados+1;
else
 %   disp('Dimensiones de infectados comunales diario ok!')    
     fprintf('Dimensiones de infectados comunales diario ok - > %d días \n',dt_ic);
end

fechas_iniciales = [fechas_iniciales,t1_ic];
fechas_finales = [fechas_finales,t2_ic];
datos_metadata = [datos_metadata,string('Infectados Comunas - ANID')];


%% fallecidos nacional comunas 2020-06-12 to 2022-10-28
[PoblacionesF,FRegion,Fpais,Fdist,fT,fDstring,fDtable,fDdouble] = loadDataProducto38(region,grafica,stringPath);

fdist_nacional = fDdouble;
fdist_nacional(  fdist_nacional(:,5) == 0,: )=[];
fdist_nacional(  fdist_nacional(:,4) == 0,: )=[];
t1_fc = datetime(2020,6,12,0,0,0,'TimeZone','America/Santiago');
t2_fc = datetime(2022,10,28,0,0,0,'TimeZone','America/Santiago');
fc = [t1_fc,t2_fc];
dt_fc = caldays(caldiff(fc,'days'))+1;
size_data_f = size(fdist_nacional,2)-5;

if (dt_fc ~= size_data_f)
    disp('Es necesario interpolar fallecidos comunales para proyectar y comparar curvas de manera diaria & anual!')
   % dt_fc
   % size_data_f
    revisados=revisados+1;
else

        fprintf('Dimensiones de fallecidos comunales diario ok - > %d días \n',dt_fc);
end

fechas_iniciales = [fechas_iniciales,t1_fc];
fechas_finales = [fechas_finales,t2_fc];
datos_metadata = [datos_metadata,string('Fallecidos Comunas - ANID')];


%% FALLECIDOS regionales desde el 22 de marzo 2020 - 29 de octubre 2022
[PoblacionesF0,f0Region,f0pais,f0dist,f0T,f0string,f0table,f0double] = loadDataProducto14(region,0,stringPath);

f0dist_nacional_regional = f0pais; % totales regiones
f0dist_nacional = sum(f0dist_nacional_regional); % total pais
t1_f0 = datetime(2020,3,22,0,0,0,'TimeZone','America/Santiago');
t2_f0 = datetime(2022,10,29,0,0,0,'TimeZone','America/Santiago');
f0 = [t1_f0,t2_f0];
dt_f0 = caldays(caldiff(f0,'days'))+1;
size_data_f0 = size(f0dist_nacional,2);

if (dt_f0 ~= size_data_f0)
    disp('Es necesario interpolar fallecidos regional para proyectar y comparar curvas de manera diaria & anual!')
    %dt_f0
    %size_data_f0
    revisados=revisados+1;
else
  %  disp('Dimensiones de fallecidos regional diario ok!')    
        fprintf('Dimensiones de fallecidos regional diario ok - > %d días \n',dt_f0);
end

fechas_iniciales = [fechas_iniciales,t1_f0];
fechas_finales = [fechas_finales,t2_f0];
datos_metadata = [datos_metadata,string('Fallecifos regional - ANID')];

%% en uci desde 01 de 04 2020 Hasta el 29-10-2022 - CON MAYOR CONSISTENCIA
[PoblacionesUCI,UCIRegion,UCIpais,UCIdist,uT,uDstring,uDtable,uDdouble] = loadDataProducto8(region,grafica,stringPath);

udist_nacional_regional = uDdouble(2:end,2:end); % totales regiones
udist_nacional = sum(udist_nacional_regional(:,3:end)); % total pais
t1_ur = datetime(2020,4,1,0,0,0,'TimeZone','America/Santiago');
t2_ur = datetime(2022,10,29,0,0,0,'TimeZone','America/Santiago');
ur = [t1_ur,t2_ur];
dt_ur = caldays(caldiff(ur,'days'))+1;
size_data_ur = size(udist_nacional);

dist_pivot =[pivot,t1_ur];
dist_pivot_days = caldays(caldiff(dist_pivot,'days'))+1

UCIRegion = [zeros(1,dist_pivot_days),UCIRegion];
UCIpais = [zeros(1,dist_pivot_days),UCIpais];
u_data = [UCIRegion;UCIpais];
plot(u_data')

if (dt_ur ~= size_data_ur)
    disp('Es necesario interpolar uci regional para proyectar y comparar curvas de manera manera diaria & anual!')
    dt_ur
    size_data_ur
    revisados=revisados+1;
else
  %  disp('Dimensiones de uci regional diario ok!')    
    fprintf('Dimensiones de totales  uci regional internados diarios ok - > %d días \n',dt_ur);
end

fechas_iniciales = [fechas_iniciales,t1_ur];
fechas_finales = [fechas_finales,t2_ur];
datos_metadata = [datos_metadata,string('UCI regional - ANID')];


%% 3 de 3 2020 Hasta el 19-06-2022 ------------ Git alternativo mapeado por región ------ solo hasta experimentos 30-10-2022 con junio-----------
[covid19chile,I0,R0,F0,U0,T,IC0,RC0,FC0] = loadDataIvanGit(region,grafica,stringPath,globalPais);
t1_covid19chile = datetime(2020,3,3,0,0,0,'TimeZone','America/Santiago');
t2_covid19chile = datetime(2022,6,19,0,0,0,'TimeZone','America/Santiago');
covid19chile_t = [t1_covid19chile,t2_covid19chile];
dt_covid19chile = caldays(caldiff(covid19chile_t,'days'))+1;
size_data_covid19chile = size(I0,2);

if (dt_covid19chile ~= size_data_covid19chile)
    disp('Es necesario interpolar covid19chile-IvanGit para proyectar y comparar curvas de manera diaria & anual!')
    dt_covid19chile
    size_data_covid19chile
    revisados=revisados+1;
else

   % disp('Dimensiones de covid19chile-IvanGit regional diario - internados ok!')    
    fprintf('Dimensiones de totales covid19chile-IvanGit regional ok - > %d días \n',dt_covid19chile);
end

fechas_iniciales = [fechas_iniciales,t1_covid19chile];
fechas_finales = [fechas_finales,t2_covid19chile];
datos_metadata = [datos_metadata,string('Data global - GitIvan')];

%% considerando desde 15 de abril 2020 Hasta el 26-10-2022 - 
IngresosUCIt = importP91("\producto91\Ingresos_UCI_t.csv", [2, 1000]);
t1_ui = datetime(2020,4,15,0,0,0,'TimeZone','America/Santiago');
t2_ui = datetime(2022,10,26,0,0,0,'TimeZone','America/Santiago');
ui = [t1_ui,t2_ui];
dt_ui = caldays(caldiff(ui,'days'))+1;
size_data_ui = size(IngresosUCIt,1);

if (dt_ui ~= size_data_ui)
    disp('Es necesario interpolar IngresosUCIt para proyectar y comparar curvas de manera diaria & anual!')
    dt_ui
    size_data_ui
    revisados=revisados+1;
else
    
    fprintf('Dimensiones de totales IngresosUCIt diario ok - > %d días \n',dt_ui);
end

fechas_iniciales = [fechas_iniciales,t1_ui];
fechas_finales = [fechas_finales,t2_ui];
datos_metadata = [datos_metadata,string('Ingresos UCI Nacional - ANID')];


nf = size_data_ui;

ui_t = [pivot,t1_ui];
dt_ui_t = caldays(caldiff(ui_t,'days'))
tmp = zeros(1,dt_ui_t);
final_t = IngresosUCIt.MediaMvilIngresosAUCIPorCOVID19(end);
i_uci = [tmp, IngresosUCIt.MediaMvilIngresosAUCIPorCOVID19',final_t,final_t,final_t,final_t];

% FC_test = [FC(1,1:nn) + tasaTest*FC(1,1:nn),FC(1,nn+1:end)];





%% datos nacionales desde 02 de marzo 2020 a 29 de octubre 2022 - ANID
[TotalesNacionalesT,Fallecidos_Acumulados,Infectados_Acumulados,Recuperados_Acumulados] = loadDataProducto5("\producto5\TotalesNacionales_T.csv");
t1_nac = datetime(2020,3,2,0,0,0,'TimeZone','America/Santiago');
t2_nac = datetime(2022,10,29,0,0,0,'TimeZone','America/Santiago');
nac = [t1_nac,t2_nac];
dt_nac = caldays(caldiff(nac,'days'))+1;
size_data_nac = size(Fallecidos_Acumulados,1);

if (dt_nac ~= size_data_nac)
    disp('Es necesario interpolar Totales nacionales para proyectar y comparar curvas de manera diaria & anual!')
    dt_nac
    size_data_nac
    revisados=revisados+1;
else
    fprintf('Dimensiones de totales nacionales diario ok - > %d días \n',dt_nac);
    
    
end

fechas_iniciales = [fechas_iniciales,t1_nac];
fechas_finales = [fechas_finales,t2_nac];
datos_metadata = [datos_metadata,string('DATA NACIONAL - ANID')];

%% datos nacionales desde 16 de abril 2020 a 29 de octubre 2022 - ANID - AUSENCIA DE DATOS ALGUNOS DÍAS NECESARIO INTERPOLAR
[CamasHospitalDiarioT,basica,media,uti,uci] = loadDataProducto24("\producto24\CamasHospital_Diario_T.csv");
t1_hospital = datetime(2020,4,16,0,0,0,'TimeZone','America/Santiago');
t2_hospital = datetime(2022,10,29,0,0,0,'TimeZone','America/Santiago');
hospital = [t1_hospital,t2_hospital];
dt_hospital = caldays(caldiff(hospital,'days'))+1;
size_data_hospital = size(uci,1);

if (dt_hospital ~= size_data_hospital)
    disp('Es necesario interpolar Totales hospitalizaciones para proyectar y comparar curvas de manera diaria & anual!')
   dt_hospital
   size_data_hospital
    revisados=revisados+1;
else
    fprintf('Dimensiones de totales hospitalizaciones en estado diario ok - > %d días \n',dt_hospital);
    
    
end

fechas_iniciales = [fechas_iniciales,t1_hospital];
fechas_finales = [fechas_finales,t2_hospital];
datos_metadata = [datos_metadata,string('DATA NACIONAL Hospital - ANID')];

%% Datos del 03 03 2022 pero con datos no null desde 29 de Junio 2020 al 30-10-22 
%% regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};

[Tabla,TotalesRecuperados,TotalesFallecidos,TotalesInfectados,data_region,data_total_pais] = loadDataProducto3("\producto3\TotalesPorRegion.csv",region);
t1_data = datetime(2020,3,3,0,0,0,'TimeZone','America/Santiago');
t2_data = datetime(2022,10,30,0,0,0,'TimeZone','America/Santiago');
data_covid = [t1_data,t2_data];
dt_data = caldays(caldiff(data_covid,'days'))+1;
size_data_data = size(data_region,1);
% Aca se ajustaran los dias iniciales donde no se registran datos
t1_data + days(700)
t1_data + days(749) % 22 de marzo

IC = data_region(:,1)';
RC = data_region(:,2)';
FC = data_region(:,3)';
U  = UCIRegion;
IC_diff_days = diferenciasDiarias(IC)';
RC_diff_days = diferenciasDiarias(RC)';
FC_diff_days = diferenciasDiarias(FC)';

IC_pais = data_total_pais(:,1)';
RC_pais = data_total_pais(:,2)';
FC_pais = data_total_pais(:,3)';
U_pais  = UCIpais;
IC_pais_diff_days = diferenciasDiarias(IC_pais)';
RC_pais_diff_days = diferenciasDiarias(RC_pais)';
FC_pais_diff_days = diferenciasDiarias(FC_pais)';



% DATOS base 
data_region_diff = [IC_diff_days,RC_diff_days,FC_diff_days,U']; 
% DATOS base 
data_pais_diff = [IC_pais_diff_days,RC_pais_diff_days,FC_pais_diff_days,U_pais']; 


figure;plot(log(data_region_diff),'DisplayName','diff_days')
figure;plot(log(data_pais_diff),'DisplayName','data_total_pais')

%figure;plot(log(diff_days),'DisplayName','diff_days')
[salida] = mediamovil(data_total_pais,21);
hold on
plot(log(diff(salida)),'DisplayName','salida')
hold on
plot(log(U),'DisplayName','U')
%% Se producen 2 outlers importantes que se ajustarán impactand en menor medida la funcion acumulada, pero distribuyendo
%% el reporte en meses contiguos al outler, mismo caso para datos faltantes en primeros meses de pandemia, donde se agregaran tasas promedio
%% de meses contiguos para completarr datos (recuperados)

%% Ajustes ad-hoc para primeros meses de pandemia
% Inicio periodo de ajuste
iniAjuste=5;
% Fin periodo de ajuste
finAjuste=150;
ventana = 3;
% Ajuste básico con media movil sobre funcion acumulada
% para suavizar distribución donde se presenta salto discreto grande
[aIC,IC_day,aIC_day,error_aIC] = ajusteI(IC,iniAjuste,finAjuste,ventana);
[aIC_pais,IC_pais_day,aIC_pais_day,error_aIC_pais] = ajusteI(IC_pais,iniAjuste,finAjuste,ventana);

ventana = ventana_general;
[aIC_pais_day_fit] = mediamovil(aIC_pais_day,ventana);
[aIC_day_fit] = mediamovil(aIC_day,ventana);

figure;plot(aIC_day_fit)
hold on
figure;plot(aIC_pais_day_fit)
plot(aIC_day)
%%% ______________ Fin ajuste infectados  ________________________
ventana = ventana_general;
diaPrimerRecs = 7; % dia en que se presenta primer recuperado
[aRC,RC_day,aRC_day,error_aRC] = ajusteR(aIC,RC,diaPrimerRecs);
[aRC_day_fit] = mediamovil(aRC_day,ventana);

ventana = ventana_general;
[aRC_pais,RC_pais_day,aRC_pais_day,error_aRC_pais] = ajusteR(aIC_pais,RC_pais,diaPrimerRecs);
[aRC_pais_day_fit] = mediamovil(aRC_pais_day,ventana);


figure;plot(aRC_day_fit)
hold on
figure;plot(aRC_pais_day_fit)
plot(aRC_day)
%%% ______________ Fin ajuste recuperados  ________________________

%% Afecta mucho los 10 mil agregados de fallecidos , se podria aplicar heuristica de distribuir todos esos fallecidos
%% en toda la pandemia, indicando que se hace para terminos experimentales numericos y no epidemiologicos
%% se calcula la tasa/porcentaje de fallecidos a agregar (apro. 10000 de totales)
%% al 30 de octubre 11660 sospechosos agregados, confirmados 50017, total 61677
% tasaTest_tramo_sin_ajuste = 11660/61677;
%% al 21 de marzo 11349 sospechosos agregados, confirmados 44616, total 55965
% tasaTest =  11349/55965;
nn=748; %en 749 se agregan 6 mil fallecidos - a partir de alli hay que restar los probables
% heuristica h3: agregar proporcionalmente los fallecidos a toda la data -
% se descarta porque se intervienen los datos oficiales
% nf = size(FC,2);
% pivot_local = FC(1,nn);
% dias = pivot + days(nn); 
% FC_test = [FC(1,1:nn) + tasaTest*FC(1,1:nn),FC(1,nn+1:end)];

%% Aca se descartaran de datos de fallecidos los casos probables para así mantener tendencia de data 
%% reportada desde marzo de 2020 

extractDefeatsConfirmed % se procesa data para solo utilizar falleicos confirmados covid (no se agregan probables)
f = f_confirmed;
FC_test = [FC(1,1:nn),f_confirmed(end,:)];

f_pais = f_confirmed_pais;
FC_test_pais = [FC_pais(1,1:nn),f_confirmed_pais(end,:)];

%%% ______________ Fin ajuste fallecidos  ________________________

ventana = ventana_general; %% las olas se presentan en periodos en tre 2.5 a 4 meses - se suavisara la curva pero se mantendra tendencia

[aFC2] = mediamovil(FC_test,ventana);
F = diferenciasDiarias(FC_test);
[aFC_day_fit_2] = diferenciasDiarias(aFC2);

[aFC2_pais] = mediamovil(FC_test_pais,ventana);
F_pais = diferenciasDiarias(FC_test_pais);
[aFC_pais_day_fit_2] = diferenciasDiarias(aFC2_pais);

figure;plot(log(aFC_day_fit_2))
hold on
plot(log(F))
figure;plot(log(aFC_pais_day_fit_2))

% DATOS experimento región
I_analysis = aIC_day_fit;
R_analysis = aRC_day_fit;
F_analysis = aFC_day_fit_2;
[U_analysis] = mediamovil(U,ventana);
%U_analysis = U;

% DATOS experimento país

I_analysis_pais = aIC_pais_day_fit
R_analysis_pais = aRC_pais_day_fit;
F_analysis_pais = aFC_pais_day_fit_2;
[U_analysis_pais] = mediamovil(U_pais,ventana);
%U_analysis_pais = U_pais;

%% Datos usados para aproximar curvas SIER - luego transformar a curvas epidemiologicas diarias.



%%Que la grafica sea por pais, y mientras preparao informe lanzo
%%expeirmentos
% Como se puede observar existe correlación entre las curvas de Ingreso UCI
% (U_I), Internados en UCI  (U_H) y fallecidos F. Esta correlación se
% observa en mayor media entre la cantidad de pacientes internado en
% estado UCI y fallecidos, esto debido a que la mayoria de los fallecidos
% han pasado por el sistema de atención de emergencia del covid (se presume)
data_pais = [I_analysis_pais;R_analysis_pais;F_analysis_pais;U_analysis_pais;i_uci]';
data_region = [I_analysis;R_analysis;F_analysis;U_analysis]';

%tmp = data_pais(1:end-1,:);
tmp = data_region;

I=tmp(:,1)';
R=tmp(:,2)';
F=tmp(:,3)';
%[aF_day_movil] = mediamovil(F,ventana);
U=tmp(:,4)';
pruning_tmp = 1;
interpolacion = 2
ajuste_pruning

%% En caso de trabajar con datos ajustados y curvas acumuladas
Is = cumsum(I);
Rs = cumsum(R);
Us = cumsum(U);
Fs = cumsum(F);
xds=[Is Rs Fs+Us];
xd=[I R U+F];



if acumulada ==1
xd=xds;
end
xd_test = [];
if variante_sier == 1
   S = N - Is - Rs -(Us+Fs);
   %xd = [Is Rs Us+Fs S (Is+Rs+Us+Fs)];
   %S = N - Is - Rs - Fs; % sacando uci movil internado
   xd = [Is Rs Us+Fs S (Is+Rs+Fs) (Is+Rs+Fs+Us)]; % sacando uci movil internado
   %xd = [Is Rs Fs S (Is+Rs+Fs) (Is+Rs+Fs+Us)]; % para test de consistencia en intervalo
end

if grafica_data == 1
figure;plot(xds,'DisplayName','xds')
figure;plot(xd,'DisplayName','xd')
end



% % all_data = [data_region_diff,data,F',i_uci'];
% % graficaDatos(all_data)
% % 
% % 
% all_data = [data_pais,data_region,i_uci'];
% graficaDatos(all_data)




%grafica_data=1












