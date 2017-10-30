function presPlayground2(allData)

pNames = {'s1', 'ticks', 'repeat'};
%pNames = {'repeat',  'ga', 'wl', 'death', 'ticks'};
colateDim = 'ticks';

rt4C = createNDResultTable(allData, 'clusterHist2L', pNames);
rt4Z = createNDResultTable(allData, 'clusterHist2', pNames);
rt5Z = colateFieldResultTable(rt4Z, colateDim);
rt5C = colateFieldResultTable(rt4C, colateDim);

rt5 = rt5Z;
TT = rt5.T;
for i = 1:numel(rt5.T)
    if (~isempty(rt5.T{i}))
        z = rt5Z.T{i}{1};
        c = rt5C.T{i}{1};
        v = cat(3,z,c(:,:,3));
        TT{i} = {v};
    else
        TT{i} = {nan};
    end
end
rt5.T = TT;


bar3plotLog = @(m) bar3nanColor(log10(m(:,:,3)), m(:,:,4));
bar3plot = @(m) bar3nanColor(m(:,:,3), m(:,:,4));



numOfRows = 100;
numOfCols = numel(unique(extractfield(allData,colateDim)));
labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
labelY1 = @(h) set(h, 'YTick', 1:numOfCols+1);
labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,colateDim))));
xLim = @(h) xlim(h,[0, numOfRows]);
yLim = @(h) ylim(h,[0, numOfCols]);
zLim = @(h) zlim(h,[0, 4]);
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,-1,1]);
gl1 = @(h) grid(h, 'on');

tableUI(rt5, bar3plotLog,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}]);


pNames = {'s1', 'ticks'};
%pNames = {'repeat',  'attach', 'death', 'ticks'};
colateDim = 'ticks';
rt4C = createNDResultTable(allData, 'clusterHistL', pNames);
rt4Z = createNDResultTable(allData, 'clusterHist', pNames);
rt5Z = colateFieldResultTable(rt4Z, colateDim);
rt5C = colateFieldResultTable(rt4C, colateDim);

rt5 = rt5Z;
TT = rt5.T;
for i = 1:numel(rt5.T)
    if (~isempty(rt5.T{i}))
        z = rt5Z.T{i}{1};
        c = rt5C.T{i}{1};
        v = cat(3,z,c(:,:,3));
        TT{i} = {v};
    else
        TT{i} = {nan};
    end
end
rt5.T = TT;


bar3plotLog = @(m) bar3nanColor(log10(m(:,:,3)), m(:,:,4));
bar3plot = @(m) bar3nanColor(m(:,:,3), m(:,:,4));



numOfRows = 12;
numOfCols = numel(unique(extractfield(allData,colateDim)));
labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
%labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,colateDim))));
xLim = @(h) xlim(h,[0, numOfRows+1]);
yLim = @(h) ylim(h,[0, numOfCols+1]);
zLim = @(h) zlim(h,[0, 4]);
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,-1,1]);
gl1 = @(h) grid(h, 'on');

tableUI(rt5, bar3plotLog,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}]);
