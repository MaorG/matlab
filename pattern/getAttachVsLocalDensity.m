function AvLD = getAttachVsLocalDensity(data, varargin)

%params = parseInput(varargin);

nVarargs = length(varargin{1});
if (nVarargs == 3) 
    RclustersName = varargin{1}{1};
    GclustersName = varargin{1}{2};
    radius = varargin{1}{3};
end


Rclusters = data.(RclustersName);
Gclusters = data.(GclustersName);
imageSize = size(data.I);

countMap = false(imageSize); 

cc = data.Seg.getCellsProperty('Centroid');
Rcenters = cat(1,cc.Centroid);


for i = 1:size(Rcenters,1)
    px = round(Rcenters(i,1));  
    py = round(Rcenters(i,2)); 
    px = min(max(1,px),imageSize(1));
    py = min(max(1,py),imageSize(2));
    
    ind = sub2ind(imageSize, py, px);
    countMap(ind) = 1;
end

dx = -radius:radius;
dy = -radius:radius;
[DX, DY] = meshgrid(dx,dy);

disk = (DX.*DX)+(DY.*DY) <= radius*radius;

temp = countMap;
countMap = conv2(single(countMap),single(disk),'same');

counts = []; % TODO: preallocate
for pIdx = 1:numel(Gclusters.pixels)
    center = Gclusters.centers(pIdx,:);
    cx = round(center(1));
    cx = min(max(1,cx),data.Gclusters.imageSize(1));
    cy = round(center(2));
    cy = min(max(1,cy),data.Gclusters.imageSize(2));
    counts = [counts, countMap(cy,cx)];
end



% random scatter
allRndCounts = [];
viablePixels = find(~isnan(data.dpI));
for repeat = 1:1000
    randomIdx = randi([1,numel(viablePixels)],numel(Gclusters.pixels), 1);
    randomPixels = viablePixels(randomIdx);
    
    rndCounts = countMap(randomPixels)';
    
    allRndCounts = [allRndCounts; rndCounts];
end

AvLD.counts = counts;
AvLD.rndCounts = allRndCounts;

end
    
    