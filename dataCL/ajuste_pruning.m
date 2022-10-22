global interpolacion;



%%TEST
if interpolacion == 1
interpPruning;
searchpointIni = diaInicio/size(aI_day_movil,2);
searchpointFin = diaFin/size(aI_day_movil,2);
diaInicio=ceil(searchpointIni*size(I,1));
diaFin=ceil(searchpointFin*size(I,1));

end