function [BG] = getBGMorph(data, varargin)
props = parseVarargin(varargin{1});

I = data.(props.imageName);
radius = props.radius;

BG = imopen(I,strel('disk',radius));

end


function props = parseVarargin(v)
% default:
props = struct(...
    'imageName', 'I',...
    'radius', 10 ...
    );

for i = 1:numel(v)
    
    if (strcmp(v{i}, 'imageName'))
        props.imageName = v{i+1};
    elseif (strcmp(v{i}, 'radius'))
        props.radius = v{i+1};
    end
end

end