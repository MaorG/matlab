addpath('C:\school\microscopy\nesli\matlab\pattern');
addpath('C:\school\microscopy\nesli\matlab\ndtable');

allData = config2data('C:\school\microscopy\nesli\config1.csv')

allDataC2 = prepareAllData2(allDataC2);

for i = 1:numel(allData)
    allData(i).dummy = 0
end

allDeltas = getDeltas(allDataC2,1);





allDeltas = scoreAllData(allDeltas, 'aad1c', @getAttachVsCountVsDist2, 'Rclusters', 'Gclusters', [power(2,0:10)],0+[0,60,120,240,480,960,inf],1);
allDeltas = scoreAllData(allDeltas, 'aad1', @getAttachVsCountVsDist, 'Rclusters', 'Gclusters', [power(2,0:10)],0+[0,60,120,240,480,960,inf]);
allDeltas = scoreAllData(allDeltas, 'aad4c', @getAttachVsCountVsDist, 'Rclusters', 'Gclusters', [power(4,0:5)],0+[0,60,120,240,480,960,inf],1);


allDeltas = scoreAllData(allDeltas, 'aad2c', @getAttachVsCountVsDist, 'Rclusters', 'Gclusters', [1,24,1000],0+[0,60,inf],1);

dd = getDataByParams(allDeltas,'time', 1, 'conc', 2000, 'signal', 0);
allDeltas = scoreAllData(allDeltas, 'demo', @getAttachVsCountVsDist2, 'Rclusters', 'Gclusters', [32,64],[0,60],1);

pNames = {'time', 'conc', 'signal'};
rt5 = createNDResultTable(allDeltas, 'aad1c', pNames);
tableUI(rt5,@showAttachVsCountVsDist,[]);

sss = @(m) showAttachVsCountVsDist(m,[1]);
tableUI(rt5,sss,[]);


dbp2 = getDataByParams(allDeltas','time', 20, 'conc', 22, 'signal', 1);
ddd = getDataDelta(dbp1,dbp2)
ddd = scoreAllData(ddd, 'aad1c', @getAttachVsCountVsDist, 'Rclusters', 'Gclusters', [power(2,0:10)],0+[0,60,120,240,480,960,inf],1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%


allDeltas = scoreAllData(allDeltas, 'ald1', @getAttachVsLocalDensity, 'Rclusters', 'Gclusters', 60);
pNames = {'time', 'conc', 'signal'};
rt5 = createNDResultTable(allDeltas, 'ald1', pNames);
tableUI(rt5,@showAttachVsLocalDensity,[]);




%%%%%%%%%



