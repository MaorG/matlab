function allData = script_live_dead_config(configName)

addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable');

% function allData = getAllData(dirName)

allData = config2data(configName);

imageRect = [];

if (~isempty(imageRect))
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I(imageRect(1):imageRect(2),imageRect(3):imageRect(4)));
    end
else
    for i = 1:numel(allData)
        allData(i).I = (allData(i).I);
    end  
end

allData = getLiveDeadChannels(allData, [0.5,0.5]);

allData = scoreAllData(allData, 'Seg', @getOptimalSegmentationFromBitmap, ...
    'imageName', 'I', 'laplacianSize', 3, 'clusterDilateRadius', 4, 'thresholds', [0.1:0.05:0.6],...
    'optimalPropNames', {'MinorAxisLength', 'MajorAxisLength'},...
    'optimalPropRanges', {[3,5], [8,15]}, ...
    'sampleRect', [] ...
    );
    
for i = 1:numel(allData)
    allData(i).Seg.clusterDilateRadius = 4;
    allData(i).Seg = allData(i).Seg.getClusters;
end

allData = scoreAllData(allData, 'clusters', @getClustersFromSeg, 'SegName', 'Seg');

doStuff(allData);

end

function doStuff(allData)

d = allData(1);
cc = getLiveDeadInClusters(d, {'liveDeadIntensityCoeff', [1.0,0.75]})
figure

%scatter(cc.count, cc.liveRatio - 0.01 + rand(numel(cc.liveRatio), 1) * 0.02);

hold on

% [countVals,~,idxByCount] = unique(cc.count);
% averageRatioOfCount = zeros(size(countVals));
% for i = 1:numel(countVals)
%     
%     ratios = cc.liveRatio(find(idxByCount == i));
%     averageRatioOfCount(i) = mean(ratios);
%     
% end
%scatter(countVals, averageRatioOfCount, 'r+');

bins = [power(2,0:8)];
[N,edges,bin] = histcounts(cc.count,bins);
averageRatioOfBin = zeros(size(N));
SErrOfBin = zeros(size(N));
for i = 1:numel(N)
    
    val = i;
    binRatios = cc.liveRatio(find(bin == i));
    averageRatioOfBin(i) = mean(binRatios);
    SErrOfBin(i) = std(binRatios) ./ sqrt(numel(binRatios));
    
end
top = averageRatioOfBin;
top(isnan(top)) = 0;
bot = zeros(size(top));
left = bins(1:end-1);
right = bins(2:end);
height = top - bot;
width = right - left;

% for ii=1:length(top)
%     rectangle('Position',[left(ii) bot(ii) width(ii)   height(ii) ])
%     line([left(ii) + right(ii),left(ii) + right(ii)]*0.5, [height(ii) + SErrOfBin(ii), height(ii) - SErrOfBin(ii)],'Color','black');
% end

errorbar(left, height, SErrOfBin, 'ok-','MarkerFaceColor','white');
set(gca,'xscale','log')
ylim([0,1])
xlim([0,150])
%fitobject = fit(cc.count, cc.liveRatio, 'smoothingspline','SmoothingParam',0.000001);
hold on
%plot(fitobject)
xlabel('aggregate size - #(cells)')
ylabel('ratio of living cells')

ylim([0,1]);
set(gca,'xscale','log')

end

