function showMulti(allData)

pNames = {'ticks', 'width', 'repeats'};    
multi(allData,pNames)
end

function multi(allData, pNames)

    rt1 = createNDResultTable(allData, 'p1', pNames);
    rt2 = createNDResultTable(allData, 'p2', pNames);
    rt3 = createNDResultTable(allData, 'p3', pNames);
    rt4 = createNDResultTable(allData, 'p4', pNames);
    rt5 = createNDResultTable(allData, 'p5', pNames);
    rt6 = createNDResultTable(allData, 'p6', pNames);
    rt7 = createNDResultTable(allData, 'p7', pNames);
    rt8 = createNDResultTable(allData, 'p8', pNames);

    
    TT = rt1.T;
    for i = 1:numel(rt1.T)
        if (~isempty(rt1.T{i}))

            p1 = rt1.T{i}{1};
            p2 = rt2.T{i}{1};
            p3 = rt3.T{i}{1};
            p4 = rt4.T{i}{1};
            p5 = rt5.T{i}{1};
            p6 = rt6.T{i}{1};
            p7 = rt7.T{i}{1};
            p8 = rt8.T{i}{1};
            TT{i} = {[p1,p2,p3,p4,p5,p6,p7,p8]};
        
        else
            TT{i} = {nan};
        end
    end



rt2 = rt1;
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
tableUI(rt3,@customPlotSpeciesColor,[]);
tableUI(rt3,@customPlotTot,[]);
%tableUI(rt3,@customSurfPlot,[]);{wl1},{wl2}
end

function customPlotSpeciesColor(m)
hold on;
tot = sum(m(2:end,:),1);
colors = hsv(7);
for i = 1:7
     plot(m(1,:),m(1+i,:)./tot,'MarkerEdgeColor',colors(i,:));
end
%plot(m(1,:),tot);
hold off
legend('4','6','8','10','12','14','16');
%errorbar((m(1,:)), m(4,:), m(5,:), '-g^');
xlabel('time');
ylabel('species 2 relative abundance');
%ylim([0,1]);
xlim([0,40000]);
end

function customPlotTot(m)
hold on;
tot = sum(m(2:end,:),1);
colors = hsv(7);

plot(m(1,:),tot);
hold off
%legend('4','6','8','10','12','14','16');
%errorbar((m(1,:)), m(4,:), m(5,:), '-g^');
xlabel('time');
ylabel('species 2 relative abundance');
%ylim([0,1]);
xlim([0,40000]);
end