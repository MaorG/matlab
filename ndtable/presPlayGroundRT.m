function presPlayGroundRT( rt )

xl1 = @(h) xlim(h,[0, 36]);
labelY1 = @(h) set(h, 'YTick', [2000, 4000]);
labelX1 = @(h) set(h, 'XTick', [4,6,8,10,12,14,16,32,100]);
ticks = @(h) set(h,'ticklength',[0 0])

font = @(h) set(h,'FontSize',12, 'FontWeight','Bold');
tableUI(rt,@customPlotError,[{font}, {xl1}, {labelY1}, {labelX1}, {ticks}]);
end

function customPlot(m)
hold on;
plot(m(1,:), (m(2,:) + m(3,:)), '-ko' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
plot(m(1,:), (m(2,:)), '-k^' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
plot(m(1,:), (m(3,:)), '-ks' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end

function customPlotError(m)
hold on;
errorbar(m(1,:), m(6,:), m(7,:), '-ko' , 'LineWidth',1, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
errorbar(m(1,:), m(2,:), m(3,:), '-k^' , 'LineWidth',1, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
errorbar(m(1,:), m(4,:), m(5,:), '-ks' , 'LineWidth',1, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end