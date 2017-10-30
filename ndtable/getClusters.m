function [ids] = getClusters (data, varargin)

tol = 0.1;
nVarargs = length(varargin{1});
if (nVarargs == 1) 
    tol = varargin{1}{1};
end

if (numel(data.agents) == 0)
    ids = [];
    return
end

width = data.width*data.scale;
height = data.height*data.scale;
x = extractfield(data.agents, 'X')';
y = extractfield(data.agents, 'Y')';
r = extractfield(data.agents, 'radius')';
a = extractfield(data.agents, 'attached')';

% ignore non attached
iaroll = find(a ~= 0);


if (numel(iaroll) == 0)
    ids = [];
    return
end

x = x(iaroll);
y = y(iaroll);
r = r(iaroll);

rMax = max(r);
ixroll = find(x < 2*rMax + tol);
newX = [x; x(ixroll) + width];
newY = [y; y(ixroll)];
newR = [r; r(ixroll)];
rollIndices = [1:numel(x), ixroll'];
iyroll = (find(newY < 2*rMax + tol));
newX = [newX; newX(iyroll)];
newY = [newY; newY(iyroll) + height];
newR = [newR; newR(iyroll)];
rollIndices = [rollIndices, rollIndices(iyroll)];

DT = delaunayTriangulation(newX,newY);


triN = numel(DT.ConnectivityList);

if (triN == 0)
    ids = 1:numel(extractfield(data.agents, 'X'));
    return; 
end
pairs = [DT.ConnectivityList(:,1), DT.ConnectivityList(:,2); DT.ConnectivityList(:,2), DT.ConnectivityList(:,3); DT.ConnectivityList(:,3), DT.ConnectivityList(:,1)];


ngh1 = zeros(triN,1);
ngh2 = zeros(triN,1);
D = zeros(triN,1);

count = 0;
for i = 1:size(pairs,1)
     i1 = pairs(i,1);
     i2 = pairs(i,2);

    x1 = newX(i1);
    y1 = newY(i1);
    r1 = newR(i1);
    x2 = newX(i2);
    y2 = newY(i2);
    r2 = newR(i2);
    centersDist = sqrt((x1-x2)^2 + (y1-y2)^2);
    effectiveDist = centersDist - r1 - r2;

    ngh1(i) = (i1);
    ngh2(i) = (i2);
    D(i) = effectiveDist < tol;
end

% connect rolled indices!
ngh1 = [ngh1; ((numel(x) + 1):numel(rollIndices))'];
ngh2 = [ngh2; (rollIndices((numel(x) + 1):numel(rollIndices)))'];
D = [D; ones(numel(rollIndices) - (numel(x)),1)];
ngh2 = [ngh2; ((numel(x) + 1):numel(rollIndices))'];
ngh1 = [ngh1; (rollIndices((numel(x) + 1):numel(rollIndices)))'];
D = [D; ones(numel(rollIndices) - (numel(x)),1)];

% connected components
Edges = sparse(ngh1, ngh2, D);
[~,C] = conncomp(Edges);


ids = nan(numel(a),1);
% discard rolled indices
C = C(1:numel(x));
% put into entire pop (attached + non attached)
ids(iaroll) = C;



end 

function [S,C] = conncomp(G)
  [p,q,r] = dmperm(G'+speye(size(G)));
  S = numel(r)-1;
  C = cumsum(full(sparse(1,r(1:end-1),1,1,size(G,1))));
  C(p) = C;
end

