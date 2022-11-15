function [c, ceq] = simple_constraint(p_op)
%SIMPLE_CONSTRAINT Nonlinear inequality constraints.


%    x(1)*x(2) + x(1) - x(2) + 1.5 <= 0  (nonlinear constraint)
%    10 - x(1)*x(2) <= 0                 (nonlinear constraint)
%    0 <= x(1) <= 1                      (bound)
%    0 <= x(2) <= 13                     (bound)
%   Copyright 2005-2007 The MathWorks, Inc.

% c = [1.5 + x(1)*x(2) + x(1) - x(2); 
%      -x(1)*x(2) + 10];
%_________________

%    -p_op(1) + p_op(2) <= 0  (nonlinear constraint)
%    p_op(1) + p_op(2) + p_op(3) + p_op(4) + p_op(5) + p_op(6) - 1 <= 0                 (nonlinear constraint)
%    0 <= x(1) <= 1                      (bound)
%    0 <= x(2) <= 13                     (bound)
%   Copyright 2005-2007 The MathWorks, Inc.

% c = [-p_op(1) + p_op(2); % I > R
%     p_op(1) + p_op(2) + p_op(3) + p_op(4) + p_op(5) + p_op(6) - 1;% suma 1
%     -p_op(1) + p_op(6); % I > ingresos_UCI
%      p_op(5) - p_op(6)]; % recuperados UCI < UCII

% c = [-p_op(1) + p_op(2); 
%     p_op(1) + p_op(2) + p_op(3) + p_op(4) + p_op(5) + p_op(6) - 1;
%     -p_op(1) + p_op(6); 
%      p_op(5) - p_op(6)]; 

% c = [-p_op(1) + p_op(2); % I > R
%     p_op(1) + p_op(2) + p_op(3) + p_op(4) + p_op(5) + p_op(6) - 1;% suma 1
%     -p_op(1) + p_op(6); % I > ingresos_UCI
%     -p_op(1) + p_op(3); % I > SR
%     -p_op(1) + p_op(4); % I > RS
%      p_op(5) - p_op(6)]; % recuperados UCI < UCII


% c = [-p_op(1) + p_op(2);
%      -p_op(1) + p_op(3); 
%      -p_op(1) + p_op(4);
%      -p_op(1) + p_op(5); 
%      -p_op(1) + p_op(6);
%      -p_op(6) + p_op(5);
%       p_op(1) + p_op(2) + p_op(3) + p_op(4) + p_op(5) + p_op(6) - 1]; % recuperados UCI < UCII
% % No nonlinear equality constraints:

% c = [-p_op(1) + p_op(2);
%      -p_op(1) + p_op(3); 
%      -p_op(1) + p_op(4);
%      -p_op(1) + p_op(5); 
%      -p_op(1) + p_op(6);
%      -p_op(6) + p_op(5)]; % recuperados UCI < ingresos UCI
% % No nonlinear equality constraints:
% c = [-p_op(1) + p_op(3); 
%      -p_op(1) + p_op(4);
%      -p_op(1) + p_op(5); 
%      -p_op(1) + p_op(6);
%      -p_op(6) + p_op(5)]; % recuperados UCI < ingresos UCI

c = [-p_op(1) + p_op(3); 
    -p_op(1) + p_op(4);
    -p_op(1) + p_op(5); 
    -p_op(1) + p_op(6)]; 
% No nonlinear equality constraints:
ceq = [];