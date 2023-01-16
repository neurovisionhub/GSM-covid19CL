
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




plot(incidenciaenvacunados.personas_con_una_dosis)
plot(incidenciaenvacunados.personas_con_pauta_completa)
plot(incidenciaenvacunados.personas_con_refuerzo)

legend('no vaccination','one dose','two dose',"dos_dosis_comp_casos")


