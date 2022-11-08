 clear
addpath (genpath('calls/'))
addpath (genpath('model/'))
addpath (genpath('dataCL/'))
addpath (genpath('exps/'))
addpath (genpath('analytics/'))
addpath (genpath('config/'))
global numThetas grafica_data nCiclos%maxiters option_model grafica_ajustes primero
global h Mv funEvals contF
contF=1
funEvals = 20000;
Mv = struct('cdata', [], 'colormap', []);  %predeclare struct array

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
%region = 'Arica y Parinacota'; % 1
%region = 'Tarapacá' % 2
%region = 'Antofagasta' % 3
%region = 'Atacama' % 4
%region = 'Coquimbo' % 5
%region = 'Valparaíso' % 6
%region = 'Metropolitana' % 7 
%region = 'O Higgins' % 8
%region = 'Maule' % 9 
%region = 'Ñuble' % 10 
%region = 'Biobío' % 11
%region = 'Araucanía' % 12
%region = 'Los Ríos' % 13
%region = 'Los Lagos' % 14
%region = 'Aysén' % 15 
%region = 'Magallanes' % 16

regiones = {'Arica y Parinacota','Tarapacá','Antofagasta','Atacama','Coquimbo','Valparaíso','Metropolitana','O Higgins','Maule','Ñuble','Biobío','Araucanía','Los Ríos','Los Lagos','Aysén','Magallanes'};


close all
cont=0;
option_model = 2
grafica_data = 1;
grafica_ajustes = 0;
primero = 0
% example 2
maxiters = 3;
numThetas=20;
nCiclos = 3 % veces que se reduce beta a la mitad
primera_ola=0
region = 'Metropolitana'

% pre_config_1
% callProcessing

pre_config_1
callPre_Processing
main_all_blocks_1

save_log_data

