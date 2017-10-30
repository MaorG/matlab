function allData = processOutput(expOutName, filter)

tic
   
allData = parseExperimentDir(expOutName, true, filter);

% allData = scoreAllData(allData, 'p1', @getCountByProperties, 'species', 'dbact1');
% allData = scoreAllData(allData, 'p2', @getCountByProperties, 'species', 'dbact2');
% allData = scoreAllData(allData, 'p3', @getCountByProperties, 'species', 'dbact3');
% allData = scoreAllData(allData, 'p4', @getCountByProperties, 'species', 'dbact4');
% allData = scoreAllData(allData, 'p5', @getCountByProperties, 'species', 'dbact5');
% allData = scoreAllData(allData, 'p6', @getCountByProperties, 'species', 'dbact6');
% allData = scoreAllData(allData, 'p7', @getCountByProperties, 'species', 'dbact7');
% allData = scoreAllData(allData, 'p8', @getCountByProperties, 'species', 'dbact8');
% 
% allData = scoreAllData(allData, 'p00', @getCountByProperties, 'species', 'dbact1', 'attached', 0);
% allData = scoreAllData(allData, 'p01', @getCountByProperties, 'species', 'dbact1', 'attached', 1);
% allData = scoreAllData(allData, 'p10', @getCountByProperties, 'species', 'dbact2', 'attached', 0);
% allData = scoreAllData(allData, 'p11', @getCountByProperties, 'species', 'dbact2', 'attached', 1);
% allData = scoreAllData(allData, 'clusters', @getClusters, 2);
% allData = scoreAllData(allData, 'clusterHist', @getClusterHistogram, [power(2,0:20)]);
% allData = scoreAllData(allData, 'clusterHistL', @getClusterHistogramRarefaction, [power(2,0:20)]);
% allData = scoreAllData(allData, 'clusterHist2', @getClusterHistogram, [10:10:1000]);
% allData = scoreAllData(allData, 'clusterHist2L', @getClusterHistogramRarefaction, [10:10:1000]);
toc

end