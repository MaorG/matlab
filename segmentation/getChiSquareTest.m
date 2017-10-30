function chisqr = getChiSquareTest(data, varargin)

nVarargs = length(varargin{1});
if (nVarargs == 1) 
    divisions = varargin{1}{1};
end

% real points
points = data.clusters.centers;
iSize = size(data.I);

windowSizeX = floor(iSize(2) ./ divisions);
windowSizeY = floor(iSize(1) ./ divisions);

counts = getCounts(points, divisions, windowSizeX, windowSizeY);
countsHist = histcounts(counts, 0:numel(points)/2);

rCountsHists = [] % init size
% random points
for i = 1:1000

cx = iSize(2) * rand(numel(points)/2, 1);
cy = iSize(1) * rand(numel(points)/2, 1);
rPoints = [cx, cy];

rCounts = getCounts(rPoints, divisions, windowSizeX, windowSizeY);
rCountsHist = histcounts(rCounts, 0:numel(points)/2);

rCountsHists = [rCountsHists; rCountsHist];

end
% trim zero columns

nonZerosColsIdx = sum([rCountsHists; countsHist],1) > 0

countsHist = countsHist(nonZerosColsIdx)
rCountsHists = rCountsHists(:,nonZerosColsIdx)

sortedRCountsHist = sort(rCountsHists,1);

figure
hold on
X = 0:sum(nonZerosColsIdx)-1;
plot(X,countsHist,'b-');
plot(X,sortedRCountsHist(50,:),'r--');
plot(X,sortedRCountsHist(951,:),'r--');
%set(gca,'yscale','log');

% 
elements = (((counts - sum(counts))/(divisions*divisions)).^2)/(sum(counts))/(divisions*divisions);
chisqr = sum(elements);



end

function counts = getCounts(points, divisions, windowSizeX, windowSizeY)

counts = zeros(divisions*divisions,1);

centersX = points(:,1);
centersY = points(:,2);
windowXi = ceil(centersX / windowSizeX);
windowYi = ceil(centersY / windowSizeY);

% removing points in smaller rects
inXidx = (windowXi <= divisions);
windowXi = windowXi(inXidx);
windowYi = windowYi(inXidx);
inYidx = (windowYi <= divisions);
windowXi = windowXi(inYidx);
windowYi = windowYi(inYidx);

for i = 1:numel(windowXi)
    counts(windowXi(i) + divisions*(windowYi(i) - 1)) = counts(windowXi(i) + divisions*(windowYi(i) - 1)) + 1;
end


end