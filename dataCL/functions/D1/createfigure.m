function createfigure(zdata1, cdata1)
%CREATEFIGURE(zdata1, cdata1)
%  ZDATA1:  surface zdata
%  CDATA1:  surface cdata

%  Auto-generated by MATLAB on 09-Nov-2021 16:28:29

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create mesh
mesh(zdata1,cdata1,'Parent',axes1);

view(axes1,[-122.142309291288 22.5902151151723]);
grid(axes1,'on');
hold(axes1,'off');
% Create colorbar
colorbar(axes1);

