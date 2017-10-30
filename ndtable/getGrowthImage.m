function [RGB] = getGrowthImage(data, varargin)

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
mass = pi .* radius .* radius;
%ID = extractfield(data, 'clusters');
absGrowth = extractfield(data.agents, 'deltaMass');

relGrowth = absGrowth ./ mass;
maxAbsGrowth = 0.002;%max(relGrowth);
minRelGrowth = 0;%min(relGrowth);
normalizedRelGrowth = (relGrowth - minRelGrowth)./ (maxAbsGrowth - minRelGrowth);

Color = arrayfun(@(x) [0.5 + 0.5*(x), 0, 0.5 + 0.5 * (1 - x)], normalizedRelGrowth, 'UniformOutput', false);

circles = res*[X; Y; radius]';
%Color = arrayfun(@(x) colorByNum(x, numel(ID)), ID, 'UniformOutput', false);

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

function [c] = colorByNum(num, maxnum)


r = ( mod(floor(num), maxnum^(1/3) + 1 ) / maxnum^(1/3));
g = ( mod(floor(num), maxnum^(2/3) + 1 ) / maxnum^(2/3));
b = ( mod(floor(num), maxnum + 1 ) / maxnum );

c = 0.75*[r,g,b] + 0.25*[1,1,1];


end