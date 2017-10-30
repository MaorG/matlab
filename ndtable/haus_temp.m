%pc temp

runs = getRunsByParams(cruns, 'paramA', 1, 'paramB', -1, 'paramC', -3);

run = runs{1};
tic
run = scoreAllData(run, 'haus', @getHausDim);
toc

runs = getRunsByParams(cruns, 'paramA', 1, 'paramB', -1, 'paramC', 3);
run2 = runs{1};
tic
run2 = scoreAllData(run2, 'haus', @getHausDim);
toc

figure;

y1 = [];
y2 = [];
x = [];

for i = 1:size(run,1)
    x = [x ; run(i).time];
    y1 = [y1 ; run(i).haus];
    y2 = [y2 ; run2(i).haus];
end

plot(x, y1, x, y2);
