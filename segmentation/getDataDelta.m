function dataPrev = getDataDelta(data1,data2,verbose)


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

clusterDilation = 20;
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

dataPrev.Rclusters = data1.clusters;
dataPrev.Gclusters = Gclusters;

if (verbose)
    dataPrev.pI = pI;
    dataPrev.pIc = pIc;
    dataPrev.cleanNI = cleanNI;
end