function allData = prepareAllData2(allData)

for i = 1:numel(allData)
    allData(i).time = str2num(allData(i).fileName(6:7));
    
    if strcmpi('A1', allData(i).fileName(9:10))
        allData(i).conc = 2000;
        allData(i).signal = 0;
    elseif strcmpi('A5', allData(i).fileName(9:10))
        allData(i).conc = 200;
        allData(i).signal = 0;
    elseif strcmpi('B3', allData(i).fileName(9:10))
        allData(i).conc = 20;
        allData(i).signal = 0;
    end
end  

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






allData = scoreAllData(allData, 'Seg', @getOptimalSegmentationFromBitmap, ...
    'imageName', 'I', 'laplacianSize', 4, 'clusterDilateRadius', 4, 'thresholds', [0.2:0.05:0.25],...
    'optimalPropNames', {'MinorAxisLength', 'MajorAxisLength'},...
    'optimalPropRanges', {[3,5], [8,20]}, ...
    'sampleRect', [] ...
);

% explict cluster dilation and creation of BWclusters

for i = 1:numel(allData)
    allData(i).Seg.clusterDilateRadius = 4;
    allData(i).Seg = allData(i).Seg.getClusters;
end

allData = scoreAllData(allData, 'clusters', @getClustersFromSeg);
end