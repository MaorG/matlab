clear;

% definitions
expDirName = 'C:\simulators\NetLogo 5.2.1\matlab\models\heho_inter_3_initial\';
expOutName = strcat(expDirName, 'output\');

% todo - clear directory and run exp, wait for finish
% https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html

% parse input
allData = parseExperimentDir(expOutName);

%score data
allData = scoreAllData(allData, @getSI, 'SI'); 
allData = scoreAllData(allData, @getEnergy, 'energy'); 
allData = scoreAllData(allData, @getHomogeneity, 'homogeneity'); 
allData = scoreAllData(allData, @getMixScale, 'mix'); 
allData = scoreAllData(allData, @getARatio, 'ratio'); 
allData = scoreAllData(allData, @getTotalCount, 'count');
%allData = scoreAllData(allData, @getLacunarity, 'lacunarity'); 


% diplay results


