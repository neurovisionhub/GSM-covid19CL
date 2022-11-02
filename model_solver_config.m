global numThetas nGammas 
addpath (genpath('calls/models'))
option_model
nGammas = numThetas;

%% Model with unique gamma, alfaS and deltaS (constant)
%% option_model = 1
%% some_blocks_params_model;

%% Model with multiple gamma, alfaS and deltaS (vectors)
%% option_model = 2
%% all_blocks_params_model;

disp('cargando modelo...')
disp(option_model)

if option_model == 1   
   sprintf('Go some_blocks_params_model')
   some_blocks_params_model;

elseif option_model == 2
    sprintf('Go all_blocks_params_model')
    all_blocks_params_model
   
elseif option_model == 3
   example_all_blocks_params_model
%% add others models with ours params
%elseif option modell == X
%    ad_hoc_params_model % personal test model
else
   sprintf('No existe opcion')
   
end
