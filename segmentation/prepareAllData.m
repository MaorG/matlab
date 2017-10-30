function allData = prepareAllData(allData)

for i = 1:numel(allData)
    allData(i).time = str2num(allData(i).fileName(6:7));
    
    if strcmpi('C1', allData(i).fileName(9:10))
        allData(i).conc = 22;
        allData(i).signal = 0;
    elseif strcmpi('C2', allData(i).fileName(9:10))
        allData(i).conc = 22;
        allData(i).signal = 1;
    elseif strcmpi('C4', allData(i).fileName(9:10))
        allData(i).conc = 2.2;
        allData(i).signal = 0;
    elseif strcmpi('C5', allData(i).fileName(9:10))
        allData(i).conc = 2.2;
        allData(i).signal = 1;
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
    'imageName', 'I', 'laplacianSize', 4, 'clusterDilateRadius', 4, 'thresholds', [0.2:0.025:0.5],...
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