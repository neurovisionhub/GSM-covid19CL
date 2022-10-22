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
primero = 0
% example 2
maxiters = 10;
numThetas=10;

% %ok
% region = 'Metropolitana'
% data_config
% model_solver_config 
% main_all_blocks_1
% save_log('main_all_blocks_1_Metropolitana-v3b',p0)
% save_log('error_1-Metropolitana-v3b',r)
% compute_curves
% save_log('curves_1-Metropolitana-v3b',salida)
% pUltimo=p0;
% primero = 1
% 
% %ok
% region = 'Valparaíso'
% data_config
% model_solver_config 
% main_all_blocks_1
% save_log('main_all_blocks_1-Valparaiso-v3b',p0)
% save_log('error_1-Valparaiso-v3b',r)
% compute_curves
% save_log('curves_1-Valparaiso-v3b',salida)
% pUltimo=p0;

%fallo sobre diff - ok sobre acumulada
region = 'Biobío'
data_config
model_solver_config 
main_all_blocks_1
save_log('main_all_blocks_1-Biobío-v3b',p0)
save_log('error_1-Biobío-v3b',r)
compute_curves
save_log('curves_1-ultimo-v3b',salida)
pUltimo=p0;


% %fallo sobre diff - ok sobre acumulada
% region = 'Arica y Parinacota'
% data_config
% model_solver_config 
% main_all_blocks_1
% save_log('main_all_blocks_1-Araucan-v3b',p0)
% save_log('error_1-Araucan-v3b',r)
% compute_curves
% save_log('curves_1-Araucan-v3b',salida)
% pUltimo=p0;
%fallo sobre diff - ok sobre acumulada
% region = 'Araucanía'
% data_config
% model_solver_config 
% main_all_blocks_1
% save_log('main_all_blocks_1-Araucan-v3b',p0)
% save_log('error_1-Araucan-v3b',r)
% compute_curves
% save_log('curves_1-Araucan-v3b',salida)
% pUltimo=p0;

