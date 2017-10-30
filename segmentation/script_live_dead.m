function allData = script_live_dead(dirName, op)

addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable');

% function allData = getAllData(dirName)

allData = dir2data(dirName,true);

for i = 1:numel(allData)
    allData(i).time = str2num(allData(i).fileName(6));
    if isempty(allData(i).time)
        allData(i).time = 1;
    end
        
    if strcmpi('rfp', allData(i).fileName(end-2:end))
        allData(i).channel = 'rfp';
    elseif strcmpi('gfp', allData(i).fileName(end-2:end))
        allData(i).channel = 'gfp';
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

allData = getLiveDeadChannels(allData, [0.5,0.5]);

allData = scoreAllData(allData, 'Seg', @getOptimalSegmentationFromBitmap, ...
    'imageName', 'I', 'laplacianSize', 3, 'clusterDilateRadius', 4, 'thresholds', [0.1:0.05:0.6],...
    'optimalPropNames', {'MinorAxisLength', 'MajorAxisLength'},...
    'optimalPropRanges', {[3,5], [8,20]}, ...
    'sampleRect', [] ...
    );
    
for i = 1:numel(allData)
    allData(i).Seg.clusterDilateRadius = 2;
    allData(i).Seg = allData(i).Seg.getClusters;
end

allData = scoreAllData(allData, 'clusters', @getClustersFromSeg, 'SegName', 'Seg');


 return; 
% R = allData(1).SegDead.BWcells;
% G = allData(1).SegLive.BWcells;
% B = allData(1).Seg.BWcells;
% imshow(double(cat(3,R,G,B)))
% 
% R = allData(2).SegDead.BWcells;
% G = allData(2).SegLive.BWcells;
% B = allData(2).Seg.BWcells;
% imshow(double(cat(3,R,G,B)))
% 
% figure
% imshow(cat(3, allData(1).deadI, allData(1).liveI, zeros(size(allData(1).deadI))));
% figure
% imshow(cat(3, allData(2).deadI, allData(2).liveI, zeros(size(allData(2).deadI))));
% 
% R = allData(1).deadI;
% R = double(R) ./ 255;
% G = allData(1).liveI;
% G = double(G) ./ 255;
% B = allData(1).Seg.BWcells;
% B = double(B);
% 
% imshow(cat(3,R.*B > G.*B, G.*B > R.*B ,zeros(size(B))));


cc = getLiveDeadInClusters(d, {'liveDeadIntensityCoeff', [1.0,0.75]})
figure
scatter(cc.count, cc.liveRatio)
fitobject = fit(cc.count, cc.liveRatio, 'smoothingspline','SmoothingParam',0.001);
hold on
plot(fitobject)

end

