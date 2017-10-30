[T,Y] = ode45(@popCC,[0 5000], 100);
%Plotting the columns of the returned array Y versus T shows the solution
hold on;
plot(T,Y)

function dx_dt = popCC (t, x)

beta = 0.01;
gamma = 0.005;
k = 5000;
%dx_dt = x * (beta * (1 - (x/k)) - gamma);

dx_dt = x * (beta - gamma) * (1 - (x/k));

end