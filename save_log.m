
function save_log(id_text,x)
formatSpec = "./exps/%s.dat";
str = compose(formatSpec,id_text);
writematrix(x,str)
end
