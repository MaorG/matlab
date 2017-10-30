clear;

% definitions
expDirName = 'C:\simulators\NetLogo 5.2.1\matlab\models\cc_heho_cluster_equi_long\';
expOutName = strcat(expDirName, 'output\');

% todo - clear directory and run exp, wait for finish
% https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html

% parse input
allData = parseExperimentDir(expOutName);

%score data
allData = scoreAllData(allData, @getSI, 'SI'); 
allData = scoreAllData(allData, @getEnergy, 'energy'); 
allData = scoreAllData(allData, @getMixScale, 'mix'); 
allData = scoreAllData(allData, @getARatio, 'ratio'); 
allData = scoreAllData(allData, @getTotalCount, 'count');
%allData = scoreAllData(allData, @getLacunarity, 'lacunarity'); 


FigHandle = figure(10);
suptitle (expDirName)
set(FigHandle, 'Position', [100, 100, 750, 250]);
% diplay results

heteroData = allData([allData.paramB] == 1);
rtSI = createResultTable(heteroData, 'paramA', 'time', 'count');
subplot(2,3,1)
displayResultTable(rtSI, false);
title('count');

rt1 = createResultTable(heteroData, 'paramA', 'time', 'mix', 1, 2);
subplot(2,3,2)
displayResultTable(rt1, true);
title('mix @ 4');

rt1 = createResultTable(heteroData, 'paramA', 'time', 'energy');
subplot(2,3,3)
displayResultTable(rt1, true);
title('energy');

% rt1 = createResultTable(heteroData, 'paramA', 'time', 'mix', 2, 2);
% subplot(2,3,3)
% displayResultTable(rt1, true);
% title('mix @ 16');

homoData = allData([allData.paramB] == 0);

rtSI = createResultTable(homoData, 'paramA', 'time', 'count');
subplot(2,3,4)
displayResultTable(rtSI, false);
title('count');

rt1 = createResultTable(homoData, 'paramA', 'time', 'mix', 1, 2);
subplot(2,3,5)
displayResultTable(rt1, true);
title('mix @ 4');

rt1 = createResultTable(homoData, 'paramA', 'time', 'energy');
subplot(2,3,6)
displayResultTable(rt1, true);
title('energy');

% rt1 = createResultTable(homoData, 'paramA', 'time', 'mix', 2, 2);
% subplot(2,3,6)
% displayResultTable(rt1, true);
% title('mix @ 16');
