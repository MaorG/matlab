

pNames = {'width', 'ticks'};
rt1 = createNDResultTable(allData, 'image',pNames);
tableUI(rt1, [@imshow], []);



rt00 = createNDResultTable(allData, 'p00',pNames);
rt01 = createNDResultTable(allData, 'p01',pNames);
rt10 = createNDResultTable(allData, 'p10',pNames);
rt11 = createNDResultTable(allData, 'p11',pNames);

TT = rt00.T;
for i = 1:numel(rt00.T)
    if (~isempty(rt00.T{i}))
        p00 = rt00.T{i}{1};
        p01 = rt01.T{i}{1};
        p10 = rt10.T{i}{1};
        p11 = rt11.T{i}{1};
        TT{i} = {[p00,p01,p10,p11]};
    else
        TT{i} = {nan};
    end
end



rt2 = rt00;
rt2.T = TT;
rt3 = colateFieldResultTable(rt2, 'ticks');
TT = rt3.T;
for i = 1:numel(TT)
    A = TT{i}{1};
    B = [0.25, 0.25, 0.25, 0.25];
    TT{i}{1} = conv2(A,B,'valid');
    
end
rt4=rt3;
rt4.T = TT;
ptc = @(m, color) ...
    plot(m(1,:), (m(2,:)), ':', m(1,:), (m(3,:)), '--',  m(1,:), (m(2,:) + m(3,:)), '-',  'Color', color);

ptrc = @(m, color) ...
    plot(m(1,:), (m(2,:)) ./ (m(2,:) + m(3,:)), 'Color', color);
xx = @(h) xlim(h,[000000,20000]);
yy = @(h) ylim(h,[0,5000]);
tableUI(rt3,ptc,[]);

%---------------------------------------------

rt4C = createNDResultTable(allData, 'clusterHistL',pNames);
rt4Z = createNDResultTable(allData, 'clusterHist',pNames);
rt5Z = colateFieldResultTable(rt4Z, 'ticks');
rt5C = colateFieldResultTable(rt4C, 'ticks');


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



numOfRows = 8;
numOfCols = numel(unique(extractfield(allData,'ticks')));
labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
%labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,'ticks'))));
xLim = @(h) xlim(h,[0, numOfRows+1]);
yLim = @(h) ylim(h,[0, numOfCols+1]);
zLim = @(h) zlim(h,[0, 4]);
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,-1,1]);
gl1 = @(h) grid(h, 'on');

tableUI(rt5, bar3plot,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {rot}, {gl1}]);

end

