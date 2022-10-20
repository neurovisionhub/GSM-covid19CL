<<<<<<< HEAD
%% -------- Description of the programa params ---------
% --- grafica_data : muestra graficos de datos cargados (no:0. yes:1)
% ej. grafica_data = 0;
% --- grafica_ajustes : muestra graficos de datos ajustados (no:0. yes:1)
% ej. grafica_ajustes = 0;

global grafica_data grafica_ajustes

%% data_config : file data config (see file for more details)   
%  region selection / type UCI / smoothing / 
%  size movile screen / prunning / daily or acum / 
%  init day & final day study

%% model_solver_config : file model solver config (see file for more details)
%  maxiters optimizer / size vector of the params(time) 
%  assing option_model 
% --- Model with unique gamma, alfaS and deltaS (constant)
% option_model = 1 => local_const_params_model;
% --- Model with multiple gamma, alfaS and deltaS (vectors)
% "option_model = 2" => generic_vectors_params_model;

clear
close all
option_model = 2
grafica_data = 1;
grafica_ajustes = 0;

data_config % call data_config
model_solver_config % call model_solver_config

call_solver % call numeric method & optimizer


