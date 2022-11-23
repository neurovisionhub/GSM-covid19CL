function [VALUE,ISTERMINAL,DIRECTION] = EVENTS(t,y,z)
persistent count
if isempty(count)
    count = 0;
end
count = count + 1;
VALUE = 0;
DIRECTION = 0;
ISTERMINAL = (count == 1e4);
end