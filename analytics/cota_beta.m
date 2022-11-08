delta_beta = 0.0005
value_beta = [];
errores = [];
select_beta = 10000;

cont_flag=0;


for i=1:1000
        i
    all_blocks_params_model_analytics_hibridas   
    p=p0;
    compute_curves_error
    if isnan(E)
        E=9999999999
        beta = beta - delta_beta*10
        gamma
       % break
    end
    errores = [errores,E];
    if E < cota_error && E > 0
       cota_error = E;
       select_beta = beta;
    end
    value_beta = [value_beta,beta];
    if beta <= delta_beta*0.0001
        break
    end
    E
    beta = beta - delta_beta
end

%errores
