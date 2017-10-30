function [H] = getClusterHistogramRarefaction (data, varargin)

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
 
% colman curve
% E(s*) = sum[i=1..S](1 - (1 - n* / N) ^ n_i)
% S = total number of species (linages)
% N = total number of individuals           -> Ntot
% s* = number of species in sample of n*    -> clusterLinagesExpectedCount
% n* = size of sample                       -> cluster sizes
% i = index of species                      -> Ltot
% n_i = abundance of species                -> N(i)

N = numel(data.agents);
Ntot = numel(data.agents);
Sv = unique(lineages);
S = numel(Sv);
N = zeros(Ntot,1);
for i = 1:S
    N(i) = sum(lineages == Sv(i));
end

clusterLinagesExpectedCount = zeros(numel(clusterSizes),1);
for ii = 1:numel(clusterSizes)
    summation = 0;
    for i = 1:S
        summation = summation + (1 - (1 - (clusterSizes(ii) / Ntot))^N(i));
            
    end
    clusterLinagesExpectedCount(ii) = summation;
end



clusterLinagesCount = arrayfun(@(cid) sum(numel(unique(lineages(clusters == cid)))), clusterIds);
clusterRatio = (clusterLinagesCount - 1) ./ (clusterLinagesExpectedCount - 1);
clusterRatio(clusterLinagesExpectedCount == 1) = 0;
   
% look for expected number of species in sample of size n
% rarefication curves? diversity index?

% histogramming... put in func
[N,edges,binIndex] = histcounts(clusterSizes,[-inf, bins + 1, inf]);
MeanClusterLineageCountInBin = arrayfun(@(bid) mean(clusterRatio(binIndex == bid)), 1:numel(N));
H = [MeanClusterLineageCountInBin ; [bins, inf]];


end

% rarefaction calculations - to func
% Ntot - total number of agents
% K - total number of lineages
% N(i) - number of agents of lineage Kv(i)

% Ntot = numel(data.agents);
% Kv = unique(lineages);
% K = numel(Kv);
% N = zeros(Ntot,1);
% for i = 1:K
%     N(i) = sum(lineages == Kv(i));
% end
% 
% 
% [clusterIds, i2c, c2i] = unique(c);
% clusterSizes = arrayfun(@(cid) sum(clusters == cid), clusterIds);
% 
% clusterLinagesExpectedCount = zeros(numel(clusterSizes),1);
% for i = 1:numel(clusterSizes)
%     n = clusterSizes(i);
%     summation = 0;
%     for ii = 1:K
%         summation = summation + nchoosek(Ntot - N(ii), n); 
%     end
%     
%     
%     clusterLinagesExpectedCount(i) = K - ( 1.0 / nchoosek(Ntot, n) ) * summation;
% end
