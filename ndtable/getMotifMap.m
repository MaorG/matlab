function [result] = getMotifMap (input, varargin)


pWorld = padarray(input.world, [1 1], 'circular');

[w, h] = size(pWorld);
[X, Y] = meshgrid(1:w,1:h);
X = X(2:end-1, 2:end-1);
Y = Y(2:end-1, 2:end-1);

[row1, col1] = find(input.world == 1);

keys = arrayfun(@(x, y) getKeyOfLocation(pWorld, x, y), row1+1, col1+1, 'UniformOutput', false);

map = containers.Map();

%...

for i = 1:numel(keys)
    if isKey(keys)
    end
end

result = map;

    

end

function [key] = getKeyOfLocation (pWorld, px, py)
%p for padded - by 1 for now

%keyVector = [pWorld(px-1,py), pWorld(px,py+1), pWorld(px-1,py), pWorld(px,py-1)];
 
v = [pWorld(px-1,py), pWorld(px,py+1), pWorld(px-1,py), pWorld(px,py-1)];
b = 1:numel(v);
b = (v.*(4.^b));

% int?
key = sum(b);

end


function [canonicalKeyVector] = findCanonicalKey (keyVector)
    
% get all symmetric keys, find the first in lexical order




end