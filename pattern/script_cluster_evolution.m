% dirNameSeg = 'C:\school\microscopy\exp170405\dist\bimodal\Seg\';
% 
% series = dir2data(dirNameSeg, false);
% 
% for i = 1:numel(series)
%     series(i).time = str2double(series(i).fileName(9:10));
%     
% end


minClusterArea = 10;
clusterDilation = 2;

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

% extract cluster location
[series.clusters]=deal(struct);
for i = 1:numel(series)
    CC = bwconncomp(series(i).I);
    
    rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
    centers = cat(1, rp.Centroid);
    pixels = cell(numel(rp),1);
    for ii = 1:numel(rp)
        pixels{ii} = rp(ii).PixelList;
    end
    areas = cat(1, rp.Area);
    
    ids = find(areas > minClusterArea);
    
    series(i).clusters.centers = centers(ids,:);
    series(i).clusters.areas = areas(ids,:);
    series(i).clusters.pixels = pixels(ids,:);
    
end

