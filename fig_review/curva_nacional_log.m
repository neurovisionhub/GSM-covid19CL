function curva_nacional_log(YMatrix1)
%CREATEFIGURE2(YMatrix1)
%  YMATRIX1:  matrix of semilogy y data

%  Auto-generated by MATLAB on 21-Nov-2022 18:54:46

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple line objects using matrix input to semilogy
semilogy1 = semilogy(YMatrix1,'LineWidth',2,'Parent',axes1);
set(semilogy1(1),'DisplayName','Infected','Color',[0 0 1],'LineWidth',1);
set(semilogy1(2),'DisplayName','Recovered',...
    'Color',[0.600000023841858 0.200000002980232 0],'LineWidth',1);
set(semilogy1(3),'DisplayName','Deceased','Color',[1 0 0],'LineWidth',1);
set(semilogy1(4),'DisplayName','ICU Internships','LineStyle','--',...
    'Color',[0 0 0],'LineWidth',1);
set(semilogy1(5),'DisplayName','ICU admission','Color',[0 0 0],'LineWidth',1);

% Create ylabel
ylabel('Cases indidence (logarithmic scale)');

% Create xlabel
xlabel('TIme (days)');

% Create title
title('National epidemiological curves (Chile)');

box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'XGrid','on','YGrid','on','YMinorTick','on','YScale','log');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'FontSize',12);

