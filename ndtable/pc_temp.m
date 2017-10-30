%pc temp

runs = getRunsByParams(cruns, 'paramA', 1, 'paramB', 1, 'paramC', -3);

run = runs{1};
tic
run = scoreAllData(run, 'ctpc', @getPairCorrelation2, 1, 2, 10);
toc

figure(11)
tempctpc

runs = getRunsByParams(cruns, 'paramA', 1, 'paramB', 1, 'paramC', 3);
run = runs{1};
tic
run = scoreAllData(run, 'ctpc', @getPairCorrelation2, 1, 2, 10);
toc

figure(12)
tempctpc
