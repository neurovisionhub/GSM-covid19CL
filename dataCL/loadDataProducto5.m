function [TotalesNacionalesT,Fallecidos_Acumulados,Infectados_Acumulados,Recuperados_Acumulados] = loadDataProducto5(filename, dataLines)
%IMPORTFILE Import data from a text file
%  TOTALESNACIONALEST = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  TOTALESNACIONALEST = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  TotalesNacionalesT = importfile(".\producto5\TotalesNacionales_T.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 30-Oct-2022 16:27:46

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 22);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Fecha", "CasosNuevosConSintomas", "CasosTotales", "CasosRecuperados", "Fallecidos", "CasosActivos", "CasosNuevosSinSintomas", "CasosNuevosTotales", "CasosActivosPorFD", "CasosActivosPorFIS", "CasosRecuperadosPorFIS", "CasosRecuperadosPorFD", "CasosConfirmadosRecuperados", "CasosActivosConfirmados", "CasosProbablesAcumulados", "CasosActivosProbables", "CasosNuevosSinNotificar", "CasosConfirmadosPorAntigeno", "CasosConSospechaDeReinfeccion", "CasosNuevosConfirmadosPorAntigeno", "FallecidosConfirmadosTotales", "FallecidosSospechososProbablesUOtrosTotales"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["CasosConfirmadosPorAntigeno", "CasosConSospechaDeReinfeccion", "CasosNuevosConfirmadosPorAntigeno", "FallecidosConfirmadosTotales", "FallecidosSospechososProbablesUOtrosTotales"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["CasosConfirmadosPorAntigeno", "CasosConSospechaDeReinfeccion", "CasosNuevosConfirmadosPorAntigeno", "FallecidosConfirmadosTotales", "FallecidosSospechososProbablesUOtrosTotales"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Fecha", "InputFormat", "yyyy-MM-dd");

% Import the data
TotalesNacionalesT = readtable(filename, opts);

Fallecidos_Acumulados = TotalesNacionalesT.Fallecidos;
Infectados_Acumulados = TotalesNacionalesT.CasosTotales;
Recuperados_Acumulados = TotalesNacionalesT.CasosRecuperadosPorFD; % mismo origen de git alternativo
% Infectados_Nuevos_T = TotalesNacionalesT.CasosNuevosTotales;
% Infectados_Nuevos_con_Sintomas = TotalesNacionalesT.CasosNuevosConSintomas;
% Infectados_Activos = TotalesNacionalesT.CasosActivos;
% Infectados_Nuevos_sin_Sintomas = TotalesNacionalesT.CasosNuevosSinSintomas;
end