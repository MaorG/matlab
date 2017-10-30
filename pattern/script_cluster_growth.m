dirNameSeg = 'C:\school\microscopy\exp170405\dist\bimodal\Seg\';

series = dir2data(dirNameSeg);

for i = 1:numel(series)
    series(i).time = str2double(series(i).fileName(9:10));
    
end

for i = 1:numel(series)

   
    % connect clusters
    se = strel('disk',clusterDilation);
    series(i).J = imclose(series(i).I, se);
    
        % min area
    series(i).J = bwareaopen(series(i).J, minClusterArea);
end

% apply changes
for i = 1:numel(series)
    series(i).I = series(i).J;
    series(i).J = [];
end

% calc cluster area and location
[series.clusters]=deal(struct);
for i = 1:numel(series)
    CC = bwconncomp(series(i).I);
    
    tempCenters = regionprops(CC,'Centroid');
    centers = cat(1, tempCenters.Centroid);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    
    series(i).clusters.centers = centers;
    series(i).clusters.areas = numPixels';
    
end

deltas = struct;

for i = numel(series):-1:1
   delta = deltaClusterGrowth(series(i), series(i+1));
   deltas = [delta, deltas];
end
