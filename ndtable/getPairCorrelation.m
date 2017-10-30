function [result] = getPairCorrelation (data, varargin)
    
    dr = varargin{1}{1};
    type1 = varargin{1}{2};
    type2 = varargin{1}{3};

    world = data.world;
 
    [h, w] = size(world);
    if (type1 ~= 4)
        wt1 = world == type1;
    else 
        wt1 = world ~= 0;
    end
    wt1 = padarray(wt1, [floor(h/2),floor(w/2)], 'circular');
    
    if (type2 ~= 4)
        wt2 = world == type2;
    else
        wt2 = (world ~= 0 & world ~= type1);
    end
    wt2 = padarray(wt2, [floor(h/2),floor(w/2)]);
    
    [row1, col1] = find(wt1 ~= 0);
    [row2, col2] = find(wt2 ~= 0);
    
    maxr = ceil ( min(h, w) / 2 );
    
    if (numel(row1) == 0 || numel(row2) == 0)
        corr = zeros(1);
        r = zeros(1);
        r(1) = dr;
    else
%    [row2, col2] = find(world == type2);
        [corr, r, wr] = twopointcrosscorr(row1, col1, row2, col2, dr, maxr, 1000, false);
    end
    result = [r ; corr];

end

