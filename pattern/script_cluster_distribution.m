

dirNameSeg = 'C:\school\microscopy\24.4.17\dist\';

minClusterArea = 10;
clusterDilation = 6;

allData = dir2data(dirNameSeg, true);

% addparams
[allData.temp]=deal(0);


% apply filters
for i = 1:numel(allData)

   
    % connect clusters
    se = strel('disk',clusterDilation);
    allData(i).J = imclose(allData(i).I, se);
    
        % min area
    allData(i).J = bwareaopen(allData(i).J, minClusterArea);
end

% apply changes
for i = 1:numel(allData)
    allData(i).I = allData(i).J;
    allData(i).J = [];
end

% calc cluster area and location
[allData.clusters]=deal(struct);
for i = 1:numel(allData)
    CC = bwconncomp(allData(i).I);
    
    tempCenters = regionprops(CC,'Centroid');
    centers = cat(1, tempCenters.Centroid);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    
    allData(i).clusters.centers = centers;
    allData(i).clusters.areas = numPixels';
    
end

%extract 

addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable')  


bins = power(1.5,6:30);
nbins = numel (bins);

allData = scoreAllData(allData, 'areaHist', @getAreaHistogram, bins);
pNames = {'dirName', 'fileName', 'temp'};
rt1 = createNDResultTable(allData, 'areaHist', pNames);
rt2 = colateFieldResultTable(rt1, 'dirName');


xLim = @(h) xlim(h,[0, nbins+1]);
yLim = @(h) ylim(h,[0, numOfCols+1]);

plotbar = @(m) bar(m(2,:), m(1,:));
%tableUI(rt1,plotbar, []); 


    labelX1 = @(h) set(h, 'XTick', 1:13);
    labelX2 = @(h) set(h, 'XTickLabel', [power(1.1,0:nbins), inf]);
    
    labelY1 = @(h) set(h, 'YTick', 1:numel(unique(extractfield(allData,'time'))));
    labelY2 = @(h) set(h, 'YTickLabel', sort(unique(extractfield(allData,'time'))));
    
    xLim = @(h) xlim(h,[0, nbins]);
    yLim = @(h) ylim(h,[0, 1+ numel(unique(extractfield(allData,'time')))]);
    
    xlab = @(h) xlabel('cluster size (#)');
    ylab = @(h) ylabel('time');
    zlab = @(h) zlabel('count log10');
    
    zlog = @(h) set(h2(ii),'yscale','log')
 rot = @(h) view([1,-1,1]);
bar3plotLog = @(m) bar3nan((m(:,:,3)));

barPlot = @(m) bar((1:numel(m(1,:,2)))', m(:,:,3)');
barPlot = @(m) bar(log10(m(1,1:end-1,2))', log10(m(:,1:end-1,3)'));

myplot = @(m) plot(m(2,:),m(1,:));

xlog = @(h) set(h,'xscale','log')
ylog = @(h) set(h,'yscale','log')

%tableUI(rt2,bar3plotLog, [{labelX1},{labelY1}, {labelX2},{labelY2}, {rot},{xLim},{yLim}, {xlab}, {ylab}, {zlab}]); 
tableUI(rt2,barPlot, []); 
tableUI(rt1,myplot, [{xlog}, {ylog}]); 

