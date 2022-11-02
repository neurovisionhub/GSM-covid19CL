%addpath ./calls
%addpath ./data
format short e
global numThetas grafica_data
global traza nGammas globalPais globalUCImovil interpolacion cont grafica_data
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

if acumulada ==1
xd=xds;
end
%xd=[I R+F U];


