function [RGB] = getAgentsImageCustom(data, varargin)

if nargin > 1
    res = varargin{1}{1};
end

% get world size
w = data.width;
h = data.height;
gridScale = data.scale;

t = data.ticks;
bg = [1.0, 1.0, 1.0];
if (mod(t,2000)>1000)
   bg =  [249/255, 249/255, 249/255];
else
   bg = [140/255, 225/255, 240/255];
end



if (numel(data.agents) == 0)
    I  = ones(w*gridScale*res, h*gridScale*res);
    RGB = repmat(I,[1,1,3]);
    return
end

% get agents properties


types = extractfield(data.agents, 'species');
spe1 = strcmp(types,'dbact1');
spe2 = strcmp(types,'dbact2');

alive = spe1 | spe2;

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

catch
end


green(alive == 0) = 32;
red(alive == 0) = 32;
blue(alive == 0) = 32;

green(spe2 == 1) = 255.0;
red(spe2 == 1) = 0.0;

blue(attached == 0) = 255.0;
circles = res*[X; Y; radius]';
Colors = 0.75*(1/255)*[red; green; blue]';

% create base image
I  = ones(w*gridScale*res, h*gridScale*res);
RGB = repmat(I,[1,1,3]);

R = repmat(bg(1),[w*gridScale*res, h*gridScale*res]);
G = repmat(bg(2),[w*gridScale*res, h*gridScale*res]);
B = repmat(bg(3),[w*gridScale*res, h*gridScale*res]);
RGB = cat(3,R,G,B);

% create shape inserter and add circles for each element in C
   
shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,'FillColor','Custom','CustomFillColor',Colors);
    

if (numel(circles > 0))
    RGB = step(shapeInserter, RGB, circles);
end
    

end