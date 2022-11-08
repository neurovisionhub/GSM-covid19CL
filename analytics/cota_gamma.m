gamma = gamma + gamma*0.5;

%gamma = 0.02
delta_gamma = 0.00005
value_gamma = [];
errores_gamma = [];
select_gamma = 10000;
cota_error = 10000;
for i=1:1000
    i
all_blocks_params_model_analytics_hibridas    
p=p0;
compute_curves_error
 if isnan(E)
     E=9999999999
       gamma = gamma - delta_gamma*10

    % break
 end
errores_gamma = [errores_gamma,E];
if E < cota_error && E > 0
   cota_error = E;
   select_gamma= gamma;
end
value_gamma = [value_gamma,gamma];
if gamma <= delta_gamma*delta_gamma
break
end
E
gamma = gamma - delta_gamma
end