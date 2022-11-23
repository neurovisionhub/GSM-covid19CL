
clear
global globalPais grafica_data ventana_general globalUCImovil flagpause numThetas
grafica_data=0 
globalPais = 0;
flagpause=0; %for pause on visualization
% globalUCImovil = 1 <- ingreso movil nacional chileno 
globalUCImovil = 0; % si se utiliza ingreso movil se ajusta mejor el final de la curva desde el inicio de optimizacion 
diaInicio = 50
diaFinEstudio = 440
ventana_general=31;
matrix_results = [];
regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};
%global_time_op=tic;
region = 'Metropolitana'

size_regiones = size(regiones,2)
Region = cell(size_regiones,1);
total_days = [];

% error_aIC_pais_14days = 12; % 2.5e-06 (menor al 1% de error )
% error_aRC_pais_14days = 7522; % 4.2e-3 (menor al 1% de error)
% 

 % Ess=  mean(ss)
% Eii=  mean(ii)
% Err = mean(rr)
% Euu=  mean(uu)


acumulada = 1;
maxGlobal = 0; % en acumulada 1
meanGlobal = 0; % en acumulada 1
mediana = 0;
test_paper_build_tables
numThetas = 20

errores = [Ess;Eii;Err;Euu];
% taus_results % TAUS
% params_exp % a,k,aC
% params_results % beta, gamma, alfa, delta, gammaU, gammaR



% for i=1:size_regiones
% 
% region = regiones{i};
% Region{i,1} = region;
% 
% % test_paper_build_tables
% % 
% % 
% % 
% % 
% % rmse_t=  sqrt(mse(tx_dt))
% % E=  mean(tx_dt)
% % Ess=  mean(ss)
% % Eii=  mean(ii)
% % Err = mean(rr)
% % Euu=  mean(uu)
% % Error_rr_fr=  mean(rr_fr)
% % Error_ii_fr=  mean(ii_fr) 
% % % etiquetas_orizontal = {'ER_m(S)';'ER_m(I)';'ER_m(R)';'ER_m(UCI)'};
% % % table
% % % 
% 
% 
% 
% end
% tabla_errores = table(Region)



