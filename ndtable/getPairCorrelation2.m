function [result] = getPairCorrelation (data, varargin)

nVarargs = length(varargin{1});

if nVarargs == 3
    type1 = varargin{1}(1);
    type1 = type1{1};
    type2 = varargin{1}(2);
    type2 = type2{1};
    dr = varargin{1}(3);
    dr = dr{1};
end

world = data.world;
result = [];

h = size(world,1);
w = size(world,2);

if (type1 ~= 0)
    [row1, col1] = find(world == type1);
else
    [row1, col1] = find(world ~= 0);
end
if (type2~= 0)
    [row2, col2] = find(world == type2);
else
    [row2, col2] = find(world ~= 0);
end
%rs = rmin:dr:rmax;

distances = [];

if (type1 == type2)
    for ii = 1:size(row1,1)-1
        for jj = ii:size(row1,1)
            distance = sqrt((row1(ii) - row1(jj))^2 + (col1(ii) - col1(jj))^2);
            distances = [distances, distance];
            
        end
    end
else
    for ii = 1:size(row1,1)
        for jj = 1:size(row2,1)
            distance = sqrt((row1(ii) - row2(jj))^2 + (col1(ii) - col2(jj))^2);
            distances = [distances, distance];
        end
    end
end
rmax = floor(sqrt(h^2 + w^2) / 2);
edges = 0:dr:rmax;
N = histcounts(distances,edges);
edges = edges(2:end);
result = [ N; edges];
end