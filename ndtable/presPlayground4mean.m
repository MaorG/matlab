function [] = presPlayground4mean(allData)
pNames = {'ticks', 'food', 'diff', 'width'};    
%slide1(allData, pNames);

slideStrat1(allData, pNames);
% for const conditions

end


function slideStrat1(allData, pNames)

    

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    
    rt00m = rt00;
    rt00m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt00.T, 'UniformOutput', false);
    rt00s = rt00;
    rt00s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt00.T, 'UniformOutput', false);
    
    rt01m = rt01;
    rt01m.T =  cellfun(@(t) {mean(cell2mat(t))}, rt01.T, 'UniformOutput', false);
    rt01s = rt01;
    rt01s.T =  cellfun(@(t) {std(cell2mat(t)) / sqrt(length(cell2mat(t)))}, rt01.T, 'UniformOutput', false);
    
    rt02m = rt00;
    rt02m.T =  cellfun(@(t, s) {mean(cell2mat(t) + cell2mat(s))}, rt01.T, rt00.T, 'UniformOutput', false);
    rt02m.T =  cellfun(@(t, s) {std(cell2mat(t) + cell2mat(s))  / sqrt(length(cell2mat(t)))}, rt01.T, rt00.T, 'UniformOutput', false);
    
   
    TT = rt00m.T;
    for i = 1:numel(TT)
        if (~isempty(rt00m.T{i}))
            p00m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};
            p01m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};
            p00m = rt00m.T{i}{1};
            p00s = rt00s.T{i}{1};

            TT{i} = {[p00,p01,p10,p11]};
        else
            TT{i} = {nan};
        end
    end



rt2 = rt00;
rt2.T = TT;
rt3 = colateFieldResultTable(rt2, 'ga');
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
xx = @(h) xlim(h,[000000,]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
%tableUI(rt3,ptc,[{xx}, {wl1},{wl2}]);
tableUI(rt3,ptc,[]);
end


function p1(allData, pNames)

    

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

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
rt3 = colateFieldResultTable(rt2, 'ga');
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
xx = @(h) xlim(h,[000000,]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
%tableUI(rt3,ptc,[{xx}, {wl1},{wl2}]);
tableUI(rt3,ptc,[]);
end

function p2(allData, pNames)

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

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
pt = @(m) ...
    plot(m(1,:), (m(2,:)), '-ko' ,...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,1.0,0])
%,...
%    m(1,:), (m(3,:)), '--k',  m(1,:), (m(2,:) + m(3,:)), '-k');

ptrc = @(m, color) ...
    plot(m(1,:), (m(2,:)) ./ (m(2,:) + m(3,:)), 'Color', color);
xx = @(h) xlim(h,[000000,7000]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
tableUI(rt3,@customPlot,[]);
end

function slide1(allData, pNames)

partialData = []
for i = 1:numel(allData)
    ticks = allData(i).ticks;
    if (ticks < 5000 || mod(ticks,2000) == 0)
        partialData = [partialData; allData(i)];
    end
end

pNames = {'ticks', 'width'};    
rt = prepareTable(partialData, pNames, 'ticks');

xx = @(h) xlim(h,[000000,35]);
yy = @(h) ylim(h,[0,5000]);
font = @(h) set(h,'FontSize',12, 'FontWeight','Bold')
wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
labelX1 = @(h) set(h, 'XTick', []);
labelY1 = @(h) set(h, 'YTick', []);
tableUI(rt,@customPlot,[{font}, {labelX1}, {labelY1}]);
end

function slideRandom(allData, pNames)

pNames = {'ticks', 'width', 'ga'};    
rt = prepareTable(allData, pNames, 'ticks');

xx = @(h) xlim(h,[000000,35]);
yy = @(h) ylim(h,[0,5000]);
font = @(h) set(h,'FontSize',12, 'FontWeight','Bold')
wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
labelX1 = @(h) set(h, 'XTick', []);
labelY1 = @(h) set(h, 'YTick', []);
tableUI(rt,@customPlot,[{font}, {wl1}, {wl2}]);
end

function p2a(allData, pNames)

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

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
pt = @(m) ...
    plot(m(1,:), (m(2,:)), '-ko' ,...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0,1.0,0])
%,...
%    m(1,:), (m(3,:)), '--k',  m(1,:), (m(2,:) + m(3,:)), '-k');

ptrc = @(m, color) ...
    plot(m(1,:), (m(2,:)) ./ (m(2,:) + m(3,:)), 'Color', color);
xx = @(h) xlim(h,[000000,35]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
tableUI(rt3,@customPlot,[{}]);
end


function slideGrowth(allData, pNames)

pNames = {'ga', 'ticks'};
rt3 = createNDResultTable(allData, 'GvsN', pNames);
sc = @(m) scatter((m(1,:)), (m(2,:)));
xl1 = @(h) xlim(h,[0, 6]);
yl1 = @(h) ylim(h,[0, 0.002]);
gl1 = @(h) grid(h, 'off');
font = @(h) set(h,'FontSize',12, 'FontWeight','Bold')
tableUI(rt3,@plotScatterFit,[{yl1}, {gl1}, {font}]) ;
end

function plotScatterFit(m)
scatter((m(1,:)), (m(2,:)));
x = m(1,:);
y = m(2,:);

inRange = (y > 0 & y < 0.002);

x = x(inRange);
y = y(inRange);
Eqn = 'a*exp(-(b*x))';
startPoints = [0.001, 10];

f1 = fit(x',y',Eqn,'Start', startPoints);
plot(f1);

end


function rt = prepareTable(allData, pNames, colateBy)
rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

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
rt3 = colateFieldResultTable(rt2, colateBy);
%TT = rt3.T;
%     for i = 1:numel(TT)
%          A = TT{i}{1};
%          B = [0.25, 0.25, 0.25, 0.25];
%          TT{i}{1} = conv2(A,B,'valid');
%          
%     end
rt=rt3;
%rt.T = TT;
end

function customPlot(m)
hold on;
plot(m(1,:), (m(2,:) + m(3,:)), '-ko' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
plot(m(1,:), (m(2,:)), '-k^' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
plot(m(1,:), (m(3,:)), '-ks' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end

function shadedWL(rangesx, rangey, color)
    for i = 1:size(rangesx,2)
        ha = area(rangesx(:,i), [rangey(2), rangey(2)]);
        ha(1).FaceColor = color;
        uistack(ha(1), 'bottom')
        set(ha(1),'EdgeColor','None');
        hold on
    end
end