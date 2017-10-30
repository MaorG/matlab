function allData = sandbox(dirName)
addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable');

allData = dir2data(dirName, false);

allData = scoreAllData(allData, 'Seg', @getOptimalSegmentationFromBitmap, ...
    'imageName', 'I', 'laplacianSize', 4, 'clusterDilateRadius', 4, 'thresholds', [0.3:0.05:0.5],...
    'optimalPropNames', {'MinorAxisLength', 'MajorAxisLength'},...
    'optimalPropRanges', {[3,4], [8,12]}, ...
    'sampleRect', [] ...
);

allData = scoreAllData(allData, 'clusters', @getClustersFromSeg);

allData = scoreAllData(allData, 'countHist', @getClusterPropHistogram, 'propName', 'count', 'bins', power(2,1:12));

end

function ff()
pNames = {'dirName', 'fileName'};

rt1 = createNDResultTable(allDataC1, 'countHist', pNames);
myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log');
ylog = @(h) set(h,'yscale','log');
%tableUI(rt1,myplot, [{xlog}, {ylog}]);
rt2 = colateFieldResultTable(rt1, 'fileName');
bar3plotLog = @(m) bar3nan(log10(m(:,:,3)));

tableUI(rt2,bar3plotLog, []); 


rtA1 = createNDResultTable(allDataA1, 'countHist', pNames);
rtA3 = createNDResultTable(allDataA3, 'countHist', pNames);
rtC1 = createNDResultTable(allDataC1, 'countHist', pNames);
rtC3 = createNDResultTable(allDataC3, 'countHist', pNames);
rtC4 = createNDResultTable(allDataC4, 'countHist', pNames);

myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log');
ylog = @(h) set(h,'yscale','log');
tableUI(rtC3,myplot, [{xlog}, {ylog}]);


rtA1a = colateFieldResultTable(rtA1, 'fileName');
rtA3a = colateFieldResultTable(rtA3, 'fileName');
rtC1a = colateFieldResultTable(rtC1, 'fileName');
rtC3a = colateFieldResultTable(rtC3, 'fileName');
rtC4a = colateFieldResultTable(rtC4, 'fileName');
bar3plotLog = @(m) bar3nan(log10(m(:,:,3)));

tableUI(rtA1a,bar3plotLog, []); 
tableUI(rtA3a,bar3plotLog, []); 
tableUI(rtC1a,bar3plotLog, []); 
tableUI(rtC4a,bar3plotLog, []); 






% show largest cluster
for ii = 14:numel(allData)
   allData(ii).Seg = allData(ii).Seg.getClusters;
   counts = cat(1, allData(ii).clusters.count);
   [maxCount, maxIdx] = max(counts);
   cim = allData(ii).Seg.clusters(maxIdx).Image;
   figure
   imshow(cim);
   title([allData(ii).dirName, allData(ii).fileName, '  -- count: ', num2str(maxCount)]);
end


figure
for i = 1:numel(allData(1).Seg.clusters)
imshow(allData(1).Seg.clusters(i).Image)
title(allData(1).Seg.clusters(i).count)
pause
end

end