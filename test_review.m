global nTau contF 
% x_test = data_pais;
% 
% x_sum = [];
% salto=7;
% indices = 1:salto:size(x_test,1);
% 
% [f,c] = size(indices)
% inicio_x=1
% fin_x=salto
% for i=1:c-1
% 
% suma = sum(x_test(inicio_x:fin_x-1,1))
% x_sum = [x_sum,suma];
% inicio_x=indices(1,i)
% fin_x=indices(1,i+1)-1
% end
% inicio_x=fin_x+1
% fin_x=size(x_test,1)
% 
% 
% 
% 
% figure;
% plot(incidenciaenvacunados.sin_vac_casos)
% hold on
% plot(incidenciaenvacunados.una_dosis_casos)
% %legend('one dose')
% plot(incidenciaenvacunados.dos_dosis_casos)
% plot(incidenciaenvacunados.dos_dosis_comp_casos)
% %legend('no vaccination')
% plot(incidenciaenvacunados.dosis_ref_comp_casos)
% plot(incidenciaenvacunados.sin_vac_uci)
% plot(incidenciaenvacunados.una_dosis_uci)
% plot(incidenciaenvacunados.dos_dosis_uci)
% plot(incidenciaenvacunados.dos_dosis_comp_uci)
% plot(incidenciaenvacunados.dosis_unica_uci)
% plot(incidenciaenvacunados.dosis_unica_comp_uci)
% plot(incidenciaenvacunados.dosis_ref_comp_uci)
% plot(incidenciaenvacunados.sin_vac_fall)
% plot(incidenciaenvacunados.una_dosis_fall)
% plot(incidenciaenvacunados.dos_dosis_fall)
% plot(incidenciaenvacunados.dos_dosis_comp_fall)
% plot(incidenciaenvacunados.dosis_unica_fall)
% plot(incidenciaenvacunados.dosis_unica_comp_fall)
% plot(incidenciaenvacunados.dosis_ref_comp_fall)
% labels_grafico = {'no vaccination',...
%     'one dose','two dose','dos dosis comp casos',...
%     'dosis ref comp casos','sin vac uci','una dosis uci','dos dosis uci','dos dosis comp uci',...
%     'dosis unica uci','dosis unica comp uci','dosis ref comp uci','sin vac fall',...
%     'una dosis fall','dos dosis fall','dos dosis comp fall','dosis unica fall',...
%     'dosis unica comp fall','dosis ref comp fall'}
% 
% legend(labels_grafico)

%% generation videos
%close all
clear M
%M = struct;
% Animation Jacobian 
v = VideoWriter('Jacobian_left.mp4','Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 2; 
open(v); 
k0=size(mJacobianFull_left,2);
f = figure;
px = uipanel(f,"Position",[0 0 1 1],...
    "BackgroundColor","w");
ax = axes(px); 
loops = k0;
M(loops) = struct('cdata',[],'colormap',[]);
for k = 1:k0
    mesh(mJacobianFull_left{1, k}','FaceAlpha','0.15',FaceColor = 'interp')
    ax = gca;
    c = ax.Color;
    
    ax.View = [20 5];
    
    u.Value = k;
    M(k) = getframe(gcf);
    writeVideo(v,M(k))
end
figure;
axes("Position",[0 0 1 1])
movie(M)
close(v)

clear M
%M = struct;
% Animation Jacobian 
v = VideoWriter('Jacobian_right.mp4','Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 2; 
open(v); 
k0=size(mJacobianFull_right,2);
f = figure;
px = uipanel(f,"Position",[0 0 1 1],...
    "BackgroundColor","w");
ax = axes(px); 
loops = k0;
M(loops) = struct('cdata',[],'colormap',[]);
for k = 1:k0
    mesh(mJacobianFull_right{1, k}','FaceAlpha','0.15',FaceColor = 'interp')
    ax = gca;
    c = ax.Color;
    
    ax.View = [20 5];
    
    u.Value = k;
    M(k) = getframe(gcf);
    writeVideo(v,M(k))
end
figure;
axes("Position",[0 0 1 1])
movie(M)
close(v)

% Animation residual 

v = VideoWriter('Residual.mp4');
v.FrameRate = 1; open(v); k0=size(mResidual,1);
f = figure;
% px = uipanel(f,"Position",[0 0 1 1],...
%     "BackgroundColor","w");
% ax = axes(px); 
% 
loops = k0;
M1(loops) = struct('cdata' ,[],'colormap',[]);
for k = 1:k0
    plot(mResidual(k, :)')
    %axis([-1 1 -1 1])
    u.Value = k;
    M1(k) = getframe(gcf);
    writeVideo(v,M1(k))
end
figure;
axes("Position",[0 0 1 1])
movie(M1)
close(v)

