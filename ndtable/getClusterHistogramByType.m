function [H] = getClusterHistogramByType (data, varargin)

nVarargs = length(varargin{1});

bins = [];
if (nVarargs >= 1)
    bins = varargin{1}{1};
end

species = extractfield(data.agents, 'species');
if (nVarargs >= 2)
    speciesNames = varargin{1}{2}
else
    speciesNames = unique(species);  
end

clusters = data.clusters;


c = clusters(~isnan(clusters));
clusterIds = unique(c);

clusterSizes = arrayfun(@(c) sum(clusters == c), clusterIds);
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
    clusterSizesByType{i} = clusterSizes .* (clusterCodes == i);
end

if (isempty(bins))
    bins = exp(1:1:ceil(log(max(clusterSizes))));
end

H = [bins, inf];

[N,edges,bindices] = histcounts(clusterSizes,[-inf, bins+1, inf]); 


for i = 1:numel(clusterSizesByType)
    partialHist = zeros(1, numel(N));
    for j = 1:numel(N)
        partialHist(j) = sum(bindices.*(clusterCodes == i) == j);
    end
    H = [H; partialHist];
end

M = sum(H(2:4,:));
N-M

end