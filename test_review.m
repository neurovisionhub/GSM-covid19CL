x_test = data_pais;

x_sum = [];
salto=7;
indices = 1:salto:size(x_test,1);

[f,c] = size(indices)
inicio_x=1
fin_x=salto
for i=1:c-1

suma = sum(x_test(inicio_x:fin_x-1,1))
x_sum = [x_sum,suma];
inicio_x=indices(1,i)
fin_x=indices(1,i+1)-1
end
inicio_x=fin_x+1
fin_x=size(x_test,1)




figure;
plot(incidenciaenvacunados.sin_vac_casos)
hold on
plot(incidenciaenvacunados.una_dosis_casos)
%legend('one dose')
plot(incidenciaenvacunados.dos_dosis_casos)
plot(incidenciaenvacunados.dos_dosis_comp_casos)
%legend('no vaccination')
plot(incidenciaenvacunados.dosis_ref_comp_casos)
plot(incidenciaenvacunados.sin_vac_uci)
plot(incidenciaenvacunados.una_dosis_uci)
plot(incidenciaenvacunados.dos_dosis_uci)
plot(incidenciaenvacunados.dos_dosis_comp_uci)
plot(incidenciaenvacunados.dosis_unica_uci)
plot(incidenciaenvacunados.dosis_unica_comp_uci)
plot(incidenciaenvacunados.dosis_ref_comp_uci)
plot(incidenciaenvacunados.sin_vac_fall)
plot(incidenciaenvacunados.una_dosis_fall)
plot(incidenciaenvacunados.dos_dosis_fall)
plot(incidenciaenvacunados.dos_dosis_comp_fall)
plot(incidenciaenvacunados.dosis_unica_fall)
plot(incidenciaenvacunados.dosis_unica_comp_fall)
plot(incidenciaenvacunados.dosis_ref_comp_fall)
labels_grafico = {'no vaccination',...
    'one dose','two dose','dos dosis comp casos',...
    'dosis ref comp casos','sin vac uci','una dosis uci','dos dosis uci','dos dosis comp uci',...
    'dosis unica uci','dosis unica comp uci','dosis ref comp uci','sin vac fall',...
    'una dosis fall','dos dosis fall','dos dosis comp fall','dosis unica fall',...
    'dosis unica comp fall','dosis ref comp fall'}

legend(labels_grafico)


