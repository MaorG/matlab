function series = scriptBF_17_5_17(dirName)
addpath('C:\matlab\imaging\matlab\pattern');
addpath('C:\simulators\RepastSimphony-2.3.1\matlab\ndtable');



allData = dir2data(dirName,true);

for i = 1:numel(allData)
    allData(i).time = str2num(allData(i).fileName(6:7));
    
    if double(allData(i).fileName(9) == 'C')
        allData(i).conc = 0.22;
    else
        allData(i).conc = 22;
    end
    allData(i).signal = double(str2num(allData(i).fileName(10)) == 2);
end  

imageRect = [];

if (~isempty(imageRect))
    for i = 1:numel(allData)
        allData(i).I = imcomplement(allData(i).I(imageRect(1):imageRect(2),imageRect(3):imageRect(4)));
    end
else
    for i = 1:numel(allData)
        allData(i).I = imcomplement(allData(i).I);
    end  
end



% negative for BF



allData = scoreAllData(allData, 'Seg', @getOptimalSegmentationFromBitmap, ...
    'imageName', 'I', 'laplacianSize', 4, 'clusterDilateRadius', 4, 'thresholds', [0.01:0.01:0.2],...
    'optimalPropNames', {'MinorAxisLength', 'MajorAxisLength'},...
    'optimalPropRanges', {[3,5], [8,20]}, ...
    'sampleRect', [] ...
);

% explict cluster dilation and creation of BWclusters

for i = 1:numel(allData)
    allData(i).Seg.clusterDilateRadius = 40;
    allData(i).Seg = allData(i).Seg.getClusters;
end

allData = scoreAllData(allData, 'clusters', @getClustersFromSeg2);


series = [];
for i = 1:numel(allData)-1
    series = [series, comparePair(allData(i),allData(i+1))];
end

end

% initial BF scripts - try to identify new attachments by delta of 2 images

function dataPrev = comparePair(data1,data2)


% get newcomers bw image by substracting the dilated prev image dpI from the
% next image nI
% a nice touch would be to remove all cells in the next image that touch
% the prev image
% this can be done by 
% 1. finding the intersection II between white pixels in A: the
% dilated pI and B: the nI
% 2. removing all regions in the next image that include any of the II
% pixels

pI = data1.Seg.BWcells;

clusterDilation = 30;
se = strel('disk',clusterDilation);
dpI = imdilate(pI, se);

nI = data2.Seg.BWcells;

dpI = imfill(dpI,'holes');



se = strel('disk',5);
dnI = imdilate(nI, se);


% add some preliminary check - bounding boxes?

dpIPixels = find(dpI(:));

%cleanNI = false(size(nI));

% should optimize!!!
% for i = 1:numel(rp)
%     if (isempty(intersect(rp(i).PixelIdxList, dpIPixels)))
%         cleanNI(rp(i).PixelIdxList) = 1;
%     end
% end

cleanNI = dnI & not(dpI);

% so now we have cleanNI with definitely only newcomers
% now do the spatial analysis of the centers of cleanNI (perhaps only the
% small ones..) and clusters in pI, with a more modest dilation amount.
% this is basically 'getAttachVsAreaVsDist' - so current data format should 
% be adapted to match it:




dataPrev = data1;
clusterDilation = 5;
se = strel('disk',clusterDilation);
pIc = imclose(pI, se);

% push into a func!
Rclusters = struct;
CC = bwconncomp(pIc);
rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
centers = cat(1, rp.Centroid);
pixels = cell(numel(rp),1);
for ii = 1:numel(rp)
    pixels{ii} = rp(ii).PixelList;
end
areas = cat(1, rp.Area);
ids = find(areas > 10);
Rclusters.centers = centers(ids,:);
Rclusters.areas = areas(ids,:);
Rclusters.pixels = pixels(ids,:);
Rclusters.imageSize = size(pIc);

% push into a func!
Gclusters = struct;
CC = bwconncomp(cleanNI);
rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
centers = cat(1, rp.Centroid);
pixels = cell(numel(rp),1);
for ii = 1:numel(rp)
    pixels{ii} = rp(ii).PixelList;
end
areas = cat(1, rp.Area);
ids = find(areas > 10 & areas < 500);
Gclusters.centers = centers(ids,:);
Gclusters.areas = areas(ids,:);
Gclusters.pixels = pixels(ids,:);
Gclusters.imageSize = size(cleanNI);

% each data


%dataPrev.debugI = (double(cat(3,dpI,nI,cleanNI)));

dataPrev.Rclusters = Rclusters;
dataPrev.Gclusters = Gclusters;

end

% pNames = {'dirName', 'fileName'};
% rt5 = createNDResultTable(dataPrev, 'AvAvD_3_33_168', pNames);
% tableUI(rt5,@showAttachVsAreaVsDist,[]);
% 
% dataPrev = scoreAllData(dataPrev, 'AvAvD_3_33_168c', @getAttachVsAreaVsDist,'Rclusters','Gclusters',[power(1.5,4:24)], [3:33:168],1);
% dataPrev.dum = 0;
% pNames = {'dirName', 'fileName'};
% rt5 = createNDResultTable(dataPrev, 'AvAvD_3_33_168c', pNames);
% tableUI(rt5,@showAttachVsAreaVsDist,[]);

