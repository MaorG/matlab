function [clusters] = getClustersFromSeg2 (data, varargin)

   %data.Seg = data.Seg.getClusters;
    
    CC = bwconncomp(data.Seg.BWclusters);
    rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
    centers = cat(1, rp.Centroid);
    pixels = cell(numel(rp),1);
    for ii = 1:numel(rp)
        pixels{ii} = rp(ii).PixelList;
    end
    areas = cat(1, rp.Area);
    
    
    numOfClusters = numel(areas);
    % from array of structs to struct of arrays...

    clusters = struct;
    clusters.centers = centers;
    clusters.areas = areas;
    clusters.pixels = pixels;
    
%     clusters.Images = cell(numOfClusters,1);
%     clusters.cellIds = cell(numOfClusters,1);
%     clusters.count = zeros(numOfClusters,1);
%     
%     for i = 1:numOfClusters
%         clusters.Images{i} = data.Seg.clusters(i).Image;
%         clusters.cellIds{i} = data.Seg.clusters(i).cellIds;
%         clusters.count(i) = data.Seg.clusters(i).count;
%     end
    
    

end