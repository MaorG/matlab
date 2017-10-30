clear;

% definitions
expDirName = 'C:\school\netlogo\models\heho-inco-asymm\';
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


FigHandle = figure(14);
suptitle (expDirName)
set(FigHandle, 'Position', [100, 100, 750, 250]);
% diplay results

initialData = allData([allData.time] == 400);
rtSI = createResultTable(initialData, 'paramA', 'paramB', 'count');
subplot(2,3,1)
displayResultTable(rtSI, false);
title('count');

rt1 = createResultTable(initialData, 'paramA', 'paramB', 'mix', 1, 2);
subplot(2,3,2)
displayResultTable(rt1, true);
title('mix @ 4');

rt1 = createResultTable(initialData, 'paramA', 'paramB', 'energy');
subplot(2,3,3)
displayResultTable(rt1, true);
title('energy');

% rt1 = createResultTable(heteroData, 'paramA', 'time', 'mix', 2, 2);
% subplot(2,3,3)
% displayResultTable(rt1, true);
% title('mix @ 16');

finalData = allData([allData.time] == 1500);

rtSI = createResultTable(finalData, 'paramA', 'paramB', 'count');
subplot(2,3,4)
displayResultTable(rtSI, false);
title('count');

rt1 = createResultTable(finalData, 'paramA', 'paramB','mix', 1, 2);
subplot(2,3,5)
displayResultTable(rt1, true);
title('mix @ 4');

rt1 = createResultTable(finalData, 'paramA', 'paramB', 'energy');
subplot(2,3,6)
displayResultTable(rt1, true);
title('energy');

% rt1 = createResultTable(homoData, 'paramA', 'time', 'mix', 2, 2);
% subplot(2,3,6)
% displayResultTable(rt1, true);
% title('mix @ 16');
