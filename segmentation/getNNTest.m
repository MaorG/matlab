function [] = getNNTest(data, varargin)


% see
% http://www.seas.upenn.edu/~ese502/NOTEBOOK/Part_I/3_Testing_Spatial_Randomness.pdf

figure;
hold on;
iSize = size(data.I);

% real points

points = data.clusters.centers;
NNdists = getNNDists(points);
[N,B] = histcounts(NNdists);
plot(B(1:end-1),N,'b')

for i = 1:1000

cx = iSize(2) * rand(numel(points)/2, 1);
cy = iSize(1) * rand(numel(points)/2, 1);
rPoints = [cx, cy];

rNNdists = getNNDists(rPoints);
[N,B] = histcounts(rNNdists);
plot(B(1:end-1),N,'r:');

end

[N,B] = histcounts(NNdists);
plot(B(1:end-1),N,'b')


figure
imshow(data.Seg.BWcells)
hold on
plot(points(:,1),points(:,2), 'g*')
viscircles(points,NNdists)

sampledNNdists = NNdists(randperm(round(numel(NNdists)/2)));

npoints = numel(points)/2;
lambda = npoints / (iSize(2)*iSize(1));

expectedNNdist = 1/(2*sqrt(lambda));
expectedVarianceNNdist = (4 - pi)/(4*lambda*pi)

zm = ( mean(sampledNNdists) - expectedNNdist ) / sqrt(expectedVarianceNNdist)
end

function NNDists = getNNDists(points)

DT = delaunayTriangulation(points);
pairs = [DT.ConnectivityList(:,1), DT.ConnectivityList(:,2); DT.ConnectivityList(:,2), DT.ConnectivityList(:,3); DT.ConnectivityList(:,3), DT.ConnectivityList(:,1)];

dists = sqrt((points(pairs(:,1),1) - points(pairs(:,2),1)).^2 + (points(pairs(:,1),2) - points(pairs(:,2),2)).^2 );


npoints = numel(points)/2;
NNDists = inf(npoints,1);
for i = 1:numel(pairs)/2;
    pidx1 = pairs(i,1);
    pidx2 = pairs(i,2);
    tdist = dists(i);

    if (NNDists(pidx1) > tdist)
        NNDists(pidx1) = tdist;
    end
    if (NNDists(pidx2) > tdist)
        NNDists(pidx2) = tdist;
    end

end

end