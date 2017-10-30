function [] = playground4(allData)
    p2a(allData);
end

function p1(allData)

    pNames = {'ticks', 'attach', 's1'};

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
xx = @(h) xlim(h,[000000,20000]);
yy = @(h) ylim(h,[0,5000]);

wl1 = @(h) shadedWL([reshape(1000:1000:20000,[2,10])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(000:1000:19000,[2,10])], [0, 15000], [0.75, 0.75, 1.0]);
tableUI(rt3,ptc,[{wl1},{wl2}]);
end

function p2(allData)

    pNames = {'ticks', 'width', 's1'};

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
tableUI(rt3,@customPlot,[{wl1},{wl2}]);
end

function p2a(allData)

    pNames = {'ticks', 'width', 's1'};

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
rt3 = colateFieldResultTable(rt2, 's1');
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
tableUI(rt3,@customPlot,[{xx}]);
end

function customPlot(m)
hold on;
plot(m(1,:), (m(2,:) + m(3,:)), '-ko' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
plot(m(1,:), (m(2,:)), '-k^' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
plot(m(1,:), (m(3,:)), '-kv' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
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