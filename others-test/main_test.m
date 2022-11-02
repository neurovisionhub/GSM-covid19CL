gridSize = 40;
sigma = linspace(5, 45, gridSize);
rho = linspace(50, 100, gridSize);
beta = 8/3;
[rho,sigma] = meshgrid(rho,sigma);
figure('Visible',true);
surface = surf(rho,sigma,NaN(size(sigma)));
xlabel('\rho','Interpreter','Tex')
ylabel('\sigma','Interpreter','Tex')
%parpool;
Q = parallel.pool.DataQueue;
afterEach(Q,@(data) updatePlot(surface,data));

step = 100;
partitions = [1:step:numel(sigma), numel(sigma)+1];
f(1:numel(partitions)-1) = parallel.FevalFuture;
for ii = 1:numel(partitions)-1
    f(ii) = parfeval(@parameterSweep,1,partitions(ii),partitions(ii+1),sigma,rho,beta,Q);
end
wait(f);
results = reshape(fetchOutputs(f),gridSize,[]);
contourf(rho,sigma,results)
xlabel('\rho','Interpreter','Tex')
ylabel('\sigma','Interpreter','Tex')