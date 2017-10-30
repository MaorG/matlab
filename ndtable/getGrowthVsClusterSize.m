function [H] = getGrowthVsClusterSize(data, varargin)

%nVarargs = length(varargin{1});

clusters = data.clusters;

if (numel(data.agents) == 0)
    H = [0 ;0];
    return;
end

species = extractfield(data.agents, 'species');
species = extractfield(data.agents, 'species');


speciesNames = unique(species);

c = clusters(~isnan(clusters));
[clusterIds, a, b] = unique(clusters);

clusterSizes = arrayfun(@(c) sum(clusters == c), clusterIds);
radius = extractfield(data.agents, 'radius');
mass = pi .* radius .* radius;
%ID = extractfield(data, 'clusters');
absGrowth = extractfield(data.agents, 'deltaMass');

relGrowth = absGrowth ./ mass;
maxRelGrowth = max(relGrowth);
minRelGrowth = min(relGrowth);
normalizedRelGrowth = (relGrowth - minRelGrowth)./ (maxRelGrowth - minRelGrowth);

clusterSize = clusterSizes(b);

H = [clusterSize'; relGrowth];

for i = 1:numel(relGrowth)
    if (H(1,i) < 10)
        H(2,i) = nan;
    end
end


return
%clusterTypes = arrayfun(@(c) unique(species(clusters == c)), clusterIds,'UniformOutput','false')

clusterTypes = cell(size(clusterIds));
clusterCodes = zeros(size(clusterIds));

for i = 1:numel(clusterIds)
     clusterTypes{i} = unique(species(clusters == clusterIds(i)));
end

for i = 1:numel(clusterIds)
     for j = 1:numel(speciesNames)
         if (~isempty(find(strcmp([clusterTypes{i}], speciesNames{j}))))
             clusterCodes(i) = clusterCodes(i) + 2^(j-1);
         end
     end
end
clusterSizesByType = cell(2^(numel(speciesNames)) - 1,1);

for i = 1:numel(clusterSizesByType)
    clusterSizesByType{i} = clusterSizes(clusterCodes == i);
end

if (isempty(bins))
    bins = exp(1:1:ceil(log(max(clusterSizes))));
end

H = [bins, inf]
for i = 1:numel(clusterSizesByType)
     [N,edges] = histcounts(clusterSizesByType{i},[-inf, bins, inf]); 
     H = [H; N];
end

end