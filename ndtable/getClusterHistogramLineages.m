function [H] = getClusterHistogramLineages (data, varargin)

nVarargs = length(varargin{1});

bins = [];
if (nVarargs >= 1)
    bins = varargin{1}{1};
end

if (nVarargs >= 2)

end

clusters = data.clusters;
lineages = extractfield(data.agents, 'LineageId');


c = clusters(~isnan(clusters));
l = lineages(~isnan(clusters));

[clusterIds, i2c, c2i] = unique(c);
clusterSizes = arrayfun(@(cid) sum(clusters == cid), clusterIds);
clusterLinagesCount = arrayfun(@(cid) sum(numel(unique(lineages(clusters == cid)))), clusterIds);

clusterLinagesCountRel = clusterLinagesCount ./ clusterSizes;
   
% look for expected number of species in sample of size n
% rarefication curves? diversity index?

% histogramming... put in func
[N,edges,binIndex] = histcounts(clusterSizes,[-inf, bins + 1, inf]);
MeanClusterLineageCountInBin = arrayfun(@(bid) mean(clusterLinagesCountRel(binIndex == bid)), 1:numel(N));
H = [MeanClusterLineageCountInBin ; [bins, inf]];


end

