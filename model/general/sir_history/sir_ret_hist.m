function v=sir_ret_hist(t,p,N,x0)
v=zeros(4,1);
size_t=size(x0,1);
tramo =1:size_t;
% vi = interp1(x0(:,1),x0(:,2),t,'pchip');
% vr = interp1(x0(:,1),x0(:,3),t,'pchip');
% vu = interp1(x0(:,1),x0(:,4),t,'pchip');


vi = interp1(tramo,x0(:,2),t,'pchip');
vr = interp1(tramo,x0(:,3),t,'pchip');
vu = interp1(tramo,x0(:,4),t,'pchip');
% x0
% t

v(1)=N-vi-vr-vu;
v(2)=vi;
v(3)=vr;
v(4)=vu;
%pause