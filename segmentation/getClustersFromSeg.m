function [clusters] = getClustersFromSeg (data, varargin)

   props = parseInput(varargin{1});
   
   Seg = data.(props.SegName);
   Seg = Seg.getClusters;
    
    CC = bwconncomp(Seg.BWclusters);
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
    
    clusters.Images = cell(numOfClusters,1);
    clusters.cellIds = cell(numOfClusters,1);
    clusters.count = zeros(numOfClusters,1);
    
    for i = 1:numOfClusters
        %clusters.Images{i} = Seg.clusters(i).Image;
        clusters.cellIds{i} = Seg.clusters(i).cellIds;
        clusters.count(i) = Seg.clusters(i).count;
    end
    
end

function props = parseInput(varargin)
    props = struct('SegName','Seg');
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'SegName')
            props.SegName = varargin{1}{i+1};
        end
    end
end