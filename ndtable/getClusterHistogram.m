function [H] = getClusterHistogram (data, varargin)

nVarargs = length(varargin{1});

bins = [];
if (nVarargs >= 1)
    bins = varargin{1}{1};
end

if (isempty(bins))
    bins = exp(1:1:ceil(log(biggestClusterSize)));
end

if (nVarargs >= 2)

end

clusters = data.clusters;

c = clusters(~isnan(clusters));
clusterIds = unique(c);

clusterSizes = arrayfun(@(c) sum(clusters == c), clusterIds);

    
[N,edges] = histcounts(clusterSizes,[-inf, bins + 1, inf]);
H = [N ; [bins, inf]];

end

function[clustersByType] = getTypesInClusters(clusters, bact_type)

c = clusters(~isnan(clusters));

% if any(isnan(clusters))
%     clusters
% end
clusterIds = unique(c);
typesInClusters = zeros(max(clusterIds),1);
for id = clusterIds'
   A = bact_type(c == id); 
   typesInClusters(id) = sum(unique(A));
end

clustersByType = max(c);

for i = 1:numel(c)
    clustersByType(i) = typesInClusters(c(i));
end



end

function [result] = getClusterHistogramAux (clusters, biggestClusterSize)
clusterIds = unique(clusters);

clusterSizes = zeros(size(clusterIds));
for i = 1:length(clusterIds)
    clusterSizes(i) = sum(clusters == clusterIds(i));
end

biggestClusterSize = max(max(clusterSizes));

range = 1:ceil(log2(biggestClusterSize));

sortedClusterSizes = sort(clusterSizes);

hist = zeros(ceil(log2(biggestClusterSize)) + 1, 1);
values = 2.^(0:ceil(log2(biggestClusterSize)));
index = 1;
bin = 1;
while bin <= numel(values) && index <= numel(sortedClusterSizes)
    
    while (index <= numel(sortedClusterSizes) && sortedClusterSizes(index) <= values(bin))
        hist(bin) = hist(bin) + 1;
        index = index + 1;
    end
    bin = bin + 1;
       
end
sum(hist)
result = [values' , hist]';
end



