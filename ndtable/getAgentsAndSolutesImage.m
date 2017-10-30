function [RGB] = getAgentsAndSolutesImage(data, varargin)

if nargin > 1
    res = varargin{1}{1};
end

% get world size
w = data.width;
h = data.height;
gridScale = data.scale;

% get agents properties

types = extractfield(data.agents, 'species');
X = extractfield(data.agents, 'X');
Y = extractfield(data.agents, 'Y');
R = extractfield(data.agents, 'radius');

[~,~,ut] = unique(types);
A = [ut';X;Y;R]';
CX = accumarray(A(:,1),A(:,2),[],@(n){n});
CY = accumarray(A(:,1),A(:,3),[],@(n){n});
CR = accumarray(A(:,1),A(:,4),[],@(n){n});
% todo - custumize
Colors = [uint8([255 255 0]) ; uint8([255 0 0]) ; uint8([255 255 255])];

% create base image
I  = zeros(w*gridScale*res, h*gridScale*res);
RGB = repmat(I,[1,1,3]);

% create shape inserter and add circles for each element in C
for i = 1:numel(CX)
    
    shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',Colors(i,:));
    
    circles = res*[CX{i}, CY{i}, CR{i}];

    RGB = step(shapeInserter, RGB, circles);
    
end

end