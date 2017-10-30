function [ Iccp ] = ccPeriodic( I )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

B = bwlabel(I);

for v = max(max(B)):-1:1
    
    vals = getPeriodicConnectedVals ( B, v);
    
    minV = min(vals);
    
    for idx = 1:size(vals,1)
        B(B==vals(idx)) = minV;
    end
end
Iccp = B;

end

function  [ vals ] = getPeriodicConnectedVals ( I, val )
%find all values of connected components that belong to a periodic
%connected component with value val
vals = [val];
w = size(I,1);
h = size(I,2);

for x = 1:w
    if ( I(x,1) == val && I(x,h) ~= 0)
        vals = [vals ; I(x,h)];
    end
    if ( I(x,h) == val && I(x,1) ~= 0)
        vals = [vals ; I(x,1)];
    end
end
for y = 1:h
    if ( I(1,y) == val && I(w,y) ~= 0)
        vals = [vals ; I(w,y)];
    end
    if ( I(w,y) == val && I(1,y) ~= 0)
        vals = [vals ; I(1,y)];
    end
end

vals = sort(unique(vals));

end
