function [result] = getMinDistanceDistribution (input, varargin)

    world = input.world;
    
    w1 = (world == 1);
    w2 = (world == 2);
    
    d1 = bwdist(w2);
    d2 = bwdist(w1);
    
    ad1 = d1 .* logical(w1);
    ad2 = d2 .* logical(w2);
    
    [h1, b1] = histcounts( ad1,[1:4:49]');
    [h2, b2] = histcounts( ad2,[1:4:49]');

    result = h1+h2;
    
end