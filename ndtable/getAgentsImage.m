function [RGB] = getAgentsImageCustom(data, varargin)

if nargin > 1
    res = varargin{1}{1};
end

% get world size
w = data.width;
h = data.height;
gridScale = data.scale;

if (numel(data.agents) == 0)
    I  = ones(w*gridScale*res, h*gridScale*res);
    RGB = repmat(I,[1,1,3]);
    return
end

% get agents properties


types = extractfield(data.agents, 'species');
X = extractfield(data.agents, 'X');
Y = extractfield(data.agents, 'Y');
radius = extractfield(data.agents, 'radius');

red = [];
green = [];
blue = [];
a = [];
try
    red = extractfield(data.agents, 'colorR');
    green = extractfield(data.agents, 'colorG');
    blue = extractfield(data.agents, 'colorB');
    attached = extractfield(data.agents, 'attached');
    a = attached * 0.5 + 0.5;
catch
end
% [~,~,ut] = unique(types);
% A = [ut';X;Y;radius;red;green;blue]';
% CX = accumarray(A(:,1),A(:,2),[],@(n){n});
% CY = accumarray(A(:,1),A(:,3),[],@(n){n});
% CR = accumarray(A(:,1),A(:,4),[],@(n){n});
% % todo - custumize
% 
% colorR = accumarray(A(:,1),A(:,5),[],@(n){n});
% colorG = accumarray(A(:,1),A(:,6),[],@(n){n});
% colorB = accumarray(A(:,1),A(:,7),[],@(n){n});


green(attached == 0) = 255.0;
red(attached == 0) = 0.0;
circles = res*[X; Y; radius]';
Colors = 0.75*(1/255)*[red; green; blue]';

% create base image
I  = ones(w*gridScale*res, h*gridScale*res);
RGB = repmat(I,[1,1,3]);

% create shape inserter and add circles for each element in C
   
shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',Colors);
    

if (numel(circles > 0))
    RGB = step(shapeInserter, RGB, circles);
end
    

end