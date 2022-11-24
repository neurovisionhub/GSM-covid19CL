% tabla_errores = table(Region)
% Region{i,1} = region;
% erroresTags = cell(4,1);
erroresTags = {'Susceptible*';'Infected';'Recovered';'ICU Internships'};
errores = [Ess;Eii;Err;Euu];
tabla_errores = table(erroresTags,errores)
% taus_results % TAUS
tausTags = {'Tau1';'Tau2';'Tau3';'Tau4';'Tau5';'Tau6'};
tabla_taus = table(tausTags,params_taus_ini,taus_results)
% params_exp % a,k,aC
params_Tags = {'a';'k';'aC'};
tabla_params_exp= table(params_Tags,params_exp_ini,params_exp)
% params_results % beta, gamma, alfa, delta, gammaU, gammaR

params_Tags = {'beta'; 'gamma'; 'alfa'; 'delta';'gammaU'; 'gammaR'};
tabla_params_sum_tasas = table(params_Tags,params_tasas_ini,params_results)

estimaciones_ro = {'ro_basico';'ro_basico_st'}
tabla_ro = table(estimaciones_ro,[ro_basico;ro_basico_st])

vector_p = {'p0';'pn';'varP'}
variacion_p =(p_inicial./p);
tabla_p_final = table(vector_p,[p_inicial';p';variacion_p'])


hiperparametros_tags = {'globalPais';'globalUCImovil';'diaInicio';'diaFinEstudio';'ventana';'acumulada';'maxGlobal';'meanGlobal';'T'};
hiperparametros_values = table(hiperparametros_tags,[globalPais,globalUCImovil,diaInicio,diaFinEstudio,ventana,acumulada,maxGlobal,meanGlobal,numThetas]')



