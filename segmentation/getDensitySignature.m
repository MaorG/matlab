function [sig] = getDensitySignature (data, varargin)

props = parseInput(varargin{1});

radius = props.radius;
nBins = props.nBins;
threshold = props.threshold;

if  isfield(data, 'threshold')
    threshold = data.threshold;
end

I = data.(props.nameI) > threshold;

dx = -radius:radius;
dy = -radius:radius;
[DX, DY] = meshgrid(dx,dy);
disk = (DX.*DX)+(DY.*DY) <= radius*radius;
density = double(conv2(single(I),single(disk),'valid'));

[N,edges] = histcounts(log(density(:)),nBins);
sig = [N ; edges(2:end)];

end

function props = parseInput(varargin)
    props = struct(...
        'radius', 80,...
        'nBins', 100,...
        'threshold', 0.5,...
        'nameI', 'I'...
    );
    
    for i = 1:numel(varargin{1})
        if strcmpi(varargin{1}{i}, 'radius')
            props.radius = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'nBins')
            props.nBins = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'threshold')
            props.threshold = varargin{1}{i+1};
        elseif strcmpi(varargin{1}{i}, 'nameI')
            props.nameI = varargin{1}{i+1};
        end
    end
end
