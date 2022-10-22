
function save_log(id_text,x)
formatSpec = "./exps/log_file_p0_values.%s.dat";
str = compose(formatSpec,id_text);
writematrix(x,str)
end
