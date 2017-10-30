function [H] = getGrowthVsDensity(data, varargin)

%nVarargs = length(varargin{1});

clusters = data.clusters;

if (numel(data.agents) == 0)
    H = [0 ;0];
    return;
end

species = extractfield(data.agents, 'species');
species = extractfield(data.agents, 'species');

a = extractfield(data.agents, 'attached');
neighbors = extractfield(data.agents, 'neighbors');
absGrowth = extractfield(data.agents, 'deltaMass');
radius = extractfield(data.agents, 'radius');
mass = pi .* radius .* radius;
relGrowth = absGrowth ./ mass;

attached = find(a == 1);
n = neighbors(attached);
relGrowth = relGrowth(attached);

H = [n; relGrowth];
% 
% for i = 1:numel(relGrowth)
%     if (H(1,i) < 10)
%         H(2,i) = nan;
%     end
% end


end