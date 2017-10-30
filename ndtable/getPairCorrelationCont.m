function [result] = getPairCorrelationCont (data, varargin)
    
    parameters1 = varargin{1}{1};
    parameters2 = varargin{1}{2};
    dr = varargin{1}{3};
    maxr = varargin{1}{4};

    %maxr = ceil ( min(h, w) / 2 );
    
    w = data.width * data.scale;
    h = data.height * data.scale;
    
    i1 = getAgentIndcesByProperties(data, parameters1);
    i2 = getAgentIndcesByProperties(data, parameters2);
  
    
    x = extractfield(data.agents, 'X')';
    y = extractfield(data.agents, 'Y')';

    x1 = x(i1);
    x2 = x(i2);
    y1 = y(i1);
    y2 = y(i2);

    % toroidal world, wrap x2 y2
    i2left = find(x2 < maxr);
    i2right = find(x2 > h - maxr);
    
    newX2 = [x2; x2(i2left) + w ; x2(i2right) - w];
    newY2 = [y2; y2(i2left); y2(i2right)];
    
    i2top = find(newY2 < maxr);
    i2bottom = find(newY2 > h - maxr);
    newX2 = [newX2; newX2(i2top); newX2(i2bottom)];
    newY2 = [newY2; newY2(i2top) + h; newY2(i2bottom) - h];
    

    
    if (numel(x1) == 0 || numel(x2) == 0)
        corr = zeros(1);
        r = zeros(1);
        r(1) = dr;
    else
%    [row2, col2] = find(world == type2);
        [corr, r, wr] = twopointcrosscorr(x1, y1, newX2, newY2, dr, maxr, 1000, false);
    end
    result = [r ; corr];

end

