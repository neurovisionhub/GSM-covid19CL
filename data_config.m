%addpath ./calls
%addpath ./data
format short e
global traza nGammas globalPais globalUCImovil interpolacion cont %grafica_data
grafica_data
cont=0;
%%  Para experimentos ad-hoc / vacunas / comunales / simulación
% config

%% Graficas muestren los ejes correctamente 
%% Datos del ajuste
%% Datos de la predicción

%% ventana 7 errores relativos inicial (12000.0)
region = 'Metropolitana'; % 
%region = 'Atacama'
%region = 'Arica y Parinacota'
%region = 'Biobío'
%region = 'Valparaíso'
%region = 'Araucanía'
%region = 'Los Ríos'
%region = 'Los Lagos'
%region = 'Aysén'
%region = 'Magallanes'
%region = 'Ñuble'
%region = 'all_test'

%% globalPais = 1 <- chile (suma de datos regionales & desconocido, si es null se asigna 0) 
globalPais = 0;
%% globalUCImovil = 1 <- ingreso movil nacional chileno 
globalUCImovil = 0; 

%% AJUSTE DE CURVAS
interpolacion = 1;
%% interpolacion = 1 <- se interpola y luego se aplica modelo SIER de test sobre un subconjunto pequeño de puntos esto para en fase dde experimentación, 

%% for short experiment percentPrunning < 1
percentPrunning = 1; %   1 > values > 0 is percentage of data 

%% Aproximacion sobre curva acumulada
acumulada = 0;

%% TRAZA OPTIMIZER
traza = 0;

%% INTERVALO DE ESTUDIO
ventana_general=14;
diaInicio = 280;
diaFinEstudio = 530;
nF=84;
diaFin=diaFinEstudio-nF;

loadData2022

%% TAREA POR REALIZAR: Implementar para todas las regiones idea general de usar una proporcion de UCIs ingresados proporcional a razon de 
%% UCIs internados regionales / UCIs internados nacionales


%% AJUSTE DE CURVAS

I=aI_day_movil';
R=aR_day_movil';
F=aF_day_movil';
%[aF_day_movil] = mediamovil(F,ventana);
U=aU_day_movil';
ajuste_pruning



%% En caso de trabajar con datos ajustados y curvas acumuladas
Is = cumsum(I);
Rs = cumsum(R);
Us = cumsum(U);
Fs = cumsum(F);
xds=[Is Rs Fs+Us];
xd=[I R U+F];
if grafica_data == 1
figure;plot(xds,'DisplayName','xds')
figure;plot(xd,'DisplayName','xd')
end

%xd=[I R+F U];

if acumulada ==1
xd=xds;
end

