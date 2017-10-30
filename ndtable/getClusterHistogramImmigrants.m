function [results] = getClusterHistogramImmigrants (data)

bactTypes = 0;

clusters = data.clusters;
cluscomp = data.clusterComp;
results = struct;

results.(['type']) = getClusterHistogramAux (clusters, cluscomp);


end


function [result] = getClusterHistogramAux (clusters, clusterComp)

c = clusters(~isnan(clusters));
clusterIds = unique(c);

clusterSizeById = zeros(size(clusterIds));
for i = 1:length(clusterIds)
    clusterSizeById(i) = sum(clusters == clusterIds(i));
end

biggestClusterSize = max(clusterSizeById);

hist = zeros(ceil(log2(biggestClusterSize)) + 1, 1);
compSumBySize = zeros(size(hist));

for i = 1:length(clusterIds)
    bin = ceil(log2(clusterSizeById(i))) + 1;
    hist(bin) = hist(bin) + 1;
    compSumBySize(bin) = compSumBySize(bin) + clusterComp(i,2);
end

for bin = 1:numel(hist)
    if hist(bin) > 0
        compSumBySize(bin) = compSumBySize(bin) / hist(bin);
    end
end

values = 2.^(0:ceil(log2(biggestClusterSize)));
result = [values' , hist, compSumBySize]';

end



