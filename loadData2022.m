stringPath = '.\data';

global globalPais grafica_data
grafica=grafica_data;
%% Desde github ANID
%% INFECTADOS desde 30 marzo 2020 - Selección
[Poblaciones,iRegion,ipais,idist,iT,iDstring,iDtable,iDdouble] = loadDataProducto1(region,grafica,stringPath);

N=sum(Poblaciones);

if globalPais == 1
N = 19212362;
end

[A, idx] = sort(idist);
sorted_data = idist((idx));

if grafica==1
figure 
surf(A)
figure 
boxplot(A)
figure 
plot(mean(A))
end

%% EN ESTADO UCI desde 01 abril 2020 - Selección
[PoblacionesUCI,UCIRegion,UCIpais,UCIdist,uT,uDstring,uDtable,uDdouble] = loadDataProducto8(region,grafica,stringPath);

%% FALLECIDOS por COMUNA desde 12 junio 2020
[PoblacionesF,FRegion,Fpais,Fdist,fT,fDstring,fDtable,fDdouble] = loadDataProducto38(region,grafica,stringPath);

%% FALLECIDOS regionales desde el 22 de marzo 2020 - Selección

[PoblacionesF0,f0Region,f0pais,f0dist,f0T,f0string,f0table,f0double] = loadDataProducto14(region,0,stringPath);

%N38 = sum(PoblacionesF)
N1 = sum(Poblaciones);
%N8 = sum(PoblacionesUCI)



%% Git alternativo
%% <Fecha,Región,Confirmado,Fallecido,Recuperado,acumConfirmado,acumFallecido,acumRecuperado,S.CasosUCI>
%% RECUPERADOS desde https://github.com/ivanMSC/COVID19_Chile
%% Desde 03-03-2020 Hasta 19-06-2022 (no se da más soporte desde dicha fecha)
%% Además, ya no se mapea recuperados

%% Hasta el 19-06-2022   (15 abril 2020 - fila 732)
[covid19chile,I,R,F,U,T,IC,RC,FC] = loadDataIvanGit(region,grafica,stringPath,globalPais);

%% considerando desde 15 de abril Hasta el 19-06-2022 - hasta fila 898 de producto 91 a nivel nacional
IngresosUCIt = importP91(".\data\producto91\Ingresos_UCI_t.csv", [2, 898]);

%% Para experimento ad-hoc con uci movil de ingresos pero en contexto nacional
%uTmp = U(1,44:end);
%% primeros ingresos uci reportados 17 marzo desde IvanGit
%% {8;19;32;36;29;34;40;43;44;52;81;105;122;138;0;173;200;237;280;307;327;337;362;360;383;383;387;387;379}
%% ajuste ad-hoc
uDev = [8;11;13;12;12;18;18;16;16;24;24;17;16;17;18;27;37;42;27;25;25;27;26;25;25;27;27;28;29;29];
%% UCIs ingresados desde 15 de abril 2020 desde producto 91 primeros 20 dias
%% {28;28;26;24;26;26;30;31;33;33;35;33;32;30;30;29;29;29;32;34}
vTmp = ceil( table2array(IngresosUCIt(:,2)))';
uTmp = [zeros(1,14),uDev',vTmp];
if globalUCImovil == 1
   U = uTmp; 
end

UOriginal = U;
I = I+1e-0;
F = F+1e-0;
U = U(:,1:size(F,2))+1e-0;
R = R+1e-0;




