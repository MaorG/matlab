function [] = presPlayground4(allData)
pNames = {'ticks', 's1', 'width'};    
%slide1(allData, pNames);

p1(allData,pNames)
% for const conditions

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
xx = @(h) xlim(h,[000000,]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
%tableUI(rt3,ptc,[{xx}, {wl1},{wl2}]);
tableUI(rt3,[],[]);
end

function p2(allData, pNames)

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

    rt0 = createNDResultTable(allData, 'p1', pNames);
    rt1 = createNDResultTable(allData, 'p2', pNames);
    
    TT = rt00.T;
    for i = 1:numel(rt00.T)
        if (~isempty(rt00.T{i}))
            p00 = mean(cell2mat(rt0.T{i}));
            p01 = mean(cell2mat(rt1.T{i}));
            TT{i} = {(p00+p01)};
        else
            TT{i} = {nan};
        end
    end



rt2 = rt00;
rt2.T = TT;

tableUI(rt2,[],[]);
end

function p2mean(allData, pNames)

    rt00 = createNDResultTable(allData, 'p00', pNames);
    rt01 = createNDResultTable(allData, 'p01', pNames);
    rt10 = createNDResultTable(allData, 'p10', pNames);
    rt11 = createNDResultTable(allData, 'p11', pNames);

    rt0 = createNDResultTable(allData, 'p1', pNames);
    rt1 = createNDResultTable(allData, 'p2', pNames);

    
    TT = rt00.T;
    for i = 1:numel(rt00.T)
        if (~isempty(rt00.T{i}))
            
            m0 = mean(cell2mat(rt00.T{i}) + cell2mat(rt01.T{i}));
            s0 = std(cell2mat(rt00.T{i}) + cell2mat(rt01.T{i}))/sqrt(5);
            m1 = mean(cell2mat(rt10.T{i}) + cell2mat(rt11.T{i}));
            s1 = std(cell2mat(rt10.T{i}) + cell2mat(rt11.T{i}))/sqrt(5);

            
            rm0 = mean(cell2mat(rt1.T{i}) ./ (cell2mat(rt0.T{i})+ cell2mat(rt1.T{i})));
            rs0 = std(cell2mat(rt1.T{i}) ./ (cell2mat(rt0.T{i})+ cell2mat(rt1.T{i}))) / sqrt(5);
            
            
            TT{i} = {[rm0,rs0]};
        else
            TT{i} = {nan};
        end
    end



rt2 = rt00;
rt2.T = TT;
rt3 = colateFieldResultTable(rt2, 'ticks');
%rt3 = colateFieldResultTable(rt3, 's1');

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

wl1 = @(h) shadedWL([reshape(1000:1000:40000,[2,20])], [0, 20000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:39000,[2,20])], [0, 20000], [0.75, 0.75, 1.0]);
tableUI(rt3,@customPlotErrColor,[{wl1},{wl2}]);
%tableUI(rt3,@customSurfPlot,[]);
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
wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [249/255, 249/255, 249/255]);
wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [206/255, 236/255, 1.0]);
labelX1 = @(h) set(h, 'XTick', []);
labelY1 = @(h) set(h, 'YTick', []);
tableUI(rt,@customPlot,[{font}, {labelX1}, {labelY1}]);
end


function slideRandom(allData, pNames)

pNames = {'ticks', 'width', 'ga'};    
rt = prepareTable(allData, pNames, 'ga');

xx = @(h) xlim(h,[000000,35]);
yy = @(h) ylim(h,[0,5000]);
font = @(h) set(h,'FontSize',12, 'FontWeight','Bold')
wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [249/255, 249/255, 249/255]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [206/255, 236/255, 1.0]);
labelX1 = @(h) set(h, 'XTick', []);
labelY1 = @(h) set(h, 'YTick', []);
tableUI(rt,@customPlot,[{font}, {}]);
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
rt3 = colateFieldResultTable(rt2, 'ga');
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
xx = @(h) xlim(h,[000000,30000]);
yy = @(h) ylim(h,[0,5000]);
font = @(h) set(h,'FontSize',12, 'FontWeight','Bold')
wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [249/255, 249/255, 249/255]);
wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [206/255, 236/255, 1.0]);

labelX1 = @(h) set(h, 'XTick', []);
labelY1 = @(h) set(h, 'YTick', [5000,15000]);
%tableUI(rt3,@customPlot,[]);
tableUI(rt3,@customPlot,[{wl1}, {wl2}, {xx}]);
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

function dual(allData, pNames, colateBy) 

expression = '[\w\.]*';
for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).ga1 = str2double(nums{8});
   nums = regexp(allData(i).stratexpr2,expression,'match');
   allData(i).ga2 = str2double(nums{8});
end


yy = @(h) ylim(h,[0,5000]);
    pNames = {'ga1', 'ga2', 'ticks', 'width'};
    colateBy = '';
    rt = prepareTable(allData, pNames, colateBy);
    tableUI(rt,[],[]) ;

end

function dualHist(allData, pNames, colateBy) 

expression = '[\w\.]*';
for i = 1:numel(allData)
   nums = regexp(allData(i).stratexpr1,expression,'match');
   allData(i).ga1 = str2double(nums{8});
   nums = regexp(allData(i).stratexpr2,expression,'match');
   allData(i).ga2 = str2double(nums{8});
end




yy = @(h) ylim(h,[0,5000]);
    pNames = {'ga1', 'ga2', 'ticks', 'width'};
    colateBy = 'ticks';
    rt = createNDResultTable(allData, 'clusterHistByType', pNames);
    
    rtu = createNDResultTable(allData, 'clusterHist', pNames);
    rtut = colateFieldResultTable(rtu, colateBy);
    bar3plotLog = @(m) bar3nan(log10(m(:,:,3)));
    
    
    rt1 = rt;
    rt2 = rt;
    rt3 = rt;
    
    for i = 1:numel(rt.T)
       rt1.T{i} = {[rt.T{i}{1}(2,:); rt.T{i}{1}(1,:)] };
       rt2.T{i} = {[rt.T{i}{1}(3,:); rt.T{i}{1}(1,:)] };
       rt3.T{i} = {[rt.T{i}{1}(4,:); rt.T{i}{1}(1,:)] };
    end
    
    rt1t = colateFieldResultTable(rt1, colateBy);
    rt2t = colateFieldResultTable(rt2, colateBy);
    rt3t = colateFieldResultTable(rt3, colateBy);

    rtt = rt1t;
    for i = 1:numel(rtt.T)
       rtt.T{i} = {cat(3, ...
           rt1t.T{i}{1}(:,:,1), ...
           rt1t.T{i}{1}(:,:,2), ...
           rt1t.T{i}{1}(:,:,3), ...
           rt2t.T{i}{1}(:,:,3), ...
           rt3t.T{i}{1}(:,:,3)  )};

    end
    
    for i = 1:numel(rtt.T)
        m = rtt.T{i}{1};
        n = rtut.T{i}{1};
        
        mm = m(:,:,3) + m(:,:,4) + m(:,:,5);
        nn = n(:,:,3);
        
        mm-nn
    end
    
    
    
    
    numOfRows = 12;
    numOfCols = 20;
    labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
    labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
    labelX2 = @(h) set(h, 'XTickLabel', [{1, '', 4,'',16,'',64,'',256,'',1024, ''}]);
    %labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
    labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
    labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,colateDim))));
    labelY2 = @(h) set(h, 'YTickLabel', []);
    xLim = @(h) xlim(h,[0, numOfRows+1]);
    yLim = @(h) ylim(h,[0, numOfCols+1]);
    zLim = @(h) zlim(h,[0, 4]);
    font = @(h) set(h,'FontSize',16);
    %rot = @(h) rotate(h,[0,0,1],25);
    rot = @(h) view([1,-1,1]);
    gl1 = @(h) grid(h, 'on');
    cLim =  @(h) caxis([0, 1]);
    col =  @(h) colormap('cool');
    tableUI(rtt,@plotTypeHist,...
     [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}, {font}, {col}, {cLim}]);


end

function plotTypeHist(m)
hold on;

mz = log10(m(:,:,3) + m(:,:,4) + m(:,:,5));
mc = ( m(:,:,3) + m(:,:,4) ) ./ (m(:,:,3) + m(:,:,4) + m(:,:,5));

bar3nanColor(mz, mc)
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
            TT{i} = {sum([p00,p01,p10,p11])};
        else
            TT{i} = {nan};
        end
    end



rt = rt00;
rt.T = TT;
if (ischar(colateBy))
rt3 = colateFieldResultTable(rt, colateBy);
%TT = rt3.T;
%     for i = 1:numel(TT)
%          A = TT{i}{1};
%          B = [0.25, 0.25, 0.25, 0.25];
%          TT{i}{1} = conv2(A,B,'valid');
%          
%     end
rt=rt3;
end 
%rt.T = TT;
end

function customPlotDual(m)
hold on;
plot((m(1,:)), (m(2,:) + m(3,:) + m(4,:) + m(5,:)), '-k' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
end

function customPlot(m)
hold on;
plot((m(1,:)), (m(2,:) + m(3,:)), '-ko' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
plot((m(1,:)), (m(2,:)), '-k^' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
plot((m(1,:)), (m(3,:)), '-ks' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end

function customPlotErr(m)
hold on;
errorbar((m(1,:)), m(2,:), m(3,:), '-ko' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
errorbar((m(1,:)), m(4,:), m(5,:), '-k^' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
errorbar((m(1,:)), m(6,:), m(7,:),'-ks' , 'LineWidth',1.5, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end
function customPlotErrColor2(m, color)
hold on;
errorbar((m(1,:)), m(2,:), m(3,:), '-r' );
errorbar((m(1,:)), m(4,:), m(5,:), '-g^');
end

function customSurfPlot(m, color)
hold on;
surf(m(:,:,1),m(:,:,2),m(:,:,3));
xlabel('time')
ylabel('S2')
zlabel('relative abundance')
    %rot = @(h) rotate(h,[0,0,1],25);
view([1,-1,1]);

end

function customPlotErrColor(m, color)
hold on;
errorbar((m(1,:)), m(2,:), m(3,:), '-k' );
%errorbar((m(1,:)), m(4,:), m(5,:), '-g^');
xlabel('time');
ylabel('species 2 relative abundance');
ylim([0,1]);
xlim([0,40000]);
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