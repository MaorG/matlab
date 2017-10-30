function [RGB] = getClustersImage(data, varargin)

if nargin > 1
    res = varargin{1}{1};
end

% get world size
w = data.width;
h = data.height;
gridScale = data.scale;

if (numel(data.agents) == 0)
    I  = zeros(w*gridScale*res, h*gridScale*res);
    RGB = repmat(I,[1,1,3]);
    return
end
% get agents properties

types = extractfield(data.agents, 'species');
X = extractfield(data.agents, 'X');
Y = extractfield(data.agents, 'Y');
radius = extractfield(data.agents, 'radius');
ID = extractfield(data, 'clusters');

a = extractfield(data.agents, 'attached');

X = X(find(a));
Y = Y(find(a));
radius = radius(find(a));
ID = ID(find(a));

[uID, ~, iuID] = unique(ID);

CColors = hsv(numel(unique(uID)));

circles = res*[X; Y; radius]';
Color = arrayfun(@(x) CColors(x,:), iuID, 'UniformOutput', false);
% eewww
Colors = zeros(size(Color,2),3);
for i = 1:numel(Color)
    Colors(i,:) = Color{i};
end
% create base image
I  = zeros(w*gridScale*res, h*gridScale*res);
RGB = repmat(I,[1,1,3]);

% create shape inserter and add circles for each element in C

if (~isempty(Colors))
    shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',Colors);
    RGB = step(shapeInserter, RGB, circles);
end




end

