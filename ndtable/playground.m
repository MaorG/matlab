function [] = playground(allData)

expression = '[\w\.]*';

for i = 1:numel(allData)
   nums = regexp(allData(i).death,expression,'match');
%    allData(i).dcoeff = str2double(nums{1});
%    allData(i).dthresh = str2double(nums{6});
%    allData(i).dslope = str2double(nums{4});
   allData(i).dvar = str2double(nums{3});
end

expression = '[\w\.]*';

for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).scoeff1 = str2double(nums{1});
   allData(i).sthresh1 = str2double(nums{7});
   allData(i).sslope1 = str2double(nums{5});
end

for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr2,expression,'match');
   allData(i).scoeff2 = str2double(nums{1});
   allData(i).sthresh2 = str2double(nums{7});
   allData(i).sslope2 = str2double(nums{5});
end

p5(allData);
end

function [] = p5(allData)
rt1 = createNDResultTable(allData, 'cimage', 'schance', 'sthresh', 'diff', 'repeat', 'ticks');
tableUI(rt1, [@imshow], []);

rt1 = createNDResultTable(allData, 'count',  'sthresh1', 'sthresh2', 'repeat', 'ticks');
tableUI(rt1, [], []);

%------------------------------
rt1 = createNDResultTable(allData, 'GvsC', 'sthresh1', 'diff', 'ticks');
sc = @(m) scatter(log10(m(1,:)), (m(2,:)));
xl1 = @(h) xlim(h,[0, 6]);
yl1 = @(h) ylim(h,[0, 0.002]);
gl1 = @(h) grid(h, 'on');
tableUI(rt1,sc,[{xl1}, {yl1}, {gl1}]) ;



rt1 = createNDResultTable(allData, 'NvsC', 'sthresh1', 'diff', 'ticks');
sc = @(m) scatter(log10(m(1,:)  + 10 .*rand(1, numel(m(1,:))) ), (m(2,:) + rand(1, numel(m(2,:))) ) );
xl1 = @(h) xlim(h,[0, 6]);
yl1 = @(h) ylim(h,[0, 120]);
gl1 = @(h) grid(h, 'on');
%tableUI(rt1,sc,[{xl1}, {yl1}, {}]) ;
tableUI(rt1,sc,[{xl1}, {yl1}]) ;
%------------------------------

rt2 = createNDResultTable(allData, 'count', 'sthresh1', 'sthresh2', 'ticks');
rt2f = rt2;
rt2f.T =  cellfun(@(t) {mean(cell2mat(t))}, rt2.T, 'UniformOutput', false);
rt2std = rt2;
rt2std.T =  cellfun(@(t) {std(cell2mat(t))}, rt2.T, 'UniformOutput', false);

pt = @(m) plot(m(1,:), log10(m(2,:)));
pteb = @(m) errorbar(m(1,:), (m(2,:)), (m(3,:)), (m(3,:)));
%pteb = @(m) errorbar(m(1,:), log10(m(2,:)), log10(m(3,:)), log10(m(3,:)));

rt3f = colateFieldResultTable(rt2f, 'ticks');
rt3std = colateFieldResultTable(rt2std, 'ticks');
TT = cellfun(@(x,y) {[x{1}(1,:); x{1}(2,:); y{1}(2,:)]},...
    rt3f.T, rt3std.T , 'UniformOutput', false);
rt3f.T = TT;
yl1 = @(h) ylim(h,[0.0,5]);
%tableUI(rt3std,pt,[]) 
tableUI(rt3f,pt,[{yl1}]) 

rt4 = createNDResultTable(allData, 'clusterHist', 'repeat', 'sthresh1', 'sthresh2', 'ticks');
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
tableUI(rt5, bar3plotLog,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}]);


%for types
rt4 = createNDResultTable(allData, 'clusterHist', 'diff', 'perm', 'repeat', 'ticks');
bar3plot = @(m) bar(log10(m(1:end,:)));
rot = @(h) view([1,1,1]);
labelX1 = @(h) set(h, 'XTick', 1:11);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,1:10), inf]);
labelY1 = @(h) set(h, 'YTick', 1:3);
labelY2 = @(h) set(h, 'YTickLabel', {'1', '2', '1+2'});
col1 = @(h) set(h(1), 'facecolor', 'red');
col2 = @(h) set(h(2), 'facecolor', 'green');
col3 = @(h) set(h(3), 'facecolor', 'yellow');
col = @(h) set(h,  'ColorOrder', [1 0 0; 0 1 0; 1 1 0]);
tableUI(rt4, bar3plot, [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {col}, {rot}]);


% now the same for 2d

rt2countAD = createNDResultTable(allData, 'countAD', 'detach',  'strat', 'repeat', 'ticks');
rt3 = colateFieldResultTable(rt2countAD, 'ticks');
pt = @(m) plot(m(1,:), log10(m(2,:)), 'b-*', m(1,:), log10(m(3,:)), 'r-o');
yy = @(h) ylim(h,[0,5]);
tableUI(rt3,pt,[{yy}]) 

rt00 = createNDResultTable(allData, 'p00', 'ticks', 'width');
rt01 = createNDResultTable(allData, 'p01', 'ticks', 'width');
rt10 = createNDResultTable(allData, 'p10', 'ticks', 'width');
rt11 = createNDResultTable(allData, 'p11', 'ticks', 'width');

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
    m(1,:), m(5,:), '--g', ...
    m(1,:), sum(m(2:5,:)), '-k');




ptclog = @(m, color) ...
    plot(m(1,:), log10(m(2,:)), '-', m(1,:), log10(m(3,:)), '--', m(1,:), log10(m(4,:)), ':',  'Color', color);
yylog = @(h) ylim(h,[0,8]);

ptc = @(m, color) ...
    plot(m(1,:), (m(2,:)), '-', m(1,:), (m(3,:)), '--', m(1,:), (m(4,:)), ':',  'Color', color);
yy = @(h) ylim(h,[0,1000]);

g  = @(h) grid(h,'on');

xx = @(h) xlim(h,[00000,1000]);
labelX1 = @(h) set(h, 'XTick', 0:250:700);
tableUI(rt3,pt,[{xx}, {yy}, {g}, {labelX1}]) 
tableUI(rt3,pt,[])

end


function T = fillT(T)
    for i = 1:numel(T)
        if (isempty(T{i}))
            a  = cell(1);
            a{1} = nan;
            T{i} = a;
        end
    end
end











function [] = p3(allData)

ttt = cell(size(rt1.T));

ttt = cellfun(@(t) ...
    cellfun(@(tt) tt, t, 'UniformOutput', false), ...
    rt1.T(:,:,:,end), 'UniformOutput', false);

tta =  cellfun(@(t) mean(cell2mat(t)), ttt);

[X,Y,Z] = meshgrid(flip(rt1.vals{1}), flip(rt1.vals{2}), flip(rt1.vals{3}));

C = reshape(tta, numel(tta), 1);

Cmin = min(C);
Cmax = max(C);
isovalues = Cmin:(Cmax - Cmin)/5:Cmax;


figure;
hold on;
for i = 1:numel(isovalues)
    isosurface(X,Y,Z,tta,isovalues(i))
end
X = reshape(X, numel(X), 1);
Y = reshape(Y, numel(Y), 1);
Z = reshape(Z, numel(Z), 1);
s = ones(size(X)) * 50;
% cont3d(tta,...
%     [min(rt1.vals{1}), max(rt1.vals{1})],...
%     [min(rt1.vals{2}), max(rt1.vals{2})],...
%     [min(rt1.vals{3}), max(rt1.vals{3})],...
%     17,0.1,'v',1,'z');

scatter3(X,Y,Z,s,C,'filled');

colorbar
xlabel('max capacity')
ylabel('amplitude')
zlabel('freq')
title('mixing @ 4')

end

function [] = p2(allData)
rt1 = createNDResultTable(allData, 'outpost4', 'paramA', 'paramB', 'paramC', 'time');
ttt = cell(size(rt1.T));

ttt = cellfun(@(t) ...
    cellfun(@(tt) tt, t, 'UniformOutput', false), ...
    rt1.T(:,:,end,end), 'UniformOutput', false);

tta =  cellfun(@(t) mean(cell2mat(t)), ttt)

figure;

imagesc(rt1.vals{2}, rt1.vals{1}, squeeze(tta));

end

function [] = myplot4(data)

end

function [] = p1(allData)
rt1 = createNDResultTable(allData, 'g12', 'paramA', 'paramB', 'paramC', 'time');
ttt = cell(size(rt1.T));

% ttt = cellfun(@(t) t{1:end}(2,:), rt1.T, 'UniformOutput', false);
ttt = cellfun(@(t) ...
    cellfun(@(tt) tt(2,:), t, 'UniformOutput', false), ...
    rt1.T(:,:,:,end), 'UniformOutput', false);

rt2 = rt1;
rt2.names = rt1.names(1:3);
rt2.vals = rt1.vals(1:3);
rt2.T = ttt;

figure
for i = 1:rt1.dims(1) * rt1.dims(2)
    s = subplot(rt1.dims(1), rt1.dims(2), i);
    hold on;
    ij = ceil (i / rt1.dims(1));
    ii = mod(i - 1, rt1.dims(1)) + 1;
    myplot3(ttt{ii, ij, :});
    title([rt1.names(1), ': ', num2str(rt1.vals{1}(ii)), ' , ', rt1.names(2), ': ', num2str(rt1.vals{2}(ij))]);
    title([num2str(rt1.vals{1}(ii)), ' , ', num2str(rt1.vals{2}(ij))]);
    ax = gca;

    ax.XLim = [0,40];
    ax.YLim = [0,1.5];
end

end

function [] = myplot3(varargin)
colorNamesArray = ['-r', '-b', '-g', '-y', '-m'];
for ii = 1:numel(varargin)
    data = varargin{ii};
    l = max( cellfun(@(d) numel(d), data));
    Y = nan(numel(data), l);
    X = 2:2:2*l;
    for i = 1:numel(data)
        Y(i, :) = data{i};
        plot(X,Y,colorNamesArray(ii));
    end

    %shadedErrorBar(X,Y,{@mean,@std},colorNamesArray(ii),1);
end
end

function [] = myplot2(data)
l = max( cellfun(@(d) numel(d), data));
Y = nan(numel(data), l);
for i = 1:numel(data)
    Y(i, :) = data{i};
end
X = 1:l;
plot(X,Y);
end

function [] = myplot(data)
l = max( cellfun(@(d) numel(d), data));
Y = nan(numel(data), l);
for i = 1:numel(data)
    Y(i, :) = data{i};
end
X = 1:l;
shadedErrorBar(X,Y,{@mean,@std},{'r-','markerfacecolor','r'},1);
end