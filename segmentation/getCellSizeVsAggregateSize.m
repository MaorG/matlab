function dps = getCellSizeVsAggregateSize(data)

aaa = data.Seg.getCellsProperty('Area');
cellAreas = cat(1,aaa(:).Area);

clus = data.clusters;

numOfClusters = numel(clus.areas);
dps = zeros(numOfClusters,2);


for i = 1:numOfClusters
    cellIdsInCluster = (clus.cellIds{i});
    areas = cellAreas(cellIdsInCluster);
    dps(i,1) = clus.count(i);
    dps(i,2) = mean(areas(:));

end



end