function presPlayground3(allData)
pNames = {'width', 'ticks', 's1'};
p11(allData, pNames)

end

function p2(allData, pNames)

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

end



function p1(allData, pNames)

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
        z = rt5Z.T{i}{1}
        c = rt5C.T{i}{1}
        v = cat(3,z,c(:,:,3));
        TT{i} = {v};
    else
        TT{i} = {nan};
    end
end
rt5.T = TT;


bar3plotLog = @(m) bar3nanColor(0.001 + log10(m(:,:,2)), m(:,:,4));
bar3plot = @(m) bar3nanColor(m(:,:,3), m(:,:,4));



numOfRows = 12;
numOfCols = 40;
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
font = @(h) set(h,'FontSize',16)
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,-1,1]);
gl1 = @(h) grid(h, 'on');
cLim =  @(h) caxis([0, 1]);
col =  @(h) colormap('cool');
hide = @(h) colorbar('off')
wl1 = @(h) shadedWL([reshape(2*(1:1:30),[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(2*(0:1:29),[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
% wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
% wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
wl1 = @(h) shadedWL([reshape(2*(1:1:20),[2,10])], [0, 15000], [249/255, 249/255, 249/255]);
wl2 = @(h) shadedWL([reshape(2*(0:1:19),[2,10])], [0, 15000], [206/255, 236/255, 1.0]);



tableUI(rt5, bar3plotLog,...
    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}, {font}, {col}, {hide} {cLim}, {wl1}, {wl2}]);

end

function p11(allData, pNames)

%pNames = {'repeat',  'attach', 'death', 'ticks'};
colateDim = 'ticks';
rt4C = createNDResultTable(allData, 'clusterHistL', pNames);
rt4Z = createNDResultTable(allData, 'clusterHist', pNames);


rt4 = rt4Z;
TT = rt4.T;
for i = 1:numel(rt4.T)
    if (~isempty(rt4.T{i}))
        z = rt4Z.T{i}{1}
        c = rt4C.T{i}{1}
        v = cat(1,z(1,:),c);
        TT{i} = {v};
    else
        TT{i} = {nan};
    end
end
rt4.T = TT;


bar3plotLog = @(m) bar3nanColor(0.001 + log10(m(:,:,2)), m(:,:,4));
bar3plot = @(m) bar3nanColor(m(:,:,3), m(:,:,4));

plot2 = @(m) plot(log2(m(3,:)), log10(m(1,:)));


numOfRows = 12;
numOfCols = 40;
labelX1 = @(h) set(h, 'XTick', 1:numOfRows);
labelX2 = @(h) set(h, 'XTickLabel', [power(2,0:numOfRows), inf]);
labelX2 = @(h) set(h, 'XTickLabel', [{1, '', 4,'',16,'',64,'',256,'',1024, ''}]);
%labelX2 = @(h) set(h, 'XTickLabel', [10:10:1000, inf]);
labelY1 = @(h) set(h, 'YTick', 1:numOfCols);
labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,colateDim))));
labelY2 = @(h) set(h, 'YTickLabel', []);
xLim = @(h) xlim(h,[0, 14]);
yLim = @(h) ylim(h,[0, numOfCols+1]);
zLim = @(h) zlim(h,[0, 4]);
font = @(h) set(h,'FontSize',16)
%rot = @(h) rotate(h,[0,0,1],25);
rot = @(h) view([1,-1,1]);
gl1 = @(h) grid(h, 'on');
cLim =  @(h) caxis([0, 1]);
col =  @(h) colormap('cool');
hide = @(h) colorbar('off')
wl1 = @(h) shadedWL([reshape(2*(1:1:30),[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
wl2 = @(h) shadedWL([reshape(2*(0:1:29),[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
% wl1 = @(h) shadedWL([reshape(1000:1000:30000,[2,15])], [0, 15000], [1.0, 0.95, 0.65]);
% wl2 = @(h) shadedWL([reshape(000:1000:29000,[2,15])], [0, 15000], [0.75, 0.75, 1.0]);
wl1 = @(h) shadedWL([reshape(2*(1:1:20),[2,10])], [0, 15000], [249/255, 249/255, 249/255]);
wl2 = @(h) shadedWL([reshape(2*(0:1:19),[2,10])], [0, 15000], [206/255, 236/255, 1.0]);



tableUI(rt4, plot2,[{xlim}])
%,...
%    [{labelX1}, {labelX2}, {labelY1}, {labelY2}, {rot}, {xLim}, {yLim}, {zLim}, {rot}, {gl1}, {font}, {col}, {hide} {cLim}, {wl1}, {wl2}]);

end

function customPlot(m)
hold on;
plot(m(1,:), (m(2,:) + m(3,:)), '-ko' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,0,0]);
plot(m(1,:), (m(2,:)), '-k^' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0,1.0,0]);
plot(m(1,:), (m(3,:)), '-kv' , 'LineWidth',2, 'MarkerSize',10, 'MarkerEdgeColor','k', 'MarkerFaceColor',[1.0,0.0,0]);
end

function shadedWL(rangesx, rangey, color)
    for i = 1:size(rangesx,2)
        % ha = area( [rangey(2), rangey(2)], rangesx(:,i));
        x1 = rangesx(1,i);
        x2 = rangesx(2,i);
        y1 = rangey(1);
        y2 = rangey(2);
        z = -0.001;
        ha = patch( [y1 y1 y2 y2 y1], [x1 x2 x2 x1 x1], [z z z z z] );
        ha(1).FaceColor = color;
        % uistack(ha(1), 'bottom')
        set(ha(1),'EdgeColor','None');
        hold on
    end
end
