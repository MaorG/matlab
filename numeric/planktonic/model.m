
%% very simple model description
% population composed of a single cluster and floating agents
% N = Nc + Nf
% constant death rate (or chance)
% Rd
% constant detach rate (or chance) - a small one
% Rf
% growth rate for cluster slightly smaller than growth rate for floating
% both dependant on population size (and time??), cluster dependant on cluster size as
% well
% Rgc, Rgf
% So, it sort of looks like this:
% Nc(t+1) = Nc(t) * (1 + Rgc - Rd - Rf)
% Nf(t+1) = Nf(t) * (1 + Rgf - Rd + Rf)
% the question becomes the growth rate. 
%lets make it simple:
% r is the "low density growth rate", 
% M is the carrying capacity, 
% E is an "experimental result" for the retation between cluster size and
% growth rate
% Rgf(t) = r * (1 - (Nc(t) + Nf(t)) / M)
% Rgc(t) = Rgf(t) * (1 - E * log(Nc))
% from previous simulations, let's pick 
% r = 0.002, M = 100, E = 0.05, Nc(1) = 1, Nf(1) = 0, Rd = 0.0004, Rf =
% 0.001

T = 150000;
Nc = zeros(1,T);
Nc(1) = 1;
Nf = zeros(1,T);
r = 0.002;
M = 1000;
E = 0.01;
Rd = 0.001; 
Rf = 0.0004;
thresh = 16;
for t = 1:T - 1
    Rgf = r * (1 - (Nc(t) + Nf(t)) / M);
    Rgc = Rgf * (1 - E * log(Nc(t)));
    if (Nc(t) < thresh)
        Nc(t+1) = Nc(t) * (1 + Rgc - Rd - Rf);
    else
        Nc(t+1) = Nc(t) * (1 + Rgc - Rf);
    end
    Nf(t+1) = Nf(t) * (1 + Rgf - Rd) + Nc(t) * Rf;
end

figure
plot(1:T, Nc,1:T,Nf)


