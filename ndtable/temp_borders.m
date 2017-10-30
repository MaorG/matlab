%playing with borders

hold on;
runs = getRunsByParams(cruns, 'paramA', -1, 'paramB', 1, 'paramC', -3);

run = runs{1};

run = scoreAllData(run, 'op', @getOutposts, 4);

rtMix = createResultTable(run, 'paramA', 'time', 'mean', 'op');

plot(rtMix.T);

runs = getRunsByParams(cruns, 'paramA', -1, 'paramB', 1, 'paramC', 3);

run = runs{1};

run = scoreAllData(run, 'op', @getOutposts, 4);

rtMix = createResultTable(run, 'paramA', 'time', 'mean', 'op');

plot(rtMix.T);