function [result] = getMixScaleABC (input, varargin)

    world = input.world;
    w = size(world, 1);
    h = size(world, 2);
    tiled = repmat(world,2);
    
    max_scale = min([w,h]) / 2;
    scale = 2;
    ratioAtScale = [];

    nVarargs = length(varargin{1});
    for arg = 1:nVarargs
        ratioAtScale = [ ratioAtScale ; [varargin{1}{arg}, (double(calcMixAtScale(tiled, w, h, varargin{1}{arg})))]];
    end
    
    result = ratioAtScale;

end

function [ratio] = calcMixAtScale (tiledworld, w, h, scale)

    count = 0;
    countMix = 0;
    for i = 1:w
        for j = 1:h
           croppedWorld = tiledworld(i:(i+scale), j:(j+scale));
           if any(0~=croppedWorld(:))
               count = count + 1;
           end
           if (any(1==croppedWorld(:)) && any(2==croppedWorld(:)) && any(3==croppedWorld(:)))
               countMix = countMix + 1;
           end
        end
    end
    
    ratio = ( double(countMix) / double(count) );
end