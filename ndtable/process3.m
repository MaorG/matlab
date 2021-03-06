tic
close all
clear all 
expOutName = '/home/maor/repast/stability/output_02a/';

filter = @(d) (d.ticks == 30000 || d.ticks == 29000);
allData = parseExperimentDir(expOutName, true, filter);

allData = scoreAllData(allData, 'p0', @getCountByProperties, 'species', 'dbact1');
allData = scoreAllData(allData, 'p1', @getCountByProperties, 'species', 'dbact2');
allData = scoreAllData(allData, 'p00', @getCountByProperties, 'species', 'dbact1', 'attached', 0);
allData = scoreAllData(allData, 'p01', @getCountByProperties, 'species', 'dbact1', 'attached', 1);
allData = scoreAllData(allData, 'p10', @getCountByProperties, 'species', 'dbact2', 'attached', 0);
allData = scoreAllData(allData, 'p11', @getCountByProperties, 'species', 'dbact2', 'attached', 1);
allData = scoreAllData(allData, 'clusters', @getClusters, 2);
allData = scoreAllData(allData, 'clusterHist', @getClusterHistogram, [power(2,0:20)]);
allData = scoreAllData(allData, 'clusterHistL', @getClusterHistogramRarefaction, [power(2,0:20)]);
allData = scoreAllData(allData, 'clusterHist2', @getClusterHistogram, [10:10:1000]);
allData = scoreAllData(allData, 'clusterHist2L', @getClusterHistogramRarefaction, [10:10:1000]);
toc
allData = scoreAllData(allData, 'pairCorr', @getPairCorrelationCont, {'species', 'dbact1', 'attached', 1}, {'species', 'dbact1', 'attached', 1}, 4, 100);

%score data
allData = scoreAllData(allData, 'image', @getAgentsImage, 1.0);
allData = scoreAllData(allData, 'image', @getAgentsImageByLineage, 0.2);

allData = scoreAllData(allData, 'ratio', @getARatio, 'dbact1'); 
allData = scoreAllData(allData, 'count', @getTotalCount); 

allData = scoreAllData(allData, 'attached', @getAttachedRatio); 



allData = scoreAllData(allData, 'cimage', @getClustersImage, 0.1);

allData = scoreAllData(allData, 'clusterHist', @getClusterHistogram, [power(2,1:20)]);
allData = scoreAllData(allData, 'clusterHistByType', @getClusterHistogramByType, [power(2,0:20)], {'dbact1', 'dbact2'});

allData = scoreAllData(allData, 'gimage', @getGrowthImage, 0.1);


allData = scoreAllData(allData, 'GvsC', @getGrowthVsClusterSize);
allData = scoreAllData(allData, 'GvsN', @getGrowthVsDensity);
allData = scoreAllData(allData, 'NvsC', @getNeighborsVsClusterSizeTemp);

tic
save(strcat(expOutName, 'allData.mat'), 'allData', '-v7.3');
toc
% allWorlds = scoreAllData(allWorlds, 'clusterComp', @analyzeClustersCoposition, lineages);
% 
% allWorlds = scoreAllData(allWorlds, 'clusterHist2', @getClusterHistogramImmigrants);



% 
% %---------------
% 
% CMap = [
% 0, 0, 0;
% 1, 0.2, 0.2;
% 0.2, 1, 0.2];
% showWorld = @(I) imshow(ind2rgb(I' + 1,CMap));
% showPlot = @(v) plot(v(1,:), v(2,:));
% setClim = @(h) set(h,'clim',[0,0.3]);
% setYlim = @(h) set(h,'ylim',[0,2]);

