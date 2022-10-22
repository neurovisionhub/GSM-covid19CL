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
%region = 'Metropolitana'; % 
%region = 'Atacama'
%region = 'Arica y Parinacota'
%region = 'Biobío'
%region = 'Valparaíso'
%region = 'Araucanía'
%region = 'Los Ríos'
%region = 'Los Lagos'
%region = 'Aysén'
%region = 'Magallanes'
%region = 'Ñuble'
%region = 'all_test'


clear

global numThetas
close all
cont=0;
option_model = 2
grafica_data = 0;
grafica_ajustes = 0;

%id_log = 1; % id_log:<id> of index experiments --> on file ej: log_file_p0_values.<1>.dat 
% region = 'Metropolitana';
% data_config % call data_config
% maxiters = 10;
% numThetas=20;
% model_solver_config % call model_solver_config
% 
% % example 1
% main_all_blocks_1
% save_log('main_all_blocks_1-v20',p0)
% save_log('error_1-v20',r)
% compute_curves
% save_log('curves_1-v20',salida)
% 
% % example 2
% maxiters = 10;
% numThetas=10;
% 
% model_solver_config 
% main_all_blocks_1
% save_log('main_all_blocks_1-v10',p0)
% save_log('error_1-v10',r)
% compute_curves
% save_log('curves_1-v10',salida)



% example 2
maxiters = 10;
numThetas=3;

region = 'Metropolitana'
data_config
model_solver_config 
main_all_blocks_1
save_log('main_all_blocks_1_Metropolitana-v3',p0)
save_log('error_1-Metropolitana-v3',r)
compute_curves
save_log('curves_1-Metropolitana-v3',salida)

region = 'Valparaíso'
data_config
model_solver_config 
main_all_blocks_1
save_log('main_all_blocks_1-Valparaiso-v3',p0)
save_log('error_1-Valparaiso-v3',r)
compute_curves
save_log('curves_1-Valparaiso-v3',salida)

region = 'Ñuble'
data_config
model_solver_config 
main_all_blocks_1
save_log('main_all_blocks_1-nuble-v3',p0)
save_log('error_1-nuble-v3',r)
compute_curves
save_log('curves_1-nuble-v3',salida)


numThetas=10;
data_config
model_solver_config 
main_all_blocks_1
save_log('main_all_blocks_1-nuble-v10',p0)
save_log('error_1-nuble-v10',r)
compute_curves
save_log('curves_1-nuble-v10',salida)
% call_solver % call numeric method & optimizer
% alfa, gamma y delta -> S of model=1
% alfa, gamma y delta -> S(t) of model=2
% or 

%main_some_block  % (model 1 - proposed 1 "M1.ESIR_Rel.Aclouped.0.1")
%save_log('main_some_block',p0)
%main_some_block_iter (model 1 - extension.proposed 1 "M1.ESIR_W_Rel.Desacoupled.0.1") 
%save_log('main_some_block_iter',p0)

% main_all_blocks_1
% save_log('main_all_blocks_1',p0)



