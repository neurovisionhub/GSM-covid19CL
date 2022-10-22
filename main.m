addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
%% -------- Description of the programa params ---------
% --- grafica_data : muestra graficos de datos cargados (no:0. yes:1)
% ej. grafica_data = 0;
% --- grafica_ajustes : muestra graficos de datos ajustados (no:0. yes:1)
% ej. grafica_ajustes = 0;

%global grafica_data grafica_ajustes

%% data_config : file data config (see file for more details)   
%  region selection / type UCI / smoothing / 
%  size movile screen / prunning / daily or acum / 
%  init day & final day study

%% model_solver_config : file model solver config (see file for more details)
%  maxiters optimizer / size vector of the params(time) 
%  assing option_model 
% --- Model with unique gamma, alfaS and deltaS (constant)
% option_model = 1 => some_blocks_params_model;
% --- Model with multiple gamma, alfaS and deltaS (vectors)
% "option_model = 2" => all_blocks_params_model;

clear
close all
cont=0;
option_model = 2
grafica_data = 0;
grafica_ajustes = 0;

%id_log = 1; % id_log:<id> of index experiments --> on file ej: log_file_p0_values.<1>.dat 

data_config % call data_config
model_solver_config % call model_solver_config

% call_solver % call numeric method & optimizer
% alfa, gamma y delta -> S of model=1
% alfa, gamma y delta -> S(t) of model=2
% or 

%main_some_block  % (model 1 - proposed 1 "M1.ESIR_Rel.Aclouped.0.1")
%save_log('main_some_block',p0)
% main_some_block_iter (model 1 - extension.proposed 1 "M1.ESIR_W_Rel.Desacoupled.0.1") 
%save_log('main_some_block_iter',p0)

% main_all_blocks_1
% save_log('main_all_blocks_1',p0)



