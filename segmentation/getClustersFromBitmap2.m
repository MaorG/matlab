function [clusters] = getClustersFromBitmap2 (data, varargin)

props = parseInput(varargin{1});

minClusterArea = props.minClusterArea;
clusterDilation = props.clusterDilation;
threshold = props.threshold;

if  isfield(data, 'threshold')
    threshold = data.threshold;
end

nameI = props.nameI;

I = data.(nameI);

I = I > threshold;

% connect clusters
se = strel('disk',clusterDilation);
J = imclose(I, se);

% min area
J = bwareaopen(J, minClusterArea);

% apply changes
I = J;

% extract cluster location
clusters = struct;

CC = bwconncomp(I);

rp = regionprops(CC, 'Centroid', 'PixelList', 'Area');
centers = cat(1, rp.Centroid);
pixels = cell(numel(rp),1);
for ii = 1:numel(rp)
    pixels{ii} = rp(ii).PixelList;
end
areas = cat(1, rp.Area);

ids = find(areas > minClusterArea);

clusters.centers = centers(ids,:);
clusters.areas = areas(ids,:);
clusters.pixels = pixels(ids,:);
clusters.imageSize = size(I);

end

function props = parseInput(varargin)
    props = struct(...
        'minClusterArea', 10,...
        'clusterDilation', 4,...
        'threshold', 0.5,...
        'nameI', 'I'...
    );
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'minClusterArea')
            props.minClusterArea = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'clusterDilation')
            props.clusterDilation = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'threshold')
            props.threshold = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'nameI')
            props.nameI = varargin{1}{i+1};
        end
    end
end
