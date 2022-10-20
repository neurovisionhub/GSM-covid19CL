%global option_model
addpath calls/models
global numTetas;
maxiters = 50;
numThetas=5;
nGammas = numThetas;

%% Model with unique gamma, alfaS and deltaS (constant)
%% option_model = 1
%% local_const_params_model;

%% Model with multiple gamma, alfaS and deltaS (vectors)
%% option_model = 2
%% generic_vectors_params_model;

disp('cargando modelo...')
disp(option_model)

if option_model == 1   
   some_blocks_params_model;
elseif option_model == 2
   all_blocks_params_model
elseif option_model == 3
   example_all_blocks_params_model
%% add others models with ours params
%elseif option modell == X
%    ad_hoc_params_model % personal test model
else
   sprintf('No existe opcion')
   
end
