function [] = showAgents(data, res)

% get world size
w = data.parameters.width;
h = data.parameters.height;
gridScale = data.parameters.scale;

% get agents properties

X = extractfield(data.agents, 'X');
Y = extractfield(data.agents, 'Y');
R = extractfield(data.agents, 'radius');

% create shape inserter
yellow = uint8([255 255 0]);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',yellow);

circles = res*[X;Y;R]';

I  = zeros(w*gridScale*res, h*gridScale*res);

RGB = repmat(I,[1,1,3]);

J = step(shapeInserter, RGB, circles);

imshow(J);


end