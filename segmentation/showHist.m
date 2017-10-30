function showHist(allData) 

pNames = {'time', 'conc', 'signal'};

myplot = @(m) plot((m(2,:)),m(1,:),'--o');
xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')
ylimit = @(h) ylim([0,10000]);
xlimit = @(h) xlim([0,2^20]);

countBins = [power(2,0:8)];
allData = scoreAllData(allData, 'countHist', @getCountHistogram, countBins);
rt1 = createNDResultTable(allData, 'countHist', pNames);
rt2 = colateFieldResultTable(rt1, 'time');

%tableUI(rt1,myplot, [{ylog},{xlog}]); 

bar3plotLog = @(m) bar3nanColor(log10(m(2:2:end,:,3)), log10(m(1:2:end,:,3)));
bar3plotLog = @(m) bar3nanColor(log10(m(1:end,:,3)), log10(m(1:end,:,3)));

    labelX1 = @(h) set(h, 'XTick',  1:numel(countBins));
    labelX2 = @(h) set(h, 'XTickLabel',  (countBins));
    
    labelY1 = @(h) set(h, 'YTick', 2:2:21, 'YTickLabel',  0.5 * (2:2:21) ,'YTickLabelRotation',0,'fontsize', 20);
    labelZ1 = @(h) set(h, 'ZTick', 0:4, 'ZTickLabel', 0:4);
    
    xLim = @(h) xlim(h,[0, nbins]);
    yLim = @(h) ylim(h,[0, 1+ numel(unique(extractfield(allData,'time')))]);
    
    xlab = @(h) xlabel('cluster size (#)');
    ylab = @(h) ylabel('time(h)');
    zlab = @(h) zlabel('count (log10)');
    rot = @(h) view([1,-0.5,2]);
    col = @(h) caxis([0,4]);
    colm = @(h) colormap('spring');
    gridon = @(h) set(h, 'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on');

    %zlog = @(h) set(h2(ii),'yscale','log');


tableUI(rt2,bar3plotLog, [{labelX1},{labelX2},{labelY1},{labelZ1}, {xlab},{ylab},{zlab},{rot},{col},{gridon}]); 

plotLineC =  @(m) plotGradientColor( log2(m(:,:,2)), log10(m(:,:,3)), (m(:,:,1)));
%tableUI(rt2,plotLineC,[]);

end