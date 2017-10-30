% todo:

% work on smaller datasets - prepare on option in 'segmentImagesInDir' that
% will only keep a region of original files

% create a cleanup func in 'getOptimalSegmentationFromBitmap' that will discard images of clusters if flaged

% rules for optimal segmentation should not only score positively within
% range but also negatively out of range.
% - scores should be collected in rows of matrix
% - +1 for all-positive columns and -1 for others (or all-negative)
% - if this doesnt work, score numerically (like a gaussian with a negative
% baseline)

% due to artifact on borders - conv2 by 'valid', pad result back to
% original shape (or just black the borders

% how to deal with cluster statistics?
% when analyzing series, output cluster into a separate data struct, out of
% the original allData
% regarding specific cluster statistics
% - cell size vs cluster size vs time
% -- perhpas differentiate also by cluster 'age' (requires tracking)
% - density in cluster
% -- requires image?
% - growth rate of clusters
% -- requires tracking

for i = 1:numel(allData)
allData(i).temp = [];
for j = 1:numel(allData(i).Seg.clusters)
t = struct;
t.totalArea = sum (allData(i).Seg.clusters(j).Image(:) > 0);
t.cellArea = sum (allData(i).Seg.clusters(j).Image(:) > 0.5);
allData(i).temp = [allData(i).temp ; t];
end
end
