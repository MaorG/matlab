%%%


expression = '[\w\.]*';
for i = 1:numel(allData)
   nums = regexp(allData(i).death,expression,'match');
    allData(i).d1 = str2double(nums{2});
    allData(i).d2 = str2double(nums{4});
end
for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).schance = str2double(nums{1});
   allData(i).sthresh = str2double(nums{8});
end


%%%
rtI = createNDResultTable(allData, 'image',  'sthresh', 'wl',  'death', 'ticks', 'repeat');
tableUI(rtI, [@imshow], []);

rt4 = createNDResultTable(allData, 'clusterHist', 'schance',  'sthresh', 'diff', 'ticks');
barplot = @(m) bar(log2(m(2,1:end)), log10(m(1,1:end))+1);
yl2 = @(h) ylim(h,[0,log10(10000)]);
xl2 = @(h) xlim(h,[0,log2(2000)]);
% tableUI(rt4, barplot, [{xl2},{yl2}]);
% for time series
bar3plotLog = @(m) bar3nan(log10(m(:,:,3)));
bar3plot = @(m) bar3nan(m(:,:,3));
rt5 = colateFieldResultTable(rt4, 'ticks');
numOfRows = 24;
numOfCols = 20;
labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,1:numOfRows), inf]);
labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
labelY2 = @(h) set(h, 'YTickLabel', 1000:1000:(numOfCols * 1000));
xLim = @(h) xlim(h,[1, numOfRows]);
yLim = @(h) ylim(h,[1, numOfCols]);
zLim = @(h) zlim(h,[0, 5]);
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,1,1]);
gl1 = @(h) grid(h, 'on');
tableUI(rt5, bar3plotLog,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}]);
% tableUI(rt5, bar3plotLog,...
%     [{rot}]);



%%%

rt00 = createNDResultTable(allData, 'p00', 'ticks', 'sthresh', 'wl', 'death', 'repeat');
rt01 = createNDResultTable(allData, 'p01', 'ticks', 'schance', 'wl', 'death', 'repeat');
rt10 = createNDResultTable(allData, 'p10', 'ticks', 'schance', 'wl', 'death', 'repeat');
rt11 = createNDResultTable(allData, 'p11', 'ticks', 'schance', 'wl', 'death', 'repeat');

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
    
% TT = cellfun(@(x,y) {[x{1}; x{1}*y{1}; x{1}*(1-y{1})]},...
%     rt2count.T, rt2attached.T , 'UniformOutput', false);

rt00.T = TT;
rt3 = colateFieldResultTable(rt00, 'ticks');

pt = @(m) plot(...
    m(1,:), m(2,:), ':r', ...
    m(1,:), m(3,:), '--r', ...
    m(1,:), m(4,:), ':g', ...
    m(1,:), m(5,:), '--g' ...
    );
    %m(1,:), sum(m(2:5,:)), '-k', ..., 
    %);

ptlog = @(m) plot(...
    m(1,:), log2(m(2,:)), ':r', ...
    m(1,:), log2(m(3,:)), '--r', ...
    m(1,:), log2(m(4,:)), ':g', ...
    m(1,:), log2(m(5,:)), '--g' ...
    );


ptclog = @(m, color) ...
    plot(m(1,:), log10(m(2,:)), ':', m(1,:), log10(m(3,:)), '--', m(1,:), 'Color', color);
yylog = @(h) ylim(h,[0,20]);

ptc = @(m, color) ...
    plot(m(1,:), (m(2,:)), ':', m(1,:), (m(3,:)), '--',  m(1,:), (m(2,:) + m(3,:)), '-',  'Color', color);
yy = @(h) ylim(h,[0,10000]);


g  = @(h) grid(h,'on');

xx = @(h) xlim(h,[100000,120000]);
labelX1 = @(h) set(h, 'XTick', 0:250:700);
%tableUI(rt3,pt,[{xx}, {yy}, {g}, {labelX1}]) 
tableUI(rt3,ptc,[{xx},{yy}])


%%%

rt3 = createNDResultTable(allData, 'GvsC', 'sthresh1', 'diff', 'ticks');
sc = @(m) scatter(log10(m(1,:)), (m(2,:)));
xl1 = @(h) xlim(h,[0, 6]);
yl1 = @(h) ylim(h,[0, 0.002]);
gl1 = @(h) grid(h, 'on');
tableUI(rt1,sc,[{xl1}, {yl1}, {gl1}]) ;

rt1 = createNDResultTable(allData, 'NvsC',  'ticks', 'schance',  'sthresh', 'w1', 'w2', 'diff');
rt2 = rt1;
T = rt2.T;
fd = @(x)  0.001 ./ (1.0 + 2.71828 .^ (1000 .* ( x./50 - 1 ) ) );


for i = 1:numel(T)
    if (~isempty(T{i}))
        gvsc = rt3.T{i}{1};
        nvsc = T{i}{1};
        dvsc = nvsc;
        dvsc(2,:) = fd(nvsc(2,:));
        T{i} = {[dvsc ; gvsc(2,:)]};
    else
        T{i} = {nan};
    end
end

rt2.T = T;

sc = @(m) scatter(log10(m(1,:)  + 10 .*rand(1, numel(m(1,:))) ), (m(2,:)), log10(m(1,:)  + 10 .*rand(1, numel(m(1,:))) ), (m(3,:)));
%sc = @(m) scatter(log10(m(1,:)), (m(2,:)));
xl1 = @(h) xlim(h,[0, 6]);
yl1 = @(h) ylim(h,[0, 0.002]);
gl1 = @(h) grid(h, 'on');
%tableUI(rt1,sc,[{xl1}, {yl1}, {}]) ;
tableUI(rt2,sc,[{xl1}, {yl1}]) ;
%------------------------------
