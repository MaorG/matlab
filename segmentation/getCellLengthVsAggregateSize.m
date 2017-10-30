function dps = getCellLengthVsAggregateSize(data)

solidity = data.Seg.getCellsProperty('Solidity');
cellSolidities = cat(1,solidity(:).Solidity);

cellSolidities(cellSolidities < 0.8) = nan;
cellSolidities(~isnan(cellSolidities)) = 1;

lengths = data.Seg.getCellsProperty('MajorAxisLength');
cellLengths = cat(1,lengths(:).MajorAxisLength);

cellLengthsClean = cellLengths .* cellSolidities;

clus = data.clusters;

numOfClusters = numel(clus.areas);
dps = zeros(numOfClusters,2);


for i = 1:numOfClusters
    cellIdsInCluster = (clus.cellIds{i});
    lll = cellLengthsClean(cellIdsInCluster);
    dps(i,1) = clus.count(i);
    dps(i,2) = mean(lll(:));

end



end