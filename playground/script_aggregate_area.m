%% area distribution

init

%%


configName = 'C:\school\microscopy\27.11.17\config1.txt';
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

allData = scoreAllData(allData, 'clusters', @getClustersFromBitmap,...);
        'minClusterArea', 10,...
        'clusterDilation', 4,...
        'threshold', 5000,...
        'nameI', 'I');